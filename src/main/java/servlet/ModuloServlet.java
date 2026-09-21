package servlet;

import entity.Modulo;
import service.ModuloService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 *
 * @author Aldo
 */
public class ModuloServlet extends HttpServlet {

    private final ModuloService moduloService
            = new ModuloService();

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

                case "create":

                    createModulo(
                            request,
                            response
                    );

                    break;

                case "update":

                    updateModulo(
                            request,
                            response
                    );

                    break;

                case "activate":

                    activateModulo(
                            request,
                            response
                    );

                    break;

                case "deactivate":

                    deactivateModulo(
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

        } catch (IOException e) {

            getServletContext()
                    .log(
                            "Errore ModuloServlet",
                            e
                    );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore interno del server"
            );
        }
    }


    private void createModulo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String titolo
                = request.getParameter("titolo");

        String descrizione
                = request.getParameter("descrizione");

        Long corsoId
                = parseLong(
                        request.getParameter("corsoId"),
                        "ID corso obbligatorio"
                );

        Modulo modulo
                = moduloService.creaModulo(
                        titolo,
                        descrizione,
                        corsoId
                );

        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/moduli/dettaglio.jsp?id="
                + modulo.getId()
        );
    }

    private void updateModulo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long id
                = parseLong(
                        request.getParameter("id"),
                        "ID modulo obbligatorio"
                );

        String titolo
                = request.getParameter("titolo");

        String descrizione
                = request.getParameter("descrizione");

        Long corsoId
                = parseLong(
                        request.getParameter("corsoId"),
                        "ID corso obbligatorio"
                );

        Modulo modulo
                = moduloService.aggiornaModulo(
                        id,
                        titolo,
                        descrizione,
                        corsoId
                );


        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/moduli/dettaglio.jsp?id="
                + modulo.getId()
        );
    }


    private void activateModulo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long id
                = parseLong(
                        request.getParameter("id"),
                        "ID modulo obbligatorio"
                );

        Modulo modulo
                = moduloService.attivaModulo(id);


        /*
         * --> JSP
         */
        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/moduli/dettaglio.jsp?id="
                + modulo.getId()
        );
    }


    private void deactivateModulo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long id
                = parseLong(
                        request.getParameter("id"),
                        "ID modulo obbligatorio"
                );

        Modulo modulo
                = moduloService.disattivaModulo(id);


        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/moduli/dettaglio.jsp?id="
                + modulo.getId()
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
                    "ID non valido"
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
