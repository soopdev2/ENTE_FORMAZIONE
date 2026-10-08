/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

/**
 *
 * @author Aldo
 */
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
                    + "/home.jsp");

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
                    + "/login.jsp");

            return;
        }

        User user = (User) session.getAttribute(
                "userSPID");

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp");

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
                                "http://localhost:8080/nomeApp/spid?callback=true"))
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
