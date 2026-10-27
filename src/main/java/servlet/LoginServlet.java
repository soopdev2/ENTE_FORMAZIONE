/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import Utility.Utils;
import entity.AuthenticationService;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Date;
import java.util.HexFormat;

/**
 *
 * @author Aldo
 */
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String azione = request.getParameter("azione");

        try {
            if ("registrazione".equals(azione)) {
                Registrazione(request, response);
                return;
            }

            if ("cambiaCredenziali".equals(azione)) {
                CambiaCredenziali(request, response);
                return;
            }

            if ("recuperoPassword".equals(azione)) {
                RecuperoPassword(request, response);
                return;
            }

            if ("reimpostaPassword".equals(azione)) {
                ReimpostaPassword(request, response);
                return;
            }

            String isLogin = request.getParameter("isLogin");

            if ("true".equals(isLogin)) {
                Login(request, response);
            } else {
                Logout(request, response);
            }

        } catch (ServletException | IOException e) {
            throw e;
        }
    }

    // LOGIN
    protected void Login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            if (AuthenticationService.isPasswordValid(username, password)) {
                int roleId = AuthenticationService.authenticate(username, password);
                if (roleId != -1) {
                    User user = AuthenticationService.getUserByUsername(username);
                    if (request.getContextPath().contains("ENTE_FORMAZIONE")) {
                        request.getSession().setAttribute("src", "../..");
                    }

                    if (user != null) {

                        try {
                            HttpSession session = request.getSession();
                            session.setAttribute("userId", user.getId());
                            String userIdParam = session.getAttribute("userId").toString();
                            int userId = Utils.tryParse(userIdParam);
                            session.setAttribute("username", Utils.sanitize(user.getUsername()));
                            session.setAttribute("nome", Utils.sanitize(user.getNome()));
                            session.setAttribute("user", user);

                            session.setAttribute(
                                    "cambioPasswordObbligatorio",
                                    user.isCambioPasswordObbligatorio()
                            );

                            if (user.isCambioPasswordObbligatorio()) {
                                response.sendRedirect(
                                        request.getContextPath()
                                        + "/cambioCredenziali.jsp"
                                );
                                return;
                            }

                            redirectToPageByRole(response, request, userId, roleId);

                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                    } else {
                        response.getWriter().write("Utente non trovato " + user);
                    }
                } else {
                    response.getWriter().write("Ruolo non trovato " + roleId);
                }

            }
            //logfile.severe(estraiEccezione(e));
        } catch (IOException e) {
            e.printStackTrace();

        }
    }

    // RENDER PAGINE
    private void redirectToPageByRole(HttpServletResponse response, HttpServletRequest request, int userId, int roleId)
            throws IOException {
        String targetPage;

        String isLogin = request.getParameter("isLogin");

        try {

            if (isLogin.equals("true")) {
                switch (roleId) {

                    case 1:
                        targetPage = request.getContextPath() + "/page/admin/dashboard.jsp";
                        break;

                    case 2:
                        targetPage = request.getContextPath() + "/page/user/dashboard.jsp";
                        break;

                    default:
                        targetPage = "";
                        break;
                }

                if (!targetPage.isEmpty()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", userId);
                    response.sendRedirect(response.encodeRedirectURL(targetPage));
                } else {
                    response.sendRedirect("index.jsp?esito=KO6&codice=002");
                }
            } else {
                response.sendRedirect("index.jsp?esito=KO");
            }
        } catch (IOException e) {
            e.printStackTrace();

            //logfile.severe(estraiEccezione(e));
        }
    }

    private void redirectToPageCPass(HttpServletResponse response, HttpServletRequest request, int userId)
            throws IOException {
        String targetPage = "indexRecupero/recuperoPassword.jsp";

        try {

            if (!targetPage.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                response.sendRedirect(response.encodeRedirectURL(targetPage));
            } else {
                response.sendRedirect("index.jsp?esito=KO6&codice=002");
            }
        } catch (IOException e) {
            e.printStackTrace();
            //logfile.severe(estraiEccezione(e));
        }
    }

    // LOGOUT
    protected void Logout(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/index.jsp?esito=OK&codice=001"
            );
            return;
        }

        session.invalidate();

        response.sendRedirect(
                request.getContextPath() + "/index.jsp?esito=OK&codice=001"
        );
    }

    // RECUPERO PASSWORD
    protected void RecuperoPassword(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        String paginaRecupero = request.getContextPath()
                + "/indexRecupero/recuperoPassword.jsp";

        if (email == null || email.isBlank()
                || email.length() > 254
                || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {

            response.sendRedirect(paginaRecupero + "?esito=errore");
            return;
        }

        email = email.trim();

        try {
            User user = AuthenticationService.getUserByEmail(email);

            if (user != null) {

                byte[] randomBytes = new byte[32];
                new SecureRandom().nextBytes(randomBytes);

                String token = HexFormat.of().formatHex(randomBytes);

                String tokenHash = HexFormat.of().formatHex(
                        MessageDigest.getInstance("SHA-256")
                                .digest(token.getBytes(StandardCharsets.UTF_8))
                );

                Date scadenza = new Date(
                        System.currentTimeMillis() + 30L * 60L * 1000L
                );

                boolean salvato = AuthenticationService.salvaTokenRecupero(
                        user.getId(),
                        tokenHash,
                        scadenza
                );

                if (salvato) {
                    Utils.sendEmailRecuperoPassword(email, token);
                }
            }

        } catch (NoSuchAlgorithmException e) {
            getServletContext().log(
                    "Errore durante la richiesta di recupero password.", e
            );
        }

        response.sendRedirect(paginaRecupero + "?esito=ok");
    }

    // REIMPOSTAZIONE PASSWORD
    protected void ReimpostaPassword(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");

        String paginaReimposta = request.getContextPath()
                + "/indexRecupero/reimpostaPassword.jsp";

        // Il token generato dal recupero è composto da 64 caratteri esadecimali.
        if (token == null || !token.matches("^[a-fA-F0-9]{64}$")) {
            response.sendRedirect(paginaReimposta + "?esito=tokenNonValido");
            return;
        }

        // Validazione lato server: non ci affidiamo soltanto al JavaScript.
        if (password == null
                || confermaPassword == null
                || password.length() < 8
                || password.length() > 128
                || !password.equals(confermaPassword)) {

            response.sendRedirect(
                    paginaReimposta + "?esito=passwordNonValida&token=" + token
            );
            return;
        }

        try {
            // Il database conserva l'hash SHA-256 del token, non il token originale.
            String tokenHash = HexFormat.of().formatHex(
                    MessageDigest.getInstance("SHA-256")
                            .digest(token.getBytes(StandardCharsets.UTF_8))
            );

            // Il servizio verifica token e scadenza, aggiorna la password con BCrypt
            // e invalida il token se l'operazione riesce.
            boolean aggiornata = AuthenticationService.reimpostaPassword(
                    tokenHash,
                    password
            );

            if (aggiornata) {
                response.sendRedirect(paginaReimposta + "?esito=successo");
            } else {
                response.sendRedirect(paginaReimposta + "?esito=tokenNonValido");
            }

        } catch (NoSuchAlgorithmException e) {
            getServletContext().log(
                    "Errore durante il calcolo dell'hash del token di recupero.", e
            );

            response.sendRedirect(paginaReimposta + "?esito=errore");
        }
    }

    protected void Registrazione(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");

        String pagina = request.getContextPath()
                + "/indexRecupero/registrazione.jsp";

        if (nome == null || cognome == null || email == null
                || nome.isBlank() || cognome.isBlank()
                || email.isBlank()
                || nome.length() > 80 || cognome.length() > 80
                || email.length() > 254
                || (telefono != null && telefono.length() > 30)
                || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {

            response.sendRedirect(pagina + "?esito=errore");
            return;
        }

        nome = nome.trim();
        cognome = cognome.trim();
        email = email.trim().toLowerCase(java.util.Locale.ROOT);
        telefono = telefono == null ? "" : telefono.trim();

        try {
            String base = (nome + cognome)
                    .toLowerCase(java.util.Locale.ROOT)
                    .replaceAll("[^a-z0-9]", "");

            if (base.isBlank()) {
                base = "utente";
            }

            if (base.length() > 20) {
                base = base.substring(0, 20);
            }

            SecureRandom random = new SecureRandom();
            String username = null;

            for (int i = 0; i < 20; i++) {
                String candidato = base + random.nextInt(100000);

                if (AuthenticationService.usernameDisponibile(candidato)) {
                    username = candidato;
                    break;
                }
            }

            if (username == null) {
                response.sendRedirect(pagina + "?esito=errore");
                return;
            }

            // Password temporanea casuale di 16 caratteri alfanumerici.
            String caratteri
                    = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    + "abcdefghijklmnopqrstuvwxyz"
                    + "0123456789";

            StringBuilder passwordBuilder = new StringBuilder();

            for (int i = 0; i < 16; i++) {
                passwordBuilder.append(
                        caratteri.charAt(random.nextInt(caratteri.length()))
                );
            }

            String passwordTemporanea = passwordBuilder.toString();

            User user = new User();
            user.setNome(nome);
            user.setCognome(cognome);
            user.setEmail(email);
            user.setTelefono(telefono);
            user.setUsername(username);

            user.setPassword(passwordTemporanea);

            boolean creato = AuthenticationService.registraUtentePubblico(user);

            if (!creato) {
                response.sendRedirect(pagina + "?esito=duplicato");
                return;
            }

            User creatoDalDatabase
                    = AuthenticationService.getUserByEmail(email);

            boolean emailInviata = Utils.sendEmailRegistrazione(
                    email,
                    nome,
                    username,
                    passwordTemporanea
            );

            if (!emailInviata) {
                if (creatoDalDatabase != null) {
                    boolean eliminato
                            = AuthenticationService.eliminaRegistrazioneIncompleta(
                                    creatoDalDatabase.getId()
                            );

                    if (!eliminato) {
                        getServletContext().log(
                                "Attenzione: impossibile eliminare "
                                + "una registrazione per cui l'email non "
                                + "è stata confermata come inviata."
                        );
                    }
                }

                response.sendRedirect(pagina + "?esito=erroreEmail");
                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/index.jsp?esito=registrazioneOK"
            );

        } catch (Exception e) {
            getServletContext().log(
                    "Errore durante la registrazione pubblica.", e
            );

            response.sendRedirect(pagina + "?esito=errore");
        }
    }

    // CAMBIO OBBLIGATORIO DELLE CREDENZIALI
    protected void CambiaCredenziali(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        String pagina = request.getContextPath()
                + "/indexRecupero/cambioCredenziali.jsp";

        if (session == null || session.getAttribute("userId") == null
                || !Boolean.TRUE.equals(
                        session.getAttribute("cambioPasswordObbligatorio"))) {

            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String nuovoUsername = request.getParameter("nuovoUsername");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");

        if (nuovoUsername == null) {
            nuovoUsername = "";
        }

        nuovoUsername = nuovoUsername.trim();

        User userSessione = (User) session.getAttribute("user");

        // Se il campo username è vuoto, mantiene quello generato.
        if (nuovoUsername.isEmpty() && userSessione != null) {
            nuovoUsername = userSessione.getUsername();
        }

        if (userSessione == null
                || nuovoUsername.length() < 3
                || nuovoUsername.length() > 50
                || !nuovoUsername.matches("^[a-zA-Z0-9._-]+$")
                || password == null
                || confermaPassword == null
                || password.length() < 8
                || password.length() > 72
                || !password.equals(confermaPassword)) {

            response.sendRedirect(
                    pagina + "?esito=passwordNonValida"
            );
            return;
        }

        try {
            Long userId = Long.valueOf(
                    session.getAttribute("userId").toString()
            );

            boolean aggiornate
                    = AuthenticationService.aggiornaCredenzialiPrimoAccesso(
                            userId,
                            nuovoUsername,
                            password
                    );

            if (!aggiornate) {
                response.sendRedirect(pagina + "?esito=usernameNonDisponibile");
                return;
            }

            // Aggiorna i dati della sessione dopo il salvataggio.
            User aggiornato
                    = AuthenticationService.getUserByUsername(nuovoUsername);

            if (aggiornato == null) {
                session.invalidate();
                response.sendRedirect(
                        request.getContextPath() + "/index.jsp"
                );
                return;
            }

            session.setAttribute("user", aggiornato);
            session.setAttribute("username", aggiornato.getUsername());
            session.setAttribute("nome", aggiornato.getNome());
            session.setAttribute("cambioPasswordObbligatorio", false);

            String ruoloId = String.valueOf(
                    aggiornato.getRuolo().getId()
            );

            String destinazione;

            if ("1".equals(ruoloId)) {
                destinazione = request.getContextPath()
                        + "/page/admin/dashboard.jsp";
            } else if ("2".equals(ruoloId)) {
                destinazione = request.getContextPath()
                        + "/page/user/dashboard.jsp";
            } else {
                session.invalidate();
                response.sendRedirect(
                        request.getContextPath() + "/index.jsp"
                );
                return;
            }

            response.sendRedirect(response.encodeRedirectURL(destinazione));

        } catch (Exception e) {
            getServletContext().log(
                    "Errore durante il cambio delle credenziali.", e
            );
            response.sendRedirect(pagina + "?esito=errore");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
