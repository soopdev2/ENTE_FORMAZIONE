<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="entity.Video" %>
<%@ page import="entity.Modulo" %>

<%@ page import="service.VideoService" %>
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
                        + "/page/error/403.jsp"
        );

        return;
    }

    VideoService videoService = new VideoService();

    ModuloService moduloService = new ModuloService();

    String moduloIdParam = request.getParameter("moduloId");

    Long moduloId = null;

    if (moduloIdParam != null
            && !moduloIdParam.trim().isEmpty()) {

        try {

            moduloId = Long.valueOf(
                    moduloIdParam.trim()
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "ID modulo non valido"
            );

            return;
        }
    }

    List<Video> video;

    if (moduloId != null) {

        video = videoService.getVideoModulo(moduloId);

    } else {

        video = videoService.getAllVideos();

    }

    Modulo modulo = null;

    if (moduloId != null) {

        modulo = moduloService.getModulo(moduloId);

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

        <title>Gestione Video</title>


        <!-- Bootstrap -->

        <link
            href="<%= request.getContextPath()%>/assets/bootstrap/assets/css/bootstrap.min.css"
            rel="stylesheet"
            >

    </head>


    <body class="bg-light">



        <%@ include file="../Header.jsp" %>
        <%@ include file="../navbar.jsp" %>



        <main class="container py-5">


            <!-- HEADER -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="mb-1">
                        Video
                    </h1>


                    <p class="text-muted mb-0">

                        <%
                            if (moduloId != null) {

                                if (modulo != null) {
                        %>

                        Video del modulo:
                        <strong>
                            <%= modulo.getTitolo()%>
                        </strong>

                        <%
                        } else {
                        %>

                        Video appartenenti al modulo selezionato.

                        <%
                            }

                        } else {
                        %>

                        Gestisci tutti i video della formazione.

                        <%
                            }
                        %>

                    </p>

                </div>


                <!-- NUOVO VIDEO -->

                <!--div>

                    <%
                        if (moduloId != null) {
                    %>

                    <a
                        href="<%= request.getContextPath()%>/page/admin/video/crea.jsp?moduloId=<%= moduloId%>"
                        class="btn btn-primary"
                        >
                        + Nuovo video
                    </a>

                    <%
                    } else {
                    %>

                    <a
                        href="<%= request.getContextPath()%>/page/admin/video/crea.jsp?moduloId=<%= moduloId%>"
                        class="btn btn-primary"
                        >
                        + Nuovo video
                    </a>

                    <%
                        }
                    %>

                </div-->

            </div>


            <!-- =================================================
                 TABELLA
            ================================================== -->

            <div class="card shadow-sm">

                <div class="card-body p-0">

                    <div class="table-responsive">

                        <table class="table table-hover align-middle mb-0">


                            <thead class="table-dark">

                                <tr>

                                    <th>
                                        Ordine
                                    </th>

                                    <th>
                                        Titolo
                                    </th>

                                    <th>
                                        Durata
                                    </th>

                                    <th>
                                        Stato
                                    </th>

                                    <th>
                                        Modulo
                                    </th>

                                    <th class="text-end">
                                        Azioni
                                    </th>

                                </tr>

                            </thead>


                            <tbody>


                                <%
                                    if (video != null && !video.isEmpty()) {

                                        for (Video v : video) {
                                %>


                                <tr>


                                    <!-- ORDINE -->

                                    <td>

                                        <span class="badge bg-secondary">

                                            <%= v.getOrdine()%>

                                        </span>

                                    </td>


                                    <!-- TITOLO -->

                                    <td>

                                        <strong>
                                            <%= v.getTitolo()%>
                                        </strong>


                                        <%
                                            if (v.getDescrizione() != null
                                                    && !v.getDescrizione().isBlank()) {
                                        %>

                                        <div class="text-muted small mt-1">

                                            <%= v.getDescrizione()%>

                                        </div>

                                        <%
                                            }
                                        %>

                                    </td>


                                    <!-- DURATA -->

                                    <td>

                                        <%
                                            Long durata
                                                    = v.getDurataSecondi();

                                            if (durata == null) {
                                                durata = 0L;
                                            }

                                            long minuti
                                                    = durata / 60;

                                            long secondi
                                                    = durata % 60;
                                        %>

                                        <%= String.format(
                                                "%02d:%02d",
                                                minuti,
                                                secondi
                                        )%>




                                    </td>

                                    <!-- STATO -->

                                    <td>

                                        <%
                                            if (Boolean.TRUE.equals(
                                                    v.getAttivo())) {
                                        %>

                                        <span class="badge bg-success">
                                            Attivo
                                        </span>

                                        <%
                                        } else {
                                        %>

                                        <span class="badge bg-secondary">
                                            Disattivato
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>

                                    <!-- MODULO -->

                                    <td>

                                        <%
                                            if (v.getModulo() != null) {
                                        %>

                                        <strong>
                                            <%= v.getModulo().getTitolo()%>
                                        </strong>

                                        <%
                                        } else {
                                        %>

                                        <span class="text-muted">
                                            Nessun modulo
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>


                                    <!-- AZIONI -->

                                    <td class="text-end">

                                        <div class="btn-group">


                                            <!-- DETTAGLIO -->

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/dettaglio.jsp?id=<%= v.getId()%>"
                                                class="btn btn-sm btn-outline-primary"
                                                >
                                                Dettaglio
                                            </a>


                                            <!-- MODIFICA -->

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/modifica.jsp?id=<%= v.getId()%>"
                                                class="btn btn-sm btn-outline-warning"
                                                >
                                                Modifica
                                            </a>


                                            <!-- STATISTICHE -->

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/statistiche.jsp?videoId=<%= v.getId()%>"
                                                class="btn btn-sm btn-outline-info"
                                                >
                                                Statistiche
                                            </a>

                                            <!-- ATTIVA / DISATTIVA -->

                                            <%
                                                if (Boolean.TRUE.equals(
                                                        v.getAttivo())) {
                                            %>

                                            <a
                                                href="<%= request.getContextPath()%>/VideoServlet?action=deactivate&id=<%= v.getId()%>"
                                                class="btn btn-sm btn-outline-danger"
                                                onclick="return confirm('Disattivare questo video?');"
                                                >
                                                Disattiva
                                            </a>

                                            <%
                                            } else {
                                            %>

                                            <a
                                                href="<%= request.getContextPath()%>/VideoServlet?action=activate&id=<%= v.getId()%>"
                                                class="btn btn-sm btn-outline-success"
                                                >
                                                Attiva
                                            </a>

                                            <%
                                                }
                                            %>


                                        </div>

                                    </td>

                                </tr>


                                <%
                                    }
                                } else {
                                %>


                                <!-- NESSUN VIDEO -->

                                <tr>

                                    <td
                                        colspan="6"
                                        class="text-center py-5"
                                        >

                                        <div class="text-muted">


                                            <h5>
                                                Nessun video presente
                                            </h5>


                                            <p class="mb-3">
                                                Non sono ancora stati aggiunti video.
                                            </p>


                                            <%
                                                if (moduloId != null) {
                                            %>

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/crea.jsp?moduloId=<%= moduloId%>"
                                                class="btn btn-primary"
                                                >
                                                Crea il primo video
                                            </a>

                                            <%
                                            } else {
                                            %>

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/crea.jsp"
                                                class="btn btn-primary"
                                                >
                                                Crea il primo video
                                            </a>

                                            <%
                                                }
                                            %>


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


        <!-- Bootstrap JS -->

        <script
            src="<%= request.getContextPath()%>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>


    </body>

</html>