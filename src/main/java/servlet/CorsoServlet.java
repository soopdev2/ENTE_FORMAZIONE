package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import service.CorsoService;

import java.io.IOException;

public class CorsoServlet extends HttpServlet {

    private final CorsoService corsoService
            = new CorsoService();

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String action
                = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Action mancante"
            );

            return;
        }

        try {

            switch (action) {

                case "create":

                    createCorso(
                            request,
                            response
                    );

                    break;

                case "update":

                    updateCorso(
                            request,
                            response
                    );

                    break;

                case "activate":

                    activateCorso(
                            request,
                            response
                    );

                    break;

                case "deactivate":

                    deactivateCorso(
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

        } catch (IOException e) {

            getServletContext().log(
                    "Errore CorsoServlet",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore interno del server"
            );
        }
    }

    private void createCorso(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String titolo
                = request.getParameter("titolo");

        String descrizione
                = request.getParameter("descrizione");

        corsoService.creaCorso(
                titolo,
                descrizione
        );

        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/corsi/lista.jsp"
        );
    }

    private void updateCorso(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Long id = parseLong(
                request.getParameter("id"),
                "ID corso obbligatorio"
        );

        String titolo
                = request.getParameter("titolo");

        String descrizione
                = request.getParameter("descrizione");

        corsoService.aggiornaCorso(
                id,
                titolo,
                descrizione
        );

        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/corsi/dettaglio.jsp?id="
                + id
        );
    }

    private void activateCorso(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Long id = parseLong(
                request.getParameter("id"),
                "ID corso obbligatorio"
        );

        corsoService.attivaCorso(id);

        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/corsi/dettaglio.jsp?id="
                + id
        );
    }

    private void deactivateCorso(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Long id = parseLong(
                request.getParameter("id"),
                "ID corso obbligatorio"
        );

        corsoService.disattivaCorso(id);

        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/corsi/dettaglio.jsp?id="
                + id
        );
    }

    private Long parseLong(
            String value,
            String message
    ) {

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
