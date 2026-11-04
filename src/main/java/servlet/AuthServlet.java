
package servlet;

import Utility.JpaUtil;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import entity.User;

import it.spid.cie.oidc.config.RelyingPartyOptions;
import it.spid.cie.oidc.exception.OIDCException;
import it.spid.cie.oidc.handler.RelyingPartyHandler;
import it.spid.cie.oidc.persistence.JdbcPersistenceAdapter;
import it.spid.cie.oidc.persistence.PersistenceAdapter;
import it.spid.cie.oidc.schemas.OIDCProfile;
import it.spid.cie.oidc.util.ArrayUtil;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONObject;

@WebServlet(name = "AuthServlet", urlPatterns = {"/AuthServlet"})
public class AuthServlet extends HttpServlet {

    private static final Logger LOGGER =
            Logger.getLogger(AuthServlet.class.getName());

    // ============================================================
    // CONFIGURAZIONE CIE
    // DA COMPLETARE QUANDO SARANNO DISPONIBILI I DATI RP
    // ============================================================

    private static final String CIE_PROVIDER_SUBJECT_ID = "";
    private static final String CIE_TRUST_ANCHOR = "";
    private static final String DEFAULT_TRUST_ANCHOR = "";

    private static final String RELYING_PARTY_SUBJECT_ID = "";

    private static final String RELYING_PARTY_JWK_STRING = "";
    private static final String RELYING_PARTY_TRUST_MARKS = "";

    // Callback locale di sviluppo
    // In produzione dovrà essere sostituita con l'URI HTTPS registrata.
    private static final String REDIRECT_URI =
            "http://localhost:8091/ENTE_FORMAZIONE/AuthServlet?callback=true";

    // ============================================================
    // DATABASE PERSISTENZA OIDC
    // Si utilizza lo stesso database di SPID, con prefisso separato.
    // ============================================================

    private static final String JDBC_URL =
            "jdbc:mysql://127.0.0.1:3306/spid";

    private static final String JDBC_USERNAME = "spid";
    private static final String JDBC_PASSWORD = "spid";

    private static final String TABLE_PREFIX = "cie_";

    private static final String PROFILE = "cie";

    private static final String SCOPE =
            "openid offline_access profile email";

    // ============================================================
    // OGGETTI
    // ============================================================

    private RelyingPartyHandler relyingPartyHandler;
    private HikariDataSource dataSource;

    // ============================================================
    // VERIFICA CONFIGURAZIONE
    // ============================================================

    private boolean isConfigured() {

        return !CIE_PROVIDER_SUBJECT_ID.isBlank()
                && !CIE_TRUST_ANCHOR.isBlank()
                && !DEFAULT_TRUST_ANCHOR.isBlank()
                && !RELYING_PARTY_SUBJECT_ID.isBlank()
                && !RELYING_PARTY_JWK_STRING.isBlank()
                && !RELYING_PARTY_TRUST_MARKS.isBlank()
                && !REDIRECT_URI.isBlank();
    }

    // ============================================================
    // INIZIALIZZAZIONE OIDC
    // ============================================================

    private synchronized void initializeOIDC()
            throws OIDCException {

        if (relyingPartyHandler != null) {
            return;
        }

        if (!isConfigured()) {
            throw new OIDCException(
                    "Configurazione CIE non completata.");
        }

        RelyingPartyOptions options =
                initializeRelyingPartyOptions();

        PersistenceAdapter persistence =
                initializePersistenceAdapter();

        relyingPartyHandler = new RelyingPartyHandler(
                options,
                persistence);
    }

    // ============================================================
    // CONFIGURAZIONE RELYING PARTY
    // ============================================================

