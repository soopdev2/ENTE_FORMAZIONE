/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utility;

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

        try {
            entityManagerFactory = Persistence.createEntityManagerFactory("enm_fad_video");
            entityManager = entityManagerFactory.createEntityManager();

            TypedQuery<User> query = entityManager.createQuery(
                    "SELECT u FROM Utente u WHERE u.id = :id", User.class
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

//    public static void sendEmailJVM(String email, String name, int id, String password) {
//
//        if (email == null) {
//            return;
//        }
//        MailjetClient client;
//        MailjetRequest request1;
//        @SuppressWarnings("unused")
//        MailjetResponse response1;
//
//        String apiKey = config.getString("apikey");
//        String secretKey = config.getString("secretKey");
//
//        ClientOptions co = ClientOptions.builder()
//                .apiKey(apiKey)
//                .apiSecretKey(secretKey)
//                .build();
//
//        client = new MailjetClient(co);
//
//        try {
//            Email email2 = findEmailContent(1L);
//            String link = config.getString("link");
//            final String username = config.getString("username");
//
//            String contentTemplate = email2.getHtmlContent();
//            String content = contentTemplate
//                    .replace("[name]", name)
//                    .replace("[username]", username)
//                    .replace("[password]", password);
//
//            request1 = new MailjetRequest(Emailv31.resource)
//                    .property(Emailv31.MESSAGES, new JSONArray()
//                            .put(new JSONObject()
//                                    .put(Emailv31.Message.FROM, new JSONObject()
//                                            .put("Email", username)
//                                            .put("Name", "SmartNova")
//                                    )
//                                    .put(Emailv31.Message.TO, new JSONArray()
//                                            .put(new JSONObject()
//                                                    .put("Email", email)
//                                                    .put("Name", name))
//                                    )
//                                    .put(Emailv31.Message.SUBJECT, "Creazione nuova utenza")
//                                    .put(Emailv31.Message.HTMLPART, content)
//                            )
//                    );
//
//            response1 = client.post(request1);
//
//        } catch (Exception ex) {
//            ex.printStackTrace();
//            System.out.println(ex);
//        }
//    }
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

}
