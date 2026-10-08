<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Video" %>
<%@ page import="entity.Modulo" %>
<%@ page import="service.VideoService" %>
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
                + "/page/error/403.jsp"
        );

        return;
    }

    String idParam = request.getParameter("id");

    if (idParam == null || idParam.isEmpty()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID video mancante"
        );

        return;
    }

    Long videoId;

    try {

        videoId = Long.valueOf(idParam);

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID video non valido"
        );

        return;
    }

    VideoService videoService = new VideoService();

    Video video = videoService.getVideo(videoId);

    if (video == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Video non trovato"
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
            Dettaglio video
        </title>

    </head>


    <body>


        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>


        <main class="container py-5 flex-grow-1">


            <!-- HEADER -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="h3 mb-1">

                        <%= video.getTitolo()%>

                    </h1>


                    <p class="text-muted mb-0">

                        Dettaglio del video

                    </p>

                </div>


                <a
                    href="<%= request.getContextPath()%>/page/admin/video/lista.jsp"
                    class="btn btn-outline-secondary"
                    >

                    ← Torna ai video

                </a>

            </div>


            <div class="row g-4">


                <!-- INFORMAZIONI -->

                <div class="col-lg-8">

                    <div class="card shadow-sm">


                        <div class="card-header">

                            <h2 class="h5 mb-0">

                                Informazioni video

                            </h2>

                        </div>


                        <div class="card-body">


                            <!-- TITOLO -->

                            <div class="row mb-3">

                                <div class="col-md-4 fw-bold">

                                    Titolo

                                </div>


                                <div class="col-md-8">

                                    <%= video.getTitolo()%>

                                </div>

                            </div>


                            <!-- DESCRIZIONE -->

                            <div class="row mb-3">

                                <div class="col-md-4 fw-bold">

                                    Descrizione

                                </div>


                                <div class="col-md-8">

                                    <%
                                        if (video.getDescrizione() != null
                                                && !video.getDescrizione().isBlank()) {
                                    %>

                                    <%= video.getDescrizione()%>

                                    <%
                                    } else {
                                    %>

                                    <span class="text-muted">

                                        Nessuna descrizione

                                    </span>

                                    <%
                                        }
                                    %>

                                </div>

                            </div>


                            <!-- MODULO -->

                            <div class="row mb-3">

                                <div class="col-md-4 fw-bold">

                                    Modulo

                                </div>


                                <div class="col-md-8">

                                    <%= video.getModulo().getTitolo()%>

                                </div>

                            </div>


                            <!-- ORDINE -->

                            <div class="row mb-3">

                                <div class="col-md-4 fw-bold">

                                    Ordine

                                </div>


                                <div class="col-md-8">

                                    <%= video.getOrdine()%>

                                </div>

                            </div>


                            <!-- DURATA -->

                            <div class="row mb-3">

                                <div class="col-md-4 fw-bold">

                                    Durata

                                </div>


                                <div class="col-md-8">

                                    <%
                                        Long durata = video.getDurataSecondi();

                                        long minuti = durata / 60;

                                        long secondi = durata % 60;
                                    %>

                                    <%= String.format("%02d:%02d", minuti, secondi)%>

                                </div>

                            </div>


                            <!-- FILE PATH -->

                            <div class="row mb-3">

                                <div class="col-md-4 fw-bold">

                                    Percorso file

                                </div>


                                <div class="col-md-8">

                                    <code>

                                        <%= video.getFilePath()%>

                                    </code>

                                </div>

                            </div>


                            <!-- STATO -->

                            <div class="row">

                                <div class="col-md-4 fw-bold">

                                    Stato

                                </div>


                                <div class="col-md-8">

                                    <%
                                        if (Boolean.TRUE.equals(video.getAttivo())) {
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

                                </div>

                            </div>


                        </div>

                    </div>

                </div>


                <!-- AZIONI -->

                <div class="col-lg-4">

                    <div class="card shadow-sm">


                        <div class="card-header">

                            <h2 class="h5 mb-0">

                                Azioni

                            </h2>

                        </div>


                        <div class="card-body d-grid gap-2">


                            <!-- MODIFICA -->

                            <a
                                href="<%= request.getContextPath()%>/page/admin/video/modifica.jsp?id=<%= video.getId()%>"
                                class="btn btn-warning"
                                >

                                Modifica video

                            </a>


                            <!-- STATISTICHE -->

                            <a
                                href="<%= request.getContextPath()%>/page/admin/video/statistiche.jsp?videoId=<%= video.getId()%>"
                                class="btn btn-primary"
                                >

                                Visualizza statistiche

                            </a>


                            <!-- ATTIVA / DISATTIVA -->

                            <%
                                if (Boolean.TRUE.equals(video.getAttivo())) {
                            %>

                            <a
                                href="<%= request.getContextPath()%>/VideoServlet?action=deactivate&id=<%= video.getId()%>"
                                class="btn btn-outline-secondary"
                                >

                                Disattiva video

                            </a>

                            <%
                            } else {
                            %>

                            <a
                                href="<%= request.getContextPath()%>/VideoServlet?action=activate&id=<%= video.getId()%>"
                                class="btn btn-outline-success"
                                >

                                Attiva video

                            </a>

                            <%
                                }
                            %>


                            <!-- ELIMINA -->

                            <a
                                href="<%= request.getContextPath()%>/VideoServlet?action=delete&id=<%= video.getId()%>"
                                class="btn btn-outline-danger"
                                onclick="return confirm('Sei sicuro di voler eliminare questo video?');"
                                >

                                Elimina video

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
