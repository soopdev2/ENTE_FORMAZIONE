 ///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
package servlet;
//
///**
// *
// * @author Aldo
// */
import Utility.JpaUtil;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import entity.User;
import it.spid.cie.oidc.callback.RelyingPartyLogoutCallback;
import it.spid.cie.oidc.config.RelyingPartyOptions;
import it.spid.cie.oidc.exception.OIDCException;
import it.spid.cie.oidc.handler.RelyingPartyHandler;
import it.spid.cie.oidc.model.AuthnRequest;
import it.spid.cie.oidc.model.AuthnToken;
import it.spid.cie.oidc.persistence.JdbcPersistenceAdapter;
import it.spid.cie.oidc.persistence.PersistenceAdapter;
import it.spid.cie.oidc.util.ArrayUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.io.IOException;
import java.util.*;
import java.util.logging.Level;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.util.logging.Logger;
import org.json.JSONObject;

public class Spid extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(Spid.class.getName());

    private final EntityManager em = JpaUtil.getEntityManager();

    private final RelyingPartyHandler relyingPartyHandler;

    // ============================================================
    // COSTRUTTORE
    // ============================================================
    public Spid() throws OIDCException {


        RelyingPartyOptions options = initializeRelyingPartyOptions();

        PersistenceAdapter persistenceAdapter = initializePersistenceAdapter();

        relyingPartyHandler = new RelyingPartyHandler(
                options,
                persistenceAdapter);
    }

    // ============================================================
    // AVVIO LOGIN SPID
    // ============================================================
    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException, OIDCException {

        String provider = request.getParameter("provider");

        String entityId = request.getParameter("entity_id");

        String profile = "spid";

        String trustAnchor = "";

        String scope = "openid";

        if (provider == null || !provider.matches("^[a-zA-Z0-9._-]+$")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if (entityId == null || !entityId.matches("^[a-zA-Z0-9._:/-]+$")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String authURL = relyingPartyHandler.getAuthorizeURL(
                provider,
                trustAnchor,
                entityId,
                profile,
                scope);

        response.sendRedirect(authURL);
    }

    // ============================================================
    // CALLBACK SPID
    // ============================================================
    private void handleCallback(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException, ServletException {

        String code = req.getParameter("code");

        String state = req.getParameter("state");

        try {

            // ====================================================
            // RECUPERO DATI DA SPID
            // ====================================================
            JSONObject userInfo = relyingPartyHandler.getUserInfo(
                    state,
                    code);

            String codiceFiscale = userInfo.optString(
                    "fiscal_number",
                    "");

            // ====================================================
            // CONTROLLO CODICE FISCALE
            // ====================================================
            if (codiceFiscale == null
                    || codiceFiscale.isBlank()) {

                LOGGER.warning(
                        "SPID non ha restituito il codice fiscale");

                resp.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Impossibile identificare l'utente tramite SPID");

                return;
            }

            // ====================================================
            // RICERCA UTENTE GIÀ REGISTRATO
            // ====================================================
            User user = null;

            try {

                em.getTransaction().begin();

                TypedQuery<User> query = em.createQuery(
                        "SELECT u FROM User u "
                        + "WHERE u.cf = :cf",
                        User.class);

                query.setParameter(
                        "cf",
                        codiceFiscale);

                user = query.getResultStream()
                        .findFirst()
                        .orElse(null);

                // =================================================
                // UTENTE NON REGISTRATO
                // =================================================
                if (user == null) {

                    em.getTransaction().rollback();

                    LOGGER.info(
                            "Tentativo di accesso SPID "
                            + "da parte di utente non registrato: "
                            + codiceFiscale);

                    resp.sendError(
                            HttpServletResponse.SC_UNAUTHORIZED,
                            "Utente non registrato. "
                            + "Registrarsi prima sul sito principale.");

                    return;
                }

                /*
                                 * L'utente è già presente nel database.
                                 *
                                 * NON viene creato nessun nuovo User.
                                 * NON viene eseguito persist().
                                 * NON vengono modificati dati.
                 */
                em.getTransaction().commit();

            } catch (IOException ex) {

                if (em
                        .getTransaction()
                        .isActive()) {

                    em
                            .getTransaction()
                            .rollback();
                }

                LOGGER.log(
                        Level.SEVERE,
                        "Errore durante il recupero dell'utente",
                        ex);

                resp.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Errore durante il recupero dell'utente");

                return;
            }

            // ====================================================
            // LOGIN RIUSCITO
            // ====================================================
            HttpSession session = req.getSession(true);

            session.setAttribute(
                    "userSPID",
                    user);

            // ====================================================
            // ACCESSO AL SITO
            // ====================================================
            resp.sendRedirect(
                    req.getContextPath()
                    + "/dashboard.jsp");

        } catch (OIDCException ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Errore durante il callback SPID",
                    ex);

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore callback SPID: "
                    + ex.getMessage());
        }
    }

    // ============================================================
    // LOGOUT
    // ============================================================
    private void handleLogout(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/index.jsp");

            return;
        }

        User user = (User) session.getAttribute(
                "userSPID");

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/index.jsp");

            return;
        }

        String userKey = user.getCf();

        try {

            String redirectURL = relyingPartyHandler.performLogout(
                    userKey,
                    new RelyingPartyLogoutCallback() {

                public void onLogoutSuccess() {

                    HttpSession currentSession = req.getSession(false);

                    if (currentSession != null) {

                        currentSession.invalidate();
                    }
                }

                public void onLogoutError(
                        OIDCException ex) {

                    LOGGER.log(
                            Level.SEVERE,
                            "Errore durante il logout SPID",
                            ex);
                }

                @Override
                public void logout(
                        String userKey,
                        AuthnRequest authnRequest,
                        AuthnToken authnToken) {
                }
            });

            resp.sendRedirect(
                    redirectURL);

        } catch (OIDCException ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Errore durante il logout SPID",
                    ex);

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    ex.getMessage());
        }
    }

    // ============================================================
    // CONFIGURAZIONE PERSISTENZA SPID
    // ============================================================
    private PersistenceAdapter initializePersistenceAdapter() {

        JdbcPersistenceAdapter jdbcPersistenceAdapter = new JdbcPersistenceAdapter();

        HikariConfig hikariConfig = new HikariConfig();

        hikariConfig.setJdbcUrl(
                "jdbc:mysql://127.0.0.1:3306/spid");

        hikariConfig.setUsername(
                "spid");

        hikariConfig.setPassword(
                "spid");

        hikariConfig.setDriverClassName(
                "com.mysql.cj.jdbc.Driver");

        HikariDataSource dataSource = new HikariDataSource(
                hikariConfig);

        jdbcPersistenceAdapter.setDataSource(
                dataSource);

        jdbcPersistenceAdapter.setTablePrefix(
                "spid_");

        jdbcPersistenceAdapter.setLoggingLevel(
                Level.INFO);

        return jdbcPersistenceAdapter;
    }

    // ============================================================
    // CONFIGURAZIONE SPID
    // ============================================================
    private RelyingPartyOptions initializeRelyingPartyOptions() {

        Map<String, String> spidProviders = new HashMap<>();

        spidProviders.put(
                "SPID_PROVIDER_SUBJECT_ID",
                "TRUST_ANCHOR");

        Map<String, List<String>> trustMarkIssuers = new HashMap<>();

        trustMarkIssuers.put(
                "https://registry.agid.gov.it/openid_relying_party/public/",
                Arrays.asList(
                        "https://registry.spid.agid.gov.it/",
                        "https://public.intermediate.spid.it/"));

        return new RelyingPartyOptions()
                .setDefaultTrustAnchor(
                        "DEFAULT_TRUST_ANCHOR")
                .setClientId(
                        "RELYING_PARTY_SUBJECT_ID")
                .setSPIDProviders(
                        spidProviders)
                .setTrustAnchors(
                        ArrayUtil.asSet(
                                "TRUST_ANCHOR"))
                .setApplicationName(
                        "Sample RP")
                .setRedirectUris(
                        ArrayUtil.asSet(
                                "http://localhost:8091/ENTE_FORMAZIONE/Spid?callback=true"))
                .setJWK(
                        "RELYING_PARTY_JWK_STRING")
                .setTrustMarks(
                        "RELYING_PARTY_TRUST_MARKS")
                .setTrustMarkIssuers(
                        trustMarkIssuers);
    }

    // ============================================================
    // GET
    // ============================================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            if (request.getParameter(
                    "callback") != null) {

                handleCallback(
                        request,
                        response);

            } else if ("logout".equals(
                    request.getParameter(
                            "action"))) {

                handleLogout(
                        request,
                        response);

            } else {

                processRequest(
                        request,
                        response);
            }

        } catch (OIDCException ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Errore OIDC",
                    ex);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore OIDC: "
                    + ex.getMessage());
        }
    }

    // ============================================================
    // POST
    // ============================================================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            processRequest(
                    request,
                    response);

        } catch (OIDCException ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Errore OIDC",
                    ex);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore OIDC: "
                    + ex.getMessage());
        }
    }
}










