    private RelyingPartyOptions initializeRelyingPartyOptions() {

        Map<String, String> cieProviders = new HashMap<>();

        cieProviders.put(
                CIE_PROVIDER_SUBJECT_ID,
                CIE_TRUST_ANCHOR);

        Map<String, List<String>> trustMarkIssuers =
                new HashMap<>();

        trustMarkIssuers.put(
                "https://registry.agid.gov.it/openid_relying_party/public/",
                Arrays.asList(
                        "https://registry.spid.agid.gov.it/",
                        "https://public.intermediate.spid.it/"
                )
        );

        return new RelyingPartyOptions()

                .setDefaultTrustAnchor(
                        DEFAULT_TRUST_ANCHOR)

                .setClientId(
                        RELYING_PARTY_SUBJECT_ID)

                .setCIEProviders(
                        cieProviders)

                .setTrustAnchors(
                        ArrayUtil.asSet(
                                CIE_TRUST_ANCHOR))

                .setApplicationName(
                        "ENTE_FORMAZIONE")

                .setRedirectUris(
                        ArrayUtil.asSet(
                                REDIRECT_URI))

                .setJWK(
                        RELYING_PARTY_JWK_STRING)

                .setTrustMarks(
                        RELYING_PARTY_TRUST_MARKS)

                .setTrustMarkIssuers(
                        trustMarkIssuers)

                .setUserKeyClaim(
                        "email")

                .setLogoutRedirectURL(
                        "/index.jsp");
    }

    // ============================================================
    // CONFIGURAZIONE PERSISTENZA
    // ============================================================

    private PersistenceAdapter initializePersistenceAdapter() {

        JdbcPersistenceAdapter adapter =
                new JdbcPersistenceAdapter();

        HikariConfig config = new HikariConfig();

        config.setJdbcUrl(JDBC_URL);
        config.setUsername(JDBC_USERNAME);
        config.setPassword(JDBC_PASSWORD);

        config.setDriverClassName(
                "com.mysql.cj.jdbc.Driver");

        config.setMaximumPoolSize(5);
        config.setMinimumIdle(1);
        config.setPoolName("CIE-OIDC-Pool");

        dataSource = new HikariDataSource(config);

        adapter.setDataSource(dataSource);
        adapter.setTablePrefix(TABLE_PREFIX);
        adapter.setLoggingLevel(Level.INFO);

        return adapter;
    }

    // ============================================================
    // AVVIO AUTENTICAZIONE CIE
    // ============================================================

