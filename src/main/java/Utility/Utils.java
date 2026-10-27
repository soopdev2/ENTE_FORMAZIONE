/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utility;

import com.mailjet.client.ClientOptions;
import com.mailjet.client.MailjetClient;
import com.mailjet.client.MailjetRequest;
import com.mailjet.client.MailjetResponse;
import com.mailjet.client.errors.MailjetException;
import com.mailjet.client.resource.Emailv31;
import entity.Email;
import entity.Pagina;
import entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang.StringEscapeUtils;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import static org.apache.commons.lang.exception.ExceptionUtils.getStackTrace;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Salvatore
 */
public class Utils {

    public static String sanitize(String input) {
        if (input == null) {
            return null;
        }
        input = input.replaceAll("[^a-zA-Z0-9\\.\\-]", "_");
        input = input.replaceAll("[\r\n]", "");
        return StringEscapeUtils.escapeHtml(input);
    }

    public static String sanitizeFilename(String filename) {
        return filename.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    public static String sanitizePath(String input) {
        input = input.replaceAll("\\.\\./", "")
                .replaceAll("~", "")
                .replaceAll("\\\\", "/");

        input = input.replaceAll("[^a-zA-Z0-9_./-]", "");
        Path sanitizedPath = Paths.get(input).normalize();

        return sanitizedPath.toString();
    }

    public static String checkAttribute(HttpSession session, String attribute) {
        try {
            if (session.getAttribute(attribute) != null) {
                return String.valueOf(session.getAttribute(attribute));
            }
        } catch (Exception e) {
        }
        return "";
    }

    public static final ResourceBundle config = ResourceBundle.getBundle("conf.config");

    public static final String PATHLOG = config.getString("logPath");
    private static final String APPNAME = "NewProject";
    private static final String PAT_4 = "yyyyMMdd";
    private static final String PAT_9 = "yyMMddHHmmssSSS";

//    private static Logger createLog() {
//        Logger logger = (Logger) getLogger(APPNAME);
//        try {
//            String dataOdierna = new org.joda.time.DateTime().toString(PAT_4);
//
//            File logdir = new File(PATHLOG);
//            if (!logdir.exists()) {
//                logdir.mkdir();
//            }
//            String ora = new org.joda.time.DateTime().toString(PAT_9);
//            String pathLog = PATHLOG + dataOdierna;
//            File dirLog = new File(pathLog);
//            if (!dirLog.exists()) {
//                dirLog.mkdirs();
//            }
//            FileHandler fh = new FileHandler(pathLog + separator + APPNAME + "_" + ora + ".log", true);
//            logger.addHandler(fh);
//            fh.setFormatter(new SimpleFormatter());
//            fh.setLevel(Level.ALL);
//        } catch (IOException | SecurityException ex) {
//            logger.severe(ex.getMessage());
//        }
//        return logger;
//    }
//    public static final Logger logfile = createLog();
    public static String estraiEccezione(Exception ec1) {
        try {
            return ec1.getStackTrace()[0].getMethodName() + " - " + getStackTrace(ec1);
        } catch (Exception e) {
//            logfile.severe(estraiEccezione(e));
            Logger.getLogger(Utils.class.getName()).log(Level.SEVERE, "ERRORE GENERICO", e);
        }
        return ec1.getMessage();
    }

    public static User findUserById(String id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            User user = em.find(User.class, Long.valueOf(id));
            if (user != null) {
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

    public static double parseDoube_v1(String valore) {
        if (valore == null || valore.trim().isEmpty()) {
            return 0.0;
        }

        try {
            // Sostituisce la virgola con il punto per garantire il formato corretto
            valore = valore.replace(",", ".");
            return Double.parseDouble(valore);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Formato numero non valido: " + valore, e);
        }
    }

    public static String formatDoubleSmart(double value) {
        if (value == (long) value) {
            return String.format("%d", (long) value); // es: 1.0 -> "1"
        } else {
            return new BigDecimal(value)
                    .stripTrailingZeros()
                    .toPlainString(); // es: 1.50 -> "1.5", 1.52 -> "1.52"
        }
    }

    public static int parseInt_v1(String ing) {

        try {
            return Integer.parseInt(ing);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }

    }

    public static Long parseLong_v1(String valore) {
        if (valore == null || valore.trim().isEmpty()) {
            return null;
        }

        try {
            // Rimuove tutti i caratteri non numerici validi tranne eventuale '-' iniziale
            String clean = valore.trim().replaceAll("[^\\d-]", "");
            return clean.isEmpty() ? null : Long.parseLong(clean);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static int tryParse(String param) {
        try {
            return Integer.parseInt(param);
        } catch (Exception e) {
            //logfile.severe(estraiEccezione(e));
            Logger.getLogger(Utils.class.getName()).log(Level.SEVERE, "ERRORE GENERICO", e);
        }
        return 0;
    }

    public static Boolean isVisible(String ruolo, String page) {

        if (ruolo == null
                || ruolo.isEmpty()
                || page == null
                || page.isEmpty()) {

            return false;
        }

        if (page.startsWith("/")) {

            page = page.substring(1);
        }

        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {

            emf = Persistence.createEntityManagerFactory(
                    "enm_fad_video"
            );

            em = emf.createEntityManager();

            String jpql
                    = "SELECT p "
                    + "FROM Pagina p "
                    + "WHERE p.nome = :page";

            TypedQuery<Pagina> query
                    = em.createQuery(
                            jpql,
                            Pagina.class
                    );

            query.setParameter(
                    "page",
                    page
            );

            List<Pagina> risultati
                    = query.getResultList();

            if (risultati.isEmpty()) {

                return false;
            }

            Pagina pagina
                    = risultati.get(0);

            String permessi
                    = pagina.getPermessi();

            if (permessi == null
                    || permessi.isEmpty()) {

                return false;
            }

            String[] listaPermessi
                    = permessi.split("-");

            for (String permesso : listaPermessi) {

                if (permesso.trim().equals(
                        ruolo.trim()
                )) {

                    return true;
                }
            }

        } catch (Exception e) {

            Logger.getLogger(
                    Utils.class.getName()
            ).log(
                    Level.SEVERE,
                    "ERRORE GENERICO",
                    e
            );

            return false;

        } finally {

            if (em != null) {

                em.close();
            }

            if (emf != null) {

                emf.close();
            }
        }

        return false;
    }

    public static User findUserById(Long id) {
        EntityManagerFactory entityManagerFactory = null;
        EntityManager entityManager = null;
        System.out.println("id " + id);

        try {
            entityManagerFactory = Persistence.createEntityManagerFactory("enm_fad_video");
            entityManager = entityManagerFactory.createEntityManager();

            TypedQuery<User> query = entityManager.createQuery(
                    "SELECT u FROM User u WHERE u.id = :id", User.class
            )
                    .setParameter("id", id);

            User utente = query.getSingleResult();

            if (utente != null) {
                return utente;
            }

        } catch (Exception e) {
            //logfile.severe(estraiEccezione(e));
            e.printStackTrace();
            return null;
        } finally {
            if (entityManager != null) {
                entityManager.close();
            }
            if (entityManagerFactory != null) {
                entityManagerFactory.close();
            }
        }

        return null;
    }

    public static String getRequest(HttpServletRequest req, String name) {
        try {
            return req.getParameter(name).trim();
        } catch (Exception e) {
        }
        return "";
    }

    public static String createNewRandomPassword(int length) {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+";
        StringBuilder password = new StringBuilder();

        SecureRandom random = new SecureRandom();

        for (int i = 0; i < length; i++) {
            int randomIndex = random.nextInt(characters.length());
            password.append(characters.charAt(randomIndex));
        }

        return password.toString();
    }

    public static void sendEmailJVM(String email, String name, int id, String password) {

        if (email == null) {
            return;
        }
        MailjetClient client;
        MailjetRequest request1;
        @SuppressWarnings("unused")
        MailjetResponse response1;

        String apiKey = config.getString("apikey");
        String secretKey = config.getString("secretKey");

        ClientOptions co = ClientOptions.builder()
                .apiKey(apiKey)
                .apiSecretKey(secretKey)
                .build();

        client = new MailjetClient(co);

        try {
            Email email2 = findEmailContent(1L);
            String link = config.getString("link");
            final String username = config.getString("username");

            String contentTemplate = email2.getHtmlContent();
            String content = contentTemplate
                    .replace("[name]", name)
                    .replace("[username]", username)
                    .replace("[password]", password);

            request1 = new MailjetRequest(Emailv31.resource)
                    .property(Emailv31.MESSAGES, new JSONArray()
                            .put(new JSONObject()
                                    .put(Emailv31.Message.FROM, new JSONObject()
                                            .put("Email", username)
                                            .put("Name", "SmartNova")
                                    )
                                    .put(Emailv31.Message.TO, new JSONArray()
                                            .put(new JSONObject()
                                                    .put("Email", email)
                                                    .put("Name", name))
                                    )
                                    .put(Emailv31.Message.SUBJECT, "Creazione nuova utenza")
                                    .put(Emailv31.Message.HTMLPART, content)
                            )
                    );

            response1 = client.post(request1);

        } catch (MailjetException | JSONException ex) {
            ex.printStackTrace();
            System.out.println(ex);
        }
    }

    public static void sendEmailRecuperoPassword(String email, String token) {

        if (email == null || email.isBlank()
                || token == null || token.isBlank()) {
            return;
        }

        try {
            String apiKey = config.getString("apikey");
            String secretKey = config.getString("secretKey");
            String username = config.getString("username");

            ClientOptions co = ClientOptions.builder()
                    .apiKey(apiKey)
                    .apiSecretKey(secretKey)
                    .build();

            MailjetClient client = new MailjetClient(co);

            String baseLink = config.getString("link");

            // URL della pagina che permetterà di impostare la nuova password.
            String linkRecupero = baseLink
                    + "reimpostaPassword.jsp?token="
                    + java.net.URLEncoder.encode(
                            token,
                            java.nio.charset.StandardCharsets.UTF_8
                    );

            String content = "<!DOCTYPE html>"
                    + "<html><body>"
                    + "<h2>Recupero password</h2>"
                    + "<p>Hai richiesto di reimpostare la password del tuo account.</p>"
                    + "<p>Per scegliere una nuova password, clicca sul pulsante seguente:</p>"
                    + "<p>"
                    + "<a href=\"" + linkRecupero + "\" "
                    + "style=\"display:inline-block;padding:12px 20px;"
                    + "background-color:#2563eb;color:#ffffff;"
                    + "text-decoration:none;border-radius:6px;\">"
                    + "Reimposta password</a>"
                    + "</p>"
                    + "<p>Se il pulsante non funziona, copia questo indirizzo nel browser:</p>"
                    + "<p><a href=\"" + linkRecupero + "\">"
                    + linkRecupero + "</a></p>"
                    + "<p>Il collegamento scade dopo 30 minuti.</p>"
                    + "<p>Se non hai richiesto il recupero, ignora questa email.</p>"
                    + "</body></html>";

            System.out.println("LINK RECUPERO: " + linkRecupero);
            System.out.println("HTML EMAIL: " + content);

            MailjetRequest request1 = new MailjetRequest(Emailv31.resource)
                    .property(Emailv31.MESSAGES, new JSONArray()
                            .put(new JSONObject()
                                    .put(Emailv31.Message.FROM, new JSONObject()
                                            .put("Email", username)
                                            .put("Name", "ENTE FORMAZIONE")
                                    )
                                    .put(Emailv31.Message.TO, new JSONArray()
                                            .put(new JSONObject()
                                                    .put("Email", email)
                                                    .put("Name", "Utente")
                                            )
                                    )
                                    .put(Emailv31.Message.SUBJECT,
                                            "Recupero password")
                                    .put(Emailv31.Message.HTMLPART, content)
                            )
                    );

            MailjetResponse response1 = client.post(request1);

            if (response1.getStatus() < 200 || response1.getStatus() >= 300) {
                System.err.println(
                        "Invio email recupero password fallito. HTTP status: "
                        + response1.getStatus()
                );
            }

        } catch (MailjetException | JSONException ex) {
            System.err.println("Errore durante l'invio dell'email di recupero password.");
            ex.printStackTrace();
        }
    }

    public static double roundToTwoDecimals(double value) {
        BigDecimal bd = new BigDecimal(value);
        bd = bd.setScale(2, RoundingMode.HALF_UP);
        return bd.doubleValue();
    }

    public static double parseDouble(String input) {
        if (input == null || input.isEmpty()) {
            throw new IllegalArgumentException("Input non può essere null o vuoto");
        }

        input = input.trim();
        input = input.replaceAll("[^0-9,\\.]", "");

        if (input.contains(",") && !input.contains(".")) {
            input = input.replace(',', '.');
        }

        return Double.parseDouble(input);
    }

    public static Long parseLongSafe(String val) {
        try {
            if (val == null || val.isBlank()) {
                return null;
            }
            return Long.valueOf(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static Integer parseIntSafe(String val) {
        try {
            if (val == null || val.isBlank()) {
                return 0;
            }
            return Integer.valueOf(val.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    public static Double parseDoubleSafe(String val) {
        try {
            if (val == null || val.isBlank()) {
                return 0.0;
            }
            val = val.replace(",", "."); // accetta anche "1,5"
            return Double.valueOf(val.trim());
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }

    public static Email findEmailContent(Long emailId) {
        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = Persistence.createEntityManagerFactory("enm_fad_video");
            em = emf.createEntityManager();

            return em.find(Email.class,
                    emailId);
        } finally {
            if (em != null) {
                em.close();
            }
            if (emf != null) {
                emf.close();
            }
        }
    }

    public static boolean sendEmailRegistrazione(
            String email,
            String nome,
            String usernameGenerato,
            String passwordTemporanea) {

        if (email == null || usernameGenerato == null
                || passwordTemporanea == null) {
            return false;
        }

        try {
            String apiKey = config.getString("apikey");
            String secretKey = config.getString("secretKey");
            String mittente = config.getString("username");

            ClientOptions options = ClientOptions.builder()
                    .apiKey(apiKey)
                    .apiSecretKey(secretKey)
                    .build();

            MailjetClient client = new MailjetClient(options);

            String nomeSicuro = nome == null
                    ? "Utente"
                    : nome.replace("&", "&amp;")
                            .replace("<", "&lt;")
                            .replace(">", "&gt;");

            String usernameSicuro = usernameGenerato
                    .replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;");

            String passwordSicura = passwordTemporanea
                    .replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;");

            String contenuto = "<html><body>"
                    + "<h2>Benvenuto su ENTE FORMAZIONE, " + nomeSicuro + "!</h2>"
                    + "<p>Il tuo account è stato creato.</p>"
                    + "<p><strong>Nome utente:</strong> " + usernameSicuro + "</p>"
                    + "<p><strong>Password temporanea:</strong> "
                    + passwordSicura + "</p>"
                    + "<p>Al primo accesso dovrai impostare una nuova password. "
                    + "Potrai anche modificare il nome utente.</p>"
                    + "<p>Per sicurezza, non condividere queste credenziali.</p>"
                    + "</body></html>";

            MailjetRequest richiesta = new MailjetRequest(Emailv31.resource)
                    .property(Emailv31.MESSAGES, new JSONArray()
                            .put(new JSONObject()
                                    .put(Emailv31.Message.FROM, new JSONObject()
                                            .put("Email", mittente)
                                            .put("Name", "ENTE FORMAZIONE"))
                                    .put(Emailv31.Message.TO, new JSONArray()
                                            .put(new JSONObject()
                                                    .put("Email", email)
                                                    .put("Name", nomeSicuro)))
                                    .put(Emailv31.Message.SUBJECT,
                                            "Le tue credenziali ENTE FORMAZIONE")
                                    .put(Emailv31.Message.HTMLPART, contenuto)));

            MailjetResponse risposta = client.post(richiesta);

            return risposta.getStatus() >= 200
                    && risposta.getStatus() < 300;

        } catch (MailjetException | JSONException e) {
            System.err.println(
                    "Errore durante l'invio dell'email di registrazione."
            );
            e.printStackTrace();
            return false;
        }
    }

}
