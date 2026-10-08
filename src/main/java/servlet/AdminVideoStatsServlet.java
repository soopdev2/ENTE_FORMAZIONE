/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
/**
 *
 * @author Aldo
 */
package servlet;

import entity.UserVideo;
import entity.Video;
import service.AdminVideoStatsService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(
        name = "AdminVideoStatsServlet",
        urlPatterns = {"/AdminVideoStatsServlet"}
)
public class AdminVideoStatsServlet extends HttpServlet {

    private final AdminVideoStatsService statsService
            = new AdminVideoStatsService();

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action
                = request.getParameter("action");

        if (action == null
                || action.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Action mancante"
            );

            return;
        }

        try {

            switch (action) {

                case "stats":
                    getStats(
                            request,
                            response
                    );
                    break;

                case "users":
                    getUsers(
                            request,
                            response
                    );
                    break;

                default:

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Action non valida"
                    );
            }

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );

        } catch (ServletException | IOException e) {

            getServletContext().log(
                    "Errore AdminVideoStatsServlet",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore interno del server"
            );
        }
    }

    private void getStats(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long videoId
                = parseLong(
                        request.getParameter("videoId"),
                        "ID video obbligatorio"
                );

        Video video
                = statsService.getVideo(videoId);

        long totale
                = statsService.getTotaleUtenti(
                        videoId
                );

        long completati
                = statsService.getUtentiCompletati(
                        videoId
                );

        long inCorso
                = statsService.getUtentiInCorso(
                        videoId
                );

        long daGuardare
                = statsService.getUtentiDaGuardare(
                        videoId
                );

        request.setAttribute(
                "video",
                video
        );

        request.setAttribute(
                "totaleUtenti",
                totale
        );

        request.setAttribute(
                "utentiCompletati",
                completati
        );

        request.setAttribute(
                "utentiInCorso",
                inCorso
        );

        request.setAttribute(
                "utentiDaGuardare",
                daGuardare
        );

        // --> JSP
        request.getRequestDispatcher(
                "/pages/admin/video/statistiche.jsp"
        ).forward(
                request,
                response
        );
    }

    private void getUsers(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long videoId
                = parseLong(
                        request.getParameter("videoId"),
                        "ID video obbligatorio"
                );

        Video video
                = statsService.getVideo(videoId);

        List<UserVideo> utenti
                = statsService.getUtentiVideo(
                        videoId
                );

        request.setAttribute(
                "video",
                video
        );

        request.setAttribute(
                "utenti",
                utenti
        );

        // --> JSP
        request.getRequestDispatcher(
                "/pages/admin/video/utenti.jsp"
        ).forward(
                request,
                response
        );
    }

    private Long parseLong(
            String value,
            String message) {

        if (value == null
                || value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    message
            );
        }

        try {

            return Long.valueOf(
                    value.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Valore numerico non valido"
            );
        }
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

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

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