    private void startAuthentication(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException, OIDCException {

        initializeOIDC();

        String authorizationURL =
                relyingPartyHandler.getAuthorizeURL(
                        CIE_PROVIDER_SUBJECT_ID,
                        CIE_TRUST_ANCHOR,
                        REDIRECT_URI,
                        SCOPE,
                        PROFILE
                );

        LOGGER.info(
                "Avvio autenticazione CIE");

        response.sendRedirect(authorizationURL);
    }

    // ============================================================
    // CALLBACK CIE
    // ============================================================

    private void handleCallback(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String error = request.getParameter("error");

        if (error != null && !error.isBlank()) {

            LOGGER.warning(
                    "Autenticazione CIE rifiutata: " + error);

            response.sendRedirect(
                    request.getContextPath()
                    + "/index.jsp?esito=cieErrore");

            return;
        }

        String code = request.getParameter("code");
        String state = request.getParameter("state");

        if (code == null || code.isBlank()
                || state == null || state.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Risposta CIE incompleta.");

            return;
        }

        try {

            initializeOIDC();

            // ====================================================
            // RECUPERO E VERIFICA DATI CIE
            // La libreria verifica token e firme.
            // ====================================================

            JSONObject userInfo =
                    relyingPartyHandler.getUserInfo(
                            state,
                            code);

            // ====================================================
            // RECUPERO CODICE FISCALE
            // ====================================================

            String codiceFiscale =
                    userInfo.optString(
                            "fiscal_number",
                            "");

            codiceFiscale = normalizeFiscalNumber(
                    codiceFiscale);

            if (!isValidFiscalNumber(codiceFiscale)) {

                LOGGER.warning(
                        "Codice fiscale CIE mancante o non valido.");

                response.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Codice fiscale non restituito da CIE.");

                return;
            }

            // ====================================================
            // RECUPERO IDENTIFICATIVO PER LOGOUT OIDC
            // ====================================================

            String userKey =
                    userInfo.optString("email", "");

            if (userKey.isBlank()) {

                LOGGER.warning(
                        "CIE non ha restituito l'indirizzo email.");

                response.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Identificativo utente non disponibile.");

                return;
            }

            // ====================================================
            // RICERCA UTENTE NEL DATABASE
            // ====================================================

            User user = findUserByFiscalNumber(
                    codiceFiscale);

            if (user == null) {

                LOGGER.info(
                        "Accesso CIE negato: utente non registrato.");

                response.sendError(
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "Utente non registrato. "
                        + "Registrarsi prima sul sito.");

                return;
            }

            // ====================================================
            // LOGIN RIUSCITO
            // ====================================================

            HttpSession session =
                    request.getSession(true);

            request.changeSessionId();

            session.setAttribute(
                    "userCIE",
                    user);

            session.setAttribute(
                    "userCIEKey",
                    userKey);

            LOGGER.info(
                    "Autenticazione CIE completata.");

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard.jsp");

        } catch (OIDCException ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Errore durante il callback CIE.",
                    ex);

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Autenticazione CIE non riuscita.");

        } catch (IOException ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Errore durante il login CIE.",
                    ex);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore interno durante l'accesso CIE.");
        }
    }

    // ============================================================
    // RICERCA UTENTE
    // ============================================================

    private User findUserByFiscalNumber(
            String codiceFiscale) {

        EntityManager em = null;

        try {

            em = JpaUtil.getEntityManager();

            TypedQuery<User> query =
                    em.createQuery(
                            "SELECT u FROM User u "
                            + "WHERE u.cf = :cf",
                            User.class);

            query.setParameter(
                    "cf",
                    codiceFiscale);

            List<User> results =
                    query.setMaxResults(1)
                            .getResultList();

            if (results.isEmpty()) {
                return null;
            }

            return results.get(0);

        } finally {

            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    // ============================================================
    // NORMALIZZAZIONE CODICE FISCALE
    // ============================================================

    private String normalizeFiscalNumber(String value) {

        if (value == null) {
            return "";
        }

        String result = value.trim().toUpperCase();

        if (result.startsWith("TINIT-")) {
            result = result.substring(6);
        }

        return result;
    }

    // ============================================================
    // CONTROLLO FORMATO CODICE FISCALE
    // ============================================================

    private boolean isValidFiscalNumber(String cf) {

        return cf != null
                && cf.matches("[A-Z0-9]{16}");
    }

    // ============================================================
    // LOGOUT CIE
    // ============================================================

    private void handleLogout(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/index.jsp");

            return;
        }

        String userKey =
                (String) session.getAttribute(
                        "userCIEKey");

        if (userKey == null || userKey.isBlank()) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/index.jsp");

            return;
        }

        try {

            initializeOIDC();

            String redirectURL =
                    relyingPartyHandler.performLogout(
                            userKey,
                            null);

            session.invalidate();

            if (redirectURL == null
                    || redirectURL.isBlank()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/index.jsp");

            } else {

                response.sendRedirect(
                        redirectURL);
            }

        } catch (Exception ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Errore durante il logout CIE.",
                    ex);

            if (session != null) {
                session.invalidate();
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/index.jsp");
        }
    }

    // ============================================================
    // GET
    // ============================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate");

        response.setHeader(
                "Pragma",
                "no-cache");

        if ("true".equals(
                request.getParameter("callback"))) {

            handleCallback(
                    request,
                    response);

            return;
        }

        if ("logout".equals(
                request.getParameter("action"))) {

            handleLogout(
                    request,
                    response);

            return;
        }

        if (!isConfigured()) {

            response.sendError(
                    HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                    "Autenticazione CIE non ancora configurata.");

            return;
        }

        try {

            startAuthentication(
                    request,
                    response);

        } catch (OIDCException ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Impossibile avviare autenticazione CIE.",
                    ex);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Impossibile avviare l'autenticazione CIE.");
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

        response.sendError(
                HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                "Metodo non consentito.");
    }

    // ============================================================
    // CHIUSURA RISORSE
    // ============================================================

    @Override
    public void destroy() {

        if (dataSource != null
                && !dataSource.isClosed()) {

            dataSource.close();
        }

        super.destroy();
    }
}
