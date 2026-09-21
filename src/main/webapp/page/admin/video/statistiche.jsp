<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Video" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Video" %>
<%@ page import="entity.Modulo" %>
<%@ page import="service.VideoService" %>
<%@ page import="service.AdminVideoStatsService" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Video" %>
<%@ page import="service.VideoService" %>
<%@ page import="service.AdminVideoStatsService" %>
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
    
    String videoIdParam = request.getParameter("videoId");

    if (videoIdParam == null || videoIdParam.isEmpty()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID video mancante"
        );

        return;
    }

    Long videoId;

    try {

        videoId = Long.valueOf(videoIdParam);

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID video non valido"
        );

        return;
    }

    VideoService videoService = new VideoService();
    AdminVideoStatsService statsService = new AdminVideoStatsService();

    Video video = videoService.getVideo(videoId);

    if (video == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Video non trovato"
        );

        return;
    }

    long totaleUtenti = statsService.getTotaleUtenti(videoId);
    long utentiCompletati = statsService.getUtentiCompletati(videoId);
    long utentiInCorso = statsService.getUtentiInCorso(videoId);
    long utentiDaGuardare = statsService.getUtentiDaGuardare(videoId);
%>

<!DOCTYPE html>
<html lang="it">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>Statistiche video</title>

        <link
            href="../../../assets/bootstrap/assets/css/bootstrap.min.css"
            rel="stylesheet"
            >

    </head>

    <body>

        <%@ include file="../Header.jsp" %>
        <%@ include file="../navbar.jsp" %>

        <main class="container py-5">

            <!-- HEADER -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="h3 mb-1">
                        Statistiche video
                    </h1>

                    <p class="text-muted mb-0">
                        <%= video.getTitolo()%>
                    </p>

                </div>

                <a
                    href="<%= request.getContextPath()%>/page/admin/video/dettaglio.jsp?id=<%= video.getId()%>"
                    class="btn btn-outline-secondary"
                    >
                    ← Dettaglio video
                </a>

            </div>


            <!-- STATISTICHE -->

            <div class="row g-4 mb-4">

                <!-- TOTALE -->

                <div class="col-md-6 col-xl-3">

                    <div class="card shadow-sm h-100">

                        <div class="card-body">

                            <p class="text-muted mb-2">
                                Utenti totali
                            </p>

                            <h2 class="display-6 fw-bold mb-0">
                                <%= totaleUtenti%>
                            </h2>

                        </div>

                    </div>

                </div>


                <!-- COMPLETATI -->

                <div class="col-md-6 col-xl-3">

                    <div class="card shadow-sm h-100">

                        <div class="card-body">

                            <p class="text-muted mb-2">
                                Completati
                            </p>

                            <h2 class="display-6 fw-bold text-success mb-0">
                                <%= utentiCompletati%>
                            </h2>

                        </div>

                    </div>

                </div>


                <!-- IN CORSO -->

                <div class="col-md-6 col-xl-3">

                    <div class="card shadow-sm h-100">

                        <div class="card-body">

                            <p class="text-muted mb-2">
                                In corso
                            </p>

                            <h2 class="display-6 fw-bold text-warning mb-0">
                                <%= utentiInCorso%>
                            </h2>

                        </div>

                    </div>

                </div>


                <!-- DA GUARDARE -->

                <div class="col-md-6 col-xl-3">

                    <div class="card shadow-sm h-100">

                        <div class="card-body">

                            <p class="text-muted mb-2">
                                Da guardare
                            </p>

                            <h2 class="display-6 fw-bold text-secondary mb-0">
                                <%= utentiDaGuardare%>
                            </h2>

                        </div>

                    </div>

                </div>

            </div>


            <!-- RIEPILOGO -->

            <div class="card shadow-sm mb-4">

                <div class="card-header">

                    <h2 class="h5 mb-0">
                        Riepilogo
                    </h2>

                </div>

                <div class="card-body">

                    <div class="row">

                        <div class="col-md-6 mb-3">

                            <strong>Video</strong>

                            <div>
                                <%= video.getTitolo()%>
                            </div>

                        </div>


                        <div class="col-md-6 mb-3">

                            <strong>Modulo</strong>

                            <div>
                                <%= video.getModulo().getTitolo()%>
                            </div>

                        </div>


                        <div class="col-md-6">

                            <strong>Ordine</strong>

                            <div>
                                <%= video.getOrdine()%>
                            </div>

                        </div>


                        <div class="col-md-6">

                            <strong>Stato</strong>

                            <div>

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

            <div class="d-flex gap-2">

                <a
                    href="<%= request.getContextPath()%>/page/admin/video/utenti.jsp?videoId=<%= video.getId()%>"
                    class="btn btn-primary"
                    >
                    Visualizza utenti
                </a>

                <a
                    href="<%= request.getContextPath()%>/page/admin/video/dettaglio.jsp?id=<%= video.getId()%>"
                    class="btn btn-outline-secondary"
                    >
                    Torna al video
                </a>

            </div>

        </main>

                    <%@include file="../../admin/footer.jsp" %>

        <script src="../../../assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js"></script>

    </body>

</html>