//----------------------------------------------------------------

// TEST DI SVILUPPO

//----------------------------------------------------------------

//
//
//
//
//
//package servlet;
//
//import Utility.JpaUtil;
//import entity.User;
//
//import jakarta.persistence.EntityManager;
//import jakarta.persistence.TypedQuery;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//import java.io.IOException;
//import java.util.Set;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class Spid extends HttpServlet {
//
//    private static final Logger LOGGER
//            = Logger.getLogger(Spid.class.getName());
//
//    /*
//     * MODALITÀ DI SVILUPPO
//     *
//     * Deve rimanere true esclusivamente nell'ambiente locale.
//     * Prima della pubblicazione deve essere disabilitata.
//     */
//    private static final boolean DEV_MODE = true;
//
//    /*
//     * Inserisci il codice fiscale di un utente di test
//     * GIÀ ESISTENTE nel database FAD VIDEO.
//     *
//     * Non utilizzare questo valore segnaposto.
//     */
//    private static final String DEV_TEST_CF
//            = "MNCLDA97P28C352V";
//
//    /*
//     * Identity Provider consentiti durante lo sviluppo.
//     */
//    private static final Set<String> ALLOWED_IDPS = Set.of(
//            "https://loginspid.aruba.it",
//            "https://identity.infocert.it",
//            "https://spid.intesa.it",
//            "https://id.lepida.it/idp/shibboleth",
//            "https://idp.namirialtsp.com/idp",
//            "https://posteid.poste.it",
//            "https://identity.sieltecloud.it",
//            "https://spid.register.it",
//            "https://login.id.tim.it/affwebservices/public/saml2sso",
//            "https://spid.teamsystem.com/idp"
//    );
//
//    /*
//     * Accetta esclusivamente richieste provenienti
//     * dalla macchina locale.
//     */
//    private boolean isLocalRequest(HttpServletRequest request) {
//
//        String remoteAddress = request.getRemoteAddr();
//
//        return "127.0.0.1".equals(remoteAddress)
//                || "::1".equals(remoteAddress)
//                || "0:0:0:0:0:0:0:1".equals(remoteAddress)
//                || "::ffff:127.0.0.1".equals(remoteAddress);
//    }
//
//    /*
//     * Avvio della simulazione SPID.
//     */
//    private void processDevelopmentLogin(
//            HttpServletRequest request,
//            HttpServletResponse response)
//            throws IOException {
//
//        if (!DEV_MODE) {
//            response.sendError(
//                    HttpServletResponse.SC_FORBIDDEN,
//                    "Modalità SPID di sviluppo disabilitata."
//            );
//            return;
//        }
//
//        if (!isLocalRequest(request)) {
//            LOGGER.warning(
//                    "Tentativo di accesso SPID DEV non locale."
//            );
//
//            response.sendError(
//                    HttpServletResponse.SC_FORBIDDEN,
//                    "Accesso consentito soltanto da localhost."
//            );
//            return;
//        }
//
//        /*
//         * Recupero parametri inviati dal JavaScript.
//         */
//        String provider = request.getParameter("provider");
//        String entityId = request.getParameter("entity_id");
//
//        if (provider == null || provider.isBlank()) {
//            response.sendError(
//                    HttpServletResponse.SC_BAD_REQUEST,
//                    "Provider SPID mancante."
//            );
//            return;
//        }
//
//        if (entityId == null || !ALLOWED_IDPS.contains(entityId)) {
//            response.sendError(
//                    HttpServletResponse.SC_BAD_REQUEST,
//                    "Identity Provider non riconosciuto."
//            );
//            return;
//        }
//
//        /*
//         * Verifica configurazione utente di test.
//         */
//        if (DEV_TEST_CF == null
//                || DEV_TEST_CF.equals("INSERISCI_CF_UTENTE_TEST")
//                || !DEV_TEST_CF.matches("^[A-Z0-9]{16}$")) {
//
//            LOGGER.severe(
//                    "Codice fiscale dell'utente SPID DEV non configurato."
//            );
//
//            response.sendError(
//                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
//                    "Configurare il codice fiscale dell'utente di test "
//                    + "in Spid.java."
//            );
//            return;
//        }
//
//        User user = findUserByFiscalCode(DEV_TEST_CF);
//
//        if (user == null) {
//
//            LOGGER.warning(
//                    "Utente SPID DEV non trovato nel database."
//            );
//
//            response.sendError(
//                    HttpServletResponse.SC_UNAUTHORIZED,
//                    "Utente di test non presente nel database FAD VIDEO."
//            );
//
//            return;
//        }
//
//        /*
//         * Creazione sessione applicativa.
//         */
//        HttpSession oldSession = request.getSession(false);
//
//        if (oldSession != null) {
//            oldSession.invalidate();
//        }
//
//        HttpSession session = request.getSession(true);
//
//        session.setAttribute("userSPID", user);
//
//        session.setAttribute("spidDevelopmentMode", true);
//
//        session.setAttribute("spidProvider", entityId);
//
//        LOGGER.info(
//                "Accesso SPID DEV effettuato. Provider: "
//                + entityId
//        );
//
//        /*
//         * Accesso alla dashboard.
//         */
//        response.sendRedirect(
//                request.getContextPath() + "/dashboard.jsp"
//        );
//    }
//
//    /*
//     * Ricerca dell'utente già registrato tramite codice fiscale.
//     */
//    private User findUserByFiscalCode(String codiceFiscale) {
//
//        EntityManager em = null;
//
//        try {
//
//            em = JpaUtil.getEntityManager();
//
//            TypedQuery<User> query = em.createQuery(
//                    "SELECT u FROM User u WHERE u.cf = :cf",
//                    User.class
//            );
//
//            query.setParameter("cf", codiceFiscale);
//
//            query.setMaxResults(1);
//
//            return query.getResultStream()
//                    .findFirst()
//                    .orElse(null);
//
//        } catch (RuntimeException ex) {
//
//            LOGGER.log(
//                    Level.SEVERE,
//                    "Errore durante la ricerca dell'utente SPID DEV.",
//                    ex
//            );
//
//            throw ex;
//
//        } finally {
//
//            if (em != null && em.isOpen()) {
//                em.close();
//            }
//        }
//    }
//
//    /*
//     * GET:
//     * Non viene effettuata autenticazione tramite GET
//     * in modalità di sviluppo.
//     */
//    @Override
//    protected void doGet(
//            HttpServletRequest request,
//            HttpServletResponse response)
//            throws ServletException, IOException {
//
//        response.sendError(
//                HttpServletResponse.SC_METHOD_NOT_ALLOWED,
//                "Utilizzare POST per avviare il login SPID DEV."
//        );
//    }
//
//    /*
//     * POST:
//     * Avvia la simulazione di autenticazione.
//     */
//    @Override
//    protected void doPost(
//            HttpServletRequest request,
//            HttpServletResponse response)
//            throws ServletException, IOException {
//
//        try {
//
//            processDevelopmentLogin(request, response);
//
//        } catch (RuntimeException ex) {
//
//            LOGGER.log(
//                    Level.SEVERE,
//                    "Errore durante il login SPID DEV.",
//                    ex
//            );
//
//            if (!response.isCommitted()) {
//                response.sendError(
//                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
//                        "Errore durante l'accesso SPID di sviluppo."
//                );
//            }
//        }
//    }
//}
