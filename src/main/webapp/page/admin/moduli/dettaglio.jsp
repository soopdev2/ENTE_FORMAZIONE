<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Modulo" %>
<%@ page import="service.ModuloService" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

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
                        + "page/error/403.jsp"
        );

        return;
    }

    String idParam = request.getParameter("id");

    if (idParam == null || idParam.isEmpty()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID modulo mancante"
        );

        return;
    }

    Long moduloId;

    try {

        moduloId = Long.valueOf(idParam);

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID modulo non valido"
        );

        return;
    }


    ModuloService moduloService =
            new ModuloService();

    Modulo modulo =
            moduloService.getModulo(moduloId);


    if (modulo == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Modulo non trovato"
        );

        return;
    }
%>


<!DOCTYPE html>
<html lang="it">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>
            <%= modulo.getTitolo() %>
        </title>


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
                        <%= modulo.getTitolo() %>
                    </h1>

                    <p class="text-muted mb-0">
                        Dettaglio del modulo
                    </p>

                </div>


                <div class="d-flex gap-2">


                    <!-- TORNA ALLA LISTA -->

                    <a
                        href="<%= request.getContextPath() %>/page/admin/moduli/lista.jsp"
                        class="btn btn-outline-secondary"
                        >
                        ← Moduli
                    </a>


                    <!-- DETTAGLIO CORSO -->

                    <% if (modulo.getCorso() != null) { %>

                    <a
                        href="<%= request.getContextPath() %>/page/admin/corsi/dettaglio.jsp?id=<%= modulo.getCorso().getId() %>"
                        class="btn btn-outline-primary"
                        >
                        ← Corso
                    </a>

                    <% } %>


                    <!-- MODIFICA -->

                    <a
                        href="<%= request.getContextPath() %>/page/admin/moduli/modifica.jsp?id=<%= modulo.getId() %>"
                        class="btn btn-warning"
                        >
                        Modifica
                    </a>

                </div>

            </div>


            <div class="row g-4">



                <div class="col-lg-8">

                    <div class="card shadow-sm h-100">


                        <div class="card-header bg-white">

                            <h5 class="mb-0">
                                Informazioni modulo
                            </h5>

                        </div>


                        <div class="card-body">


                            <!-- TITOLO -->

                            <div class="mb-4">

                                <label class="text-muted small">
                                    Titolo
                                </label>

                                <div class="fs-5 fw-semibold">
                                    <%= modulo.getTitolo() %>
                                </div>

                            </div>


                            <!-- CORSO -->

                            <div class="mb-4">

                                <label class="text-muted small">
                                    Corso
                                </label>

                                <div>

                                    <% if (modulo.getCorso() != null) { %>

                                    <a
                                        href="<%= request.getContextPath() %>/page/admin/corsi/dettaglio.jsp?id=<%= modulo.getCorso().getId() %>"
                                        class="text-decoration-none fw-semibold"
                                        >

                                        <%= modulo.getCorso().getTitolo() %>

                                    </a>

                                    <% } else { %>

                                    <span class="text-muted">
                                        Nessun corso associato
                                    </span>

                                    <% } %>

                                </div>

                            </div>


                            <!-- DESCRIZIONE -->

                            <div class="mb-4">

                                <label class="text-muted small">
                                    Descrizione
                                </label>


                                <div>

                                    <%
                                        if (modulo.getDescrizione() != null
                                                && !modulo.getDescrizione().isBlank()) {
                                    %>

                                    <%= modulo.getDescrizione() %>

                                    <%
                                    } else {
                                    %>

                                    <span class="text-muted">
                                        Nessuna descrizione disponibile.
                                    </span>

                                    <%
                                        }
                                    %>

                                </div>

                            </div>


                            <!-- ID -->

                            <div>

                                <label class="text-muted small">
                                    ID modulo
                                </label>

                                <div>
                                    #<%= modulo.getId() %>
                                </div>

                            </div>


                        </div>

                    </div>

                </div>



                <div class="col-lg-4">

                    <div class="card shadow-sm h-100">


                        <div class="card-header bg-white">

                            <h5 class="mb-0">
                                Stato
                            </h5>

                        </div>


                        <div class="card-body d-flex flex-column">


                            <div class="mb-4">

                                <%
                                    if (Boolean.TRUE.equals(
                                            modulo.getAttivo())) {
                                %>

                                <span class="badge bg-success fs-6">
                                    Attivo
                                </span>

                                <p class="text-muted mt-2 mb-0">
                                    Il modulo è attualmente disponibile.
                                </p>

                                <%
                                } else {
                                %>

                                <span class="badge bg-secondary fs-6">
                                    Disattivato
                                </span>

                                <p class="text-muted mt-2 mb-0">
                                    Il modulo non è attualmente disponibile.
                                </p>

                                <%
                                    }
                                %>

                            </div>


                            <!-- ATTIVA / DISATTIVA -->

                            <div class="mt-auto">

                                <%
                                    if (Boolean.TRUE.equals(
                                            modulo.getAttivo())) {
                                %>

                                <a
                                    href="<%= request.getContextPath() %>/ModuloServlet?action=deactivate&id=<%= modulo.getId() %>"
                                    class="btn btn-outline-danger w-100"
                                    onclick="return confirm('Disattivare questo modulo?');"
                                    >
                                    Disattiva modulo
                                </a>

                                <%
                                } else {
                                %>

                                <a
                                    href="<%= request.getContextPath() %>/ModuloServlet?action=activate&id=<%= modulo.getId() %>"
                                    class="btn btn-outline-success w-100"
                                    >
                                    Attiva modulo
                                </a>

                                <%
                                    }
                                %>

                            </div>

                        </div>

                    </div>

                </div>

            </div>



            <div class="card shadow-sm mt-4">

                <div class="card-body p-4">

                    <div class="row align-items-center">


                        <div class="col-md-8">

                            <h4 class="mb-2">
                                Video del modulo
                            </h4>

                            <p class="text-muted mb-md-0">
                                Visualizza e gestisci i video associati
                                a questo modulo.
                            </p>

                        </div>


                        <div class="col-md-4 text-md-end mt-3 mt-md-0">

                            <a
                                href="<%= request.getContextPath() %>/page/admin/video/lista.jsp?moduloId=<%= modulo.getId() %>"
                                class="btn btn-primary"
                                >
                                Gestisci video →
                            </a>

                        </div>


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