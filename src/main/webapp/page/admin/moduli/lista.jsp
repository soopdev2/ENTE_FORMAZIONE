<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@page import="service.ModuloService"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Modulo" %>

<!DOCTYPE html>

<%

    String userIdSession
            = Utils.checkAttribute(
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

    Long userId
            = Long.valueOf(userIdSession);

    User utente
            = (User) session.getAttribute("user");

    if (utente == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/index.jsp"
        );

        return;
    }

    String uri
            = request.getRequestURI();

    String pageName
            = uri.substring(
                    uri.lastIndexOf("/") + 1
            );

    String ruolo
            = String.valueOf(
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

        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />

        <!-- BOOTSTRAP COMUNI E FONT TITILLIUM WEB -->
        <link rel="stylesheet" href="../../../Bootstrap2024/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="../../../Bootstrap2024/assets/css/global.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium+Web' rel='stylesheet'>
        <title>Gestione Moduli</title>
    </head>

    <body class="d-flex flex-column min-vh-100">

        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>

        <main class="container py-5 flex-grow-1">


            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h2 class="mb-1">
                        Moduli
                    </h2>

                    <p class="text-muted mb-0">
                        Gestisci i moduli della formazione.
                    </p>

                </div>


                <a
                    href="<%= request.getContextPath()%>/page/admin/moduli/crea.jsp"
                    class="btn btn-outline-primary"
                    >
                    AGGIUNGI 
                    <svg class="icon icon-sm icon-primary" aria-hidden="true" style="margin-left: 5px;"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>

                </a>

            </div>



            <div class="card shadow-sm">

                <div class="card-body p-0">

                    <div class="table-responsive">

                        <table class="table table-hover table-responsive">


                            <thead>

                                <tr>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        ID
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Titolo
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Corso
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Descrizione
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Stato
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Azioni
                                    </th>

                                </tr>

                            </thead>


                            <tbody>

                                <%
                                    if (moduli != null
                                            && !moduli.isEmpty()) {

                                        for (Modulo modulo : moduli) {

                                            boolean haVideo = modulo.getVideo() != null
                                                    && !modulo.getVideo().isEmpty();

                                            boolean moduloAttivo = haVideo;

                                %>


                                <tr>



                                    <td class="text-center text-uppercase">
                                        <%= modulo.getId()%>
                                    </td>



                                    <td class="text-center text-uppercase">

                                        <span class="fw-semibold">
                                            <%= modulo.getTitolo()%>
                                        </span>

                                    </td>



                                    <td class="text-center text-uppercase">

                                        <% if (modulo.getCorso() != null) {%>

                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/corsi/dettaglio.jsp?id=<%= modulo.getCorso().getId()%>"
                                            class="text-decoration-none text-uppercase"
                                            >

                                            <span class="fw-semibold">
                                                <%= modulo.getCorso().getTitolo()%>
                                            </span>


                                        </a>

                                        <% } else { %>

                                        <span class="text-muted text-center text-uppercase fw-semibold">
                                            Nessun corso
                                        </span>

                                        <% } %>

                                    </td>



                                    <td class="text-center text-uppercase">

                                        <%
                                            String descrizione
                                                    = modulo.getDescrizione();

                                            if (descrizione != null
                                                    && !descrizione.isBlank()) {
                                        %>

                                        <span class="fw-semibold">
                                            <%= descrizione%>
                                        </span>

                                        <%
                                        } else {
                                        %>

                                        <span class="text-muted text-center text-uppercase fw-semibold">
                                            Nessuna descrizione
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>



                                    <td class="text-center text-uppercase">

                                        <% if (moduloAttivo) { %>

                                        <span class="badge bg-success text-center text-uppercase">
                                            ATTIVO
                                        </span>

                                        <% } else { %>

                                        <span class="badge bg-secondary text-center text-uppercase">
                                            DISATTIVATO
                                        </span>

                                        <% }%>

                                    </td>


                                    <td class="text-center text-uppercase">

                                        <div class="container justify-content-center">


                                            <!-- DETTAGLIO -->

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/moduli/dettaglio.jsp?id=<%= modulo.getId()%>"
                                                class="btn btn-xs btn-outline-primary"
                                                >
                                                <svg class="icon icon-xs icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-burger"></use></svg>
                                            </a>


                                            <!-- MODIFICA -->

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/moduli/modifica.jsp?id=<%= modulo.getId()%>"
                                                class="btn btn-xs btn-outline-secondary"
                                                >
                                                <svg class="icon icon-xs icon-secondary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                                            </a>


                                            <!-- ATTIVA / DISATTIVA -->

                                            <% if (modulo.getAttivo()) {%>

                                            <a
                                                href="<%= request.getContextPath()%>/ModuloServlet?action=deactivate&id=<%= modulo.getId()%>"
                                                class="btn btn-xs btn-outline-danger"
                                                onclick="return confirm('Disattivare questo modulo?');"
                                                >
                                                <svg class="icon icon-xs icon-danger" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-close-circle"></use></svg>
                                            </a>

                                            <% } else {%>

                                            <a
                                                href="<%= request.getContextPath()%>/ModuloServlet?action=activate&id=<%= modulo.getId()%>"
                                                class="btn btn-sm btn-outline-success"
                                                >
                                                <svg class="icon icon-sm icon-success" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-check-circle"></use></svg>
                                                ATTIVA
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
                                        class="text-center py-5 text-uppercase"
                                        >

                                        <div class="text-muted text-uppercase">

                                            <h5>
                                                Nessun modulo presente
                                            </h5>

                                            <p class="mb-3 text-uppercase">
                                                Non sono ancora stati creati moduli.
                                            </p>

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/moduli/crea.jsp"
                                                class="btn btn-outline-primary text-uppercase"
                                                >
                                                <svg class="icon icon-sm icon-primary" style="margin-left:5px" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>
                                                CREA MODULO

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



        <div class="it-footer">
            <%@include file="../footer.jsp" %> 
        </div>           



        <script
            src="<%= request.getContextPath()%>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>

    </body>

</html>