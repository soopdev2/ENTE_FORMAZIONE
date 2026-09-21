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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String isLogin = request.getParameter("isLogin");

        try {
            if (isLogin.equals("true")) {
                Login(request, response);
            } else {
                Logout(request, response);
            }

        } catch (ServletException | IOException e) {
            e.printStackTrace();
            //logfile.severe(estraiEccezione(e));
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
                    if (request.getContextPath().contains("ENM_2026_FAD_VIDEO")) {
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
    protected void Logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            String userId = session.getAttribute("userId").toString();
            User User_session = Utils.findUserById(Long.valueOf(userId));
            session.invalidate();

            response.sendRedirect("index.jsp?esito=OK&codice=001");

        } catch (IOException | NumberFormatException e) {

            //logfile.severe(Utility.estraiEccezione(e));
            e.printStackTrace();
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
