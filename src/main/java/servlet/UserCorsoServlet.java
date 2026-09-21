package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import service.UserCorsoService;

import java.io.IOException;

public class UserCorsoServlet extends HttpServlet {

    private final UserCorsoService userCorsoService
            = new UserCorsoService();

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

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

                case "assign":

                    assignCorso(
                            request,
                            response
                    );

                    break;

                case "remove":

                    removeCorso(
                            request,
                            response
                    );

                    break;

                default:

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Action non valida"
                    );

                    break;
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
                    "Errore UserCorsoServlet",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore interno del server"
            );
        }
    }

    private void assignCorso(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Long userId = parseLong(
                request.getParameter("userId"),
                "ID utente obbligatorio"
        );

        Long corsoId = parseLong(
                request.getParameter("corsoId"),
                "ID corso obbligatorio"
        );

        userCorsoService.assegnaCorso(
                userId,
                corsoId
        );

        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/corsi/utenti.jsp?corsoId="
                + corsoId
        );
    }

    private void removeCorso(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        Long userId = parseLong(
                request.getParameter("userId"),
                "ID utente obbligatorio"
        );

        Long corsoId = parseLong(
                request.getParameter("corsoId"),
                "ID corso obbligatorio"
        );

        userCorsoService.rimuoviAssegnazione(
                userId,
                corsoId
        );

        response.sendRedirect(
                request.getContextPath()
                + "/page/admin/corsi/utenti.jsp?corsoId="
                + corsoId
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

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        processRequest(
                request,
                response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        processRequest(
                request,
                response
        );
    }
}
