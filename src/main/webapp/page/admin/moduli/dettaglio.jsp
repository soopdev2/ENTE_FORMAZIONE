<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Modulo" %>
<%@ page import="service.ModuloService" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

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

    ModuloService moduloService
            = new ModuloService();

    Modulo modulo
            = moduloService.getModulo(moduloId);

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

        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />

        <!-- BOOTSTRAP COMUNI E FONT TITILLIUM WEB -->
        <link rel="stylesheet" href="../../../Bootstrap2024/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="../../../Bootstrap2024/assets/css/global.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium+Web' rel='stylesheet'>

        <title>
            <%= modulo.getTitolo()%>
        </title>



    </head>


    <body class="d-flex flex-column min-vh-100">


        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>


        <main class="container py-5 flex-grow-1">



            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h2 class="mb-1">
                        <%= modulo.getTitolo()%>
                    </h2>

                    <p class="text-muted mb-0">
                        Dettaglio del modulo
                    </p>

                </div>


                <div class="d-flex gap-2">


                    <!-- TORNA ALLA LISTA -->

                    <a
                        href="<%= request.getContextPath()%>/page/admin/moduli/lista.jsp"
                        class="btn btn-outline-secondary"
                        >

                        <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="<%= request.getContextPath()%>/Bootstrap2024/assets/svg/sprites.svg#it-arrow-left-circle"></use></svg>
                        Moduli
                    </a>


                    <!-- DETTAGLIO CORSO -->

                    <% if (modulo.getCorso() != null) {%>

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/dettaglio.jsp?id=<%= modulo.getCorso().getId()%>"
                        class="btn btn-outline-primary"
                        >
                        <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="<%= request.getContextPath()%>/Bootstrap2024/assets/svg/sprites.svg#it-arrow-left-circle"></use></svg>
                        Corso
                    </a>

                    <% }%>


                    <!-- MODIFICA -->

                    <a
                        href="<%= request.getContextPath()%>/page/admin/moduli/modifica.jsp?id=<%= modulo.getId()%>"
                        class="btn btn-outline-warning"
                        >
                        <svg class="icon icon-sm me-2 icon-warning" aria-hidden="true"><use href="<%= request.getContextPath()%>/Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                        Modifica
                    </a>

                </div>

            </div>


            <div class="row g-4">



                <div class="col-lg-8">

                    <div class="card shadow-sm h-100">


                        <div class="card-header bg-white">

                            <h5 class="mb-0 text-uppercase">
                                Informazioni modulo
                            </h5>

                        </div>


                        <div class="card-body">


                            <!-- TITOLO -->

                            <div class="mb-4">

                                <label class="text-muted small text-uppercase">
                                    Titolo
                                </label>

                                <div class="fs-5 fw-semibold text-uppercase">
                                    <%= modulo.getTitolo()%>
                                </div>

                            </div>


                            <!-- CORSO -->

                            <div class="mb-4">

                                <label class="text-muted small text-uppercase">
                                    Corso
                                </label>

                                <div>

                                    <% if (modulo.getCorso() != null) {%>

                                    <a
                                        href="<%= request.getContextPath()%>/page/admin/corsi/dettaglio.jsp?id=<%= modulo.getCorso().getId()%>"
                                        class="text-decoration-none fw-semibold"
                                        >

                                        <%= modulo.getCorso().getTitolo()%>

                                    </a>

                                    <% } else { %>

                                    <span class="text-muted text-uppercase">
                                        Nessun corso associato
                                    </span>

                                    <% } %>

                                </div>

                            </div>


                            <!-- DESCRIZIONE -->

                            <div class="mb-4 text-uppercase">

                                <label class="text-muted small text-uppercase">
                                    Descrizione
                                </label>


                                <div>

                                    <%
                                        if (modulo.getDescrizione() != null
                                                && !modulo.getDescrizione().isBlank()) {
                                    %>

                                    <%= modulo.getDescrizione()%>

                                    <%
                                    } else {
                                    %>

                                    <span class="text-muted text-uppercase">
                                        Nessuna descrizione disponibile.
                                    </span>

                                    <%
                                        }
                                    %>

                                </div>

                            </div>


                            <!-- ID -->

                            <div>

                                <label class="text-muted small text-uppercase">
                                    ID modulo
                                </label>

                                <div>
                                    #<%= modulo.getId()%>
                                </div>

                            </div>


                        </div>

                    </div>

                </div>



                <div class="col-lg-4">

                    <div class="card shadow-sm">


                        <div class="card-header bg-white">

                            <h5 class="mb-0 text-uppercase">
                                Stato
                            </h5>

                        </div>


                        <div class="card-body d-flex flex-column">


                            <div class="mb-4 text-uppercase">

                                <%
                                    if (Boolean.TRUE.equals(
                                            modulo.getAttivo())) {
                                %>

                                <span class="badge bg-success fs-6 text-uppercase">
                                    Attivo
                                </span>

                                <p class="text-muted mt-2 mb-0 text-uppercase">
                                    Il modulo è attualmente disponibile.
                                </p>

                                <%
                                } else {
                                %>

                                <span class="badge bg-secondary fs-6 text-uppercase">
                                    Disattivato
                                </span>

                                <p class="text-muted mt-2 mb-0 text-uppercase">
                                    Il modulo non è attualmente disponibile.
                                </p>

                                <%
                                    }
                                %>

                            </div>


                            <!-- ATTIVA / DISATTIVA -->

                            <div class="text-center">

                                <%
                                    if (Boolean.TRUE.equals(
                                            modulo.getAttivo())) {
                                %>

                                <a
                                    href="<%= request.getContextPath()%>/ModuloServlet?action=deactivate&id=<%= modulo.getId()%>"
                                    class="btn btn-outline-danger text-uppercase"
                                    onclick="return confirm('Disattivare questo modulo?');"
                                    >
                                    <svg class="icon icon-sm icon-warning" style="margin-left:5px;" aria-hidden="true"><use href="<%= request.getContextPath()%>/Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                                    Disattiva modulo
                                </a>

                                <%
                                } else {
                                %>

                                <a
                                    href="<%= request.getContextPath()%>/ModuloServlet?action=activate&id=<%= modulo.getId()%>"
                                    class="btn btn-outline-success text-uppercase"
                                    >
                                    <svg class="icon icon-sm icon-success" style="margin-left:5px"aria-hidden="true"><use href="<%= request.getContextPath()%>/Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
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

                            <h4 class="mb-2 text-uppercase">
                                Video del modulo
                            </h4>

                            <p class="text-muted mb-md-0">
                                Visualizza e gestisci i video associati
                                a questo modulo.
                            </p>

                        </div>


                        <div class="col-md-4 text-md-end mt-3 mt-md-0">

                            <a
                                href="<%= request.getContextPath()%>/page/admin/video/lista.jsp?moduloId=<%= modulo.getId()%>"
                                class="btn btn-outline-primary"
                                >
                                GESTISCI VIDEO
                                <svg class="icon icon-sm icon-primary" style="margin-left: 5px" aria-hidden="true"><use href="<%= request.getContextPath()%>/Bootstrap2024/assets/svg/sprites.svg#it-arrow-right-circle"></use></svg>
                            </a>

                        </div>


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