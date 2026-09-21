<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@page import="service.ModuloService"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Modulo" %>

<!DOCTYPE html>

<%
    
    String userIdSession =
            Utils.checkAttribute(
                    session,
                    "userId"
            );

    if (userIdSession == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/index.jsp"
        );

        return;
    }

    Long userId =
            Long.valueOf(userIdSession);



    User utente =
            (User) session.getAttribute("user");

    if (utente == null) {

        response.sendRedirect(
                request.getContextPath()
                        + "/index.jsp"
        );

        return;
    }



    String uri =
            request.getRequestURI();

    String pageName =
            uri.substring(
                    uri.lastIndexOf("/") + 1
            );

    String ruolo =
            String.valueOf(
                    utente.getRuolo().getId()
            );


     if (!Utils.isVisible(
            ruolo,
            request.getRequestURI().substring(
                    request.getContextPath().length()
            )
    )) {

        response.sendRedirect(
                request.getContextPath()
                        + "/page/error/403.jsp"
        );

        return;
    }
    ModuloService moduloService = new ModuloService();

    List<Modulo> moduli = moduloService.getAllModuli();
%>

<html lang="it">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>Gestione Moduli</title>

        <!-- Bootstrap -->
        <link
            href="<%= request.getContextPath() %>/assets/bootstrap/assets/css/bootstrap.min.css"
            rel="stylesheet"
            >

    </head>

    <body class="bg-light">

        <%@ include file="../../admin/Header.jsp" %>
        <%@ include file="../../admin/navbar.jsp" %>


        <main class="container py-5">



            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="mb-1">
                        Moduli
                    </h1>

                    <p class="text-muted mb-0">
                        Gestisci i moduli della formazione.
                    </p>

                </div>


                <a
                    href="<%= request.getContextPath() %>/page/admin/moduli/crea.jsp"
                    class="btn btn-primary"
                    >
                    + Nuovo modulo
                </a>

            </div>



            <div class="card shadow-sm">

                <div class="card-body p-0">

                    <div class="table-responsive">

                        <table class="table table-hover align-middle mb-0">

                            <thead class="table-dark">

                                <tr>

                                    <th>
                                        ID
                                    </th>

                                    <th>
                                        Titolo
                                    </th>

                                    <th>
                                        Corso
                                    </th>

                                    <th>
                                        Descrizione
                                    </th>

                                    <th>
                                        Stato
                                    </th>

                                    <th class="text-end">
                                        Azioni
                                    </th>

                                </tr>

                            </thead>


                            <tbody>

                                <%
                                    if (moduli != null
                                            && !moduli.isEmpty()) {

                                        for (Modulo modulo : moduli) {
                                %>


                                <tr>



                                    <td>
                                        <%= modulo.getId() %>
                                    </td>



                                    <td>

                                        <strong>
                                            <%= modulo.getTitolo() %>
                                        </strong>

                                    </td>



                                    <td>

                                        <% if (modulo.getCorso() != null) { %>

                                        <a
                                            href="<%= request.getContextPath() %>/page/admin/corsi/dettaglio.jsp?id=<%= modulo.getCorso().getId() %>"
                                            class="text-decoration-none"
                                            >

                                            <%= modulo.getCorso().getTitolo() %>

                                        </a>

                                        <% } else { %>

                                        <span class="text-muted">
                                            Nessun corso
                                        </span>

                                        <% } %>

                                    </td>



                                    <td>

                                        <%
                                            String descrizione =
                                                    modulo.getDescrizione();

                                            if (descrizione != null
                                                    && !descrizione.isBlank()) {
                                        %>

                                        <%= descrizione %>

                                        <%
                                        } else {
                                        %>

                                        <span class="text-muted">
                                            Nessuna descrizione
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>



                                    <td>

                                        <% if (modulo.getAttivo()) { %>

                                        <span class="badge bg-success">
                                            Attivo
                                        </span>

                                        <% } else { %>

                                        <span class="badge bg-secondary">
                                            Disattivato
                                        </span>

                                        <% } %>

                                    </td>


                                    <td class="text-end">

                                        <div class="btn-group">


                                            <!-- DETTAGLIO -->

                                            <a
                                                href="<%= request.getContextPath() %>/page/admin/moduli/dettaglio.jsp?id=<%= modulo.getId() %>"
                                                class="btn btn-sm btn-outline-primary"
                                                >
                                                Dettaglio
                                            </a>


                                            <!-- MODIFICA -->

                                            <a
                                                href="<%= request.getContextPath() %>/page/admin/moduli/modifica.jsp?id=<%= modulo.getId() %>"
                                                class="btn btn-sm btn-outline-warning"
                                                >
                                                Modifica
                                            </a>


                                            <!-- ATTIVA / DISATTIVA -->

                                            <% if (modulo.getAttivo()) { %>

                                            <a
                                                href="<%= request.getContextPath() %>/ModuloServlet?action=deactivate&id=<%= modulo.getId() %>"
                                                class="btn btn-sm btn-outline-danger"
                                                onclick="return confirm('Disattivare questo modulo?');"
                                                >
                                                Disattiva
                                            </a>

                                            <% } else { %>

                                            <a
                                                href="<%= request.getContextPath() %>/ModuloServlet?action=activate&id=<%= modulo.getId() %>"
                                                class="btn btn-sm btn-outline-success"
                                                >
                                                Attiva
                                            </a>

                                            <% } %>


                                        </div>

                                    </td>

                                </tr>


                                <%
                                        }

                                    } else {
                                %>


                                <tr>

                                    <td
                                        colspan="6"
                                        class="text-center py-5"
                                        >

                                        <div class="text-muted">

                                            <h5>
                                                Nessun modulo presente
                                            </h5>

                                            <p class="mb-3">
                                                Non sono ancora stati creati moduli.
                                            </p>

                                            <a
                                                href="<%= request.getContextPath() %>/page/admin/moduli/crea.jsp"
                                                class="btn btn-primary"
                                                >
                                                Crea il primo modulo
                                            </a>

                                        </div>

                                    </td>

                                </tr>


                                <%
                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

        </main>
                                
                                
                                <%@include file="../footer.jsp" %>


        <script
            src="<%= request.getContextPath() %>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>

    </body>

</html>