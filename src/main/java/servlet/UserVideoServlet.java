/**
 *
 * @author Aldo
 */
package servlet;

import entity.UserVideo;
import service.UserVideoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class UserVideoServlet extends HttpServlet {

    private final UserVideoService userVideoService
            = new UserVideoService();

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

                case "get":
                    getUserVideo(
                            request,
                            response
                    );
                    break;

                case "list":
                    getUserVideos(
                            request,
                            response
                    );
                    break;

                case "start":
                    startVideo(
                            request,
                            response
                    );
                    break;

                case "heartbeat":
                    heartbeat(
                            request,
                            response
                    );
                    break;

                case "pause":
                    pauseVideo(
                            request,
                            response
                    );
                    break;

                case "complete":
                    completeVideo(
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

        } catch (IllegalStateException e) {

            response.sendError(
                    HttpServletResponse.SC_CONFLICT,
                    e.getMessage()
            );

        } catch (ServletException | IOException e) {

            getServletContext().log(
                    "Errore UserVideoServlet",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore interno del server"
            );
        }
    }

    private void getUserVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long userId
                = parseLong(
                        request.getParameter("userId"),
                        "ID utente obbligatorio"
                );

        Long videoId
                = parseLong(
                        request.getParameter("videoId"),
                        "ID video obbligatorio"
                );

        UserVideo userVideo
                = userVideoService.getUserVideo(
                        userId,
                        videoId
                );

        request.setAttribute(
                "userVideo",
                userVideo
        );

        // --> JSP
        request.getRequestDispatcher(
                "/page/user/video.jsp"
        ).forward(
                request,
                response
        );
    }

    private void getUserVideos(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long userId
                = parseLong(
                        request.getParameter("userId"),
                        "ID utente obbligatorio"
                );

        List<UserVideo> userVideos
                = userVideoService.getUserVideos(
                        userId
                );

        request.setAttribute(
                "userVideos",
                userVideos
        );

        // --> JSP
        request.getRequestDispatcher(
                "/page/user/video-list.jsp"
        ).forward(
                request,
                response
        );
    }

    private void startVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long userId
                = parseLong(
                        request.getParameter("userId"),
                        "ID utente obbligatorio"
                );

        Long videoId
                = parseLong(
                        request.getParameter("videoId"),
                        "ID video obbligatorio"
                );

        Long posizione
                = parseLong(
                        request.getParameter("position"),
                        "Posizione obbligatoria"
                );

        UserVideo userVideo
                = userVideoService.iniziaVideo(
                        userId,
                        videoId,
                        posizione
                );

        response.sendRedirect(
                "UserVideoServlet?action=get"
                + "&userId="
                + userId
                + "&videoId="
                + videoId
        );
    }

    private void heartbeat(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long userId
                = parseLong(
                        request.getParameter("userId"),
                        "ID utente obbligatorio"
                );

        Long videoId
                = parseLong(
                        request.getParameter("videoId"),
                        "ID video obbligatorio"
                );

        Long posizione
                = parseLong(
                        request.getParameter("position"),
                        "Posizione obbligatoria"
                );

        userVideoService.aggiornaSessione(
                userId,
                videoId,
                posizione
        );

        response.setStatus(
                HttpServletResponse.SC_NO_CONTENT
        );
    }

    private void pauseVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long userId
                = parseLong(
                        request.getParameter("userId"),
                        "ID utente obbligatorio"
                );

        Long videoId
                = parseLong(
                        request.getParameter("videoId"),
                        "ID video obbligatorio"
                );

        Long posizione
                = parseLong(
                        request.getParameter("position"),
                        "Posizione obbligatoria"
                );

        userVideoService.mettiInPausa(
                userId,
                videoId,
                posizione
        );

        response.setStatus(
                HttpServletResponse.SC_NO_CONTENT
        );
    }

    private void completeVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long userId
                = parseLong(
                        request.getParameter("userId"),
                        "ID utente obbligatorio"
                );

        Long videoId
                = parseLong(
                        request.getParameter("videoId"),
                        "ID video obbligatorio"
                );

        Long posizione
                = parseLong(
                        request.getParameter("position"),
                        "Posizione obbligatoria"
                );

        UserVideo userVideo
                = userVideoService.completaVideo(
                        userId,
                        videoId,
                        posizione
                );

        response.sendRedirect(
                "UserVideoServlet?action=list"
                + "&userId="
                + userId
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
