<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="entity.Video" %>
<%@ page import="entity.Modulo" %>
<%@ page import="entity.UserVideo" %>
<%@ page import="entity.StatoVideo" %>
<%@ page import="entity.Corso" %>
<%@ page import="entity.UserCorso" %>

<%@ page import="service.VideoService" %>
<%@ page import="service.ModuloService" %>
<%@ page import="service.UserVideoService" %>
<%@ page import="service.UserCorsoService" %>

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

    Long userId;

    try {

        userId
                = Long.valueOf(
                        userIdSession
                );

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID utente non valido"
        );

        return;
    }

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

    String moduloIdParam
            = request.getParameter(
                    "moduloId"
            );

    if (moduloIdParam == null
            || moduloIdParam.isBlank()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID modulo mancante"
        );

        return;
    }

    Long moduloId;

    try {

        moduloId
                = Long.valueOf(
                        moduloIdParam
                );

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID modulo non valido"
        );

        return;
    }

    ModuloService moduloService
            = new ModuloService();

    VideoService videoService
            = new VideoService();

    UserVideoService userVideoService
            = new UserVideoService();

    UserCorsoService userCorsoService
            = new UserCorsoService();

    Modulo modulo
            = moduloService.getModulo(
                    moduloId
            );

    if (modulo == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Modulo non trovato"
        );

        return;
    }

    Corso corso
            = modulo.getCorso();

    if (corso == null) {

        response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Il modulo non è associato ad alcun corso"
        );

        return;
    }

    Long corsoId
            = corso.getId();

    UserCorso userCorso
            = userCorsoService.getUserCorso(
                    userId,
                    corsoId
            );

    if (userCorso == null) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Non sei assegnato a questo corso"
        );

        return;
    }

    if (!Boolean.TRUE.equals(
            modulo.getAttivo()
    )) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Questo modulo non è disponibile"
        );

        return;
    }

    List<Video> video
            = videoService.getVideoAttiviModulo(
                    moduloId
            );

    List<UserVideo> userVideos
            = userVideoService.getUserVideos(
                    userId
            );

%>


<!DOCTYPE html>

<html lang="it">


    <head>

        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />

        <!-- BOOTSTRAP COMUNI E FONT TITILLIUM WEB -->
        <link rel="stylesheet" href="Bootstrap2024/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="Bootstrap2024/assets/css/global.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium+Web' rel='stylesheet'>

        <title>
            <%= modulo.getTitolo()%>
        </title>

    </head>


    <body class="d-flex flex-column min-vh-100">


        <!-- NAVBAR -->

        <%@ include file="../admin/Header.jsp" %>
        <%@ include file="navbar.jsp" %>


        <main class="container py-5 flex-grow-1">



            <div class="d-flex justify-content-between
                 align-items-center mb-4">


                <div>

                    <p class="text-muted mb-1">

                        <%= corso.getTitolo()%>

                    </p>


                    <h1 class="h3 mb-2">

                        <%= modulo.getTitolo()%>

                    </h1>


                    <%
                        if (modulo.getDescrizione() != null
                                && !modulo.getDescrizione().isBlank()) {
                    %>

                    <p class="text-muted mb-0">

                        <%= modulo.getDescrizione()%>

                    </p>

                    <%
                        }
                    %>

                </div>


                <a
                    href="<%= request.getContextPath()%>/page/user/moduli.jsp?corsoId=<%= corsoId%>"
                    class="btn btn-outline-secondary"
                    >

                    ← Moduli

                </a>


            </div>



            <div class="row g-4">


                <%
                    if (video == null || video.isEmpty()) {
                %>


                <!-- NESSUN VIDEO -->

                <div class="col-12">

                    <div class="card shadow-sm">

                        <div class="card-body text-center py-5">


                            <h2 class="h5">

                                Nessun video disponibile

                            </h2>


                            <p class="text-muted mb-0">

                                Questo modulo non contiene
                                ancora video disponibili.

                            </p>


                        </div>

                    </div>

                </div>


                <%
                } else {

                    for (Video v : video) {

                        UserVideo userVideo = null;

                        for (UserVideo uv : userVideos) {

                            if (uv.getVideo() != null
                                    && uv.getVideo()
                                            .getId()
                                            .equals(v.getId())) {

                                userVideo = uv;

                                break;
                            }
                        }

                        boolean assegnato
                                = userVideo != null;

                        boolean sbloccato
                                = false;

                        if (assegnato) {

                            try {

                                sbloccato
                                        = userVideoService.isVideoSbloccato(
                                                userId,
                                                v.getId()
                                        );

                            } catch (Exception e) {

                                sbloccato = false;
                            }
                        }

                        StatoVideo stato = null;

                        double percentuale = 0.0;

                        Long secondiGuardati = 0L;

                        if (userVideo != null) {

                            stato
                                    = userVideo.getStato();

                            if (userVideo.getPercentuale() != null) {

                                percentuale
                                        = userVideo.getPercentuale();
                            }

                            if (userVideo.getSecondiGuardati() != null) {

                                secondiGuardati
                                        = userVideo.getSecondiGuardati();
                            }
                        }

                        boolean completato
                                = stato == StatoVideo.COMPLETATO;

                        boolean inCorso
                                = stato == StatoVideo.IN_CORSO;

                %>


                <div class="col-12">


                    <div class="card shadow-sm">


                        <div class="card-body p-4">


                            <div class="row align-items-center">


                                <!-- ORDINE -->

                                <div
                                    class="col-md-1 text-center
                                    mb-3 mb-md-0"
                                    >

                                    <div class="fs-4 fw-bold">

                                        <%= v.getOrdine()%>

                                    </div>


                                    <small class="text-muted">

                                        Video

                                    </small>

                                </div>


                                <!-- INFORMAZIONI -->

                                <div
                                    class="col-md-6
                                    mb-3 mb-md-0"
                                    >

                                    <h2 class="h5 mb-2">

                                        <%= v.getTitolo()%>

                                    </h2>


                                    <%
                                        if (v.getDescrizione() != null
                                                && !v.getDescrizione()
                                                        .isBlank()) {
                                    %>

                                    <p class="text-muted mb-3">

                                        <%= v.getDescrizione()%>

                                    </p>

                                    <%
                                        }
                                    %>


                                    <!-- STATO -->

                                    <%
                                        if (!assegnato) {
                                    %>

                                    <span class="badge bg-secondary">

                                        Non assegnato

                                    </span>


                                    <%
                                    } else if (completato) {
                                    %>

                                    <span class="badge bg-success">

                                        Completato

                                    </span>


                                    <%
                                    } else if (inCorso) {
                                    %>

                                    <span
                                        class="badge bg-warning text-dark"
                                        >

                                        In corso

                                    </span>


                                    <%
                                    } else {
                                    %>

                                    <span class="badge bg-secondary">

                                        Da guardare

                                    </span>


                                    <%
                                        }
                                    %>


                                </div>


                                <!-- PROGRESSO -->

                                <div
                                    class="col-md-3
                                    mb-3 mb-md-0"
                                    >

                                    <div
                                        class="d-flex
                                        justify-content-between
                                        mb-1"
                                        >

                                        <small class="text-muted">

                                            Progresso

                                        </small>


                                        <small class="fw-semibold">

                                            <%= String.format(
                                                    "%.0f",
                                                    percentuale
                                            )%>%

                                        </small>

                                    </div>


                                    <div
                                        class="progress"
                                        role="progressbar"
                                        aria-valuenow="<%= percentuale%>"
                                        aria-valuemin="0"
                                        aria-valuemax="100"
                                        >

                                        <div
                                            class="progress-bar"
                                            style="width: <%= percentuale%>%"
                                            ></div>

                                    </div>


                                    <%
                                        if (secondiGuardati > 0) {
                                    %>

                                    <small class="text-muted">

                                        <%= secondiGuardati%>
                                        secondi guardati

                                    </small>

                                    <%
                                        }
                                    %>


                                </div>


                                <!-- AZIONE -->

                                <div
                                    class="col-md-2
                                    text-md-end"
                                    >


                                    <%
                                        if (!assegnato) {
                                    %>

                                    <button
                                        type="button"
                                        class="btn btn-secondary"
                                        disabled
                                        >

                                        Non disponibile

                                    </button>


                                    <%
                                    } else if (!sbloccato) {
                                    %>

                                    <button
                                        type="button"
                                        class="btn btn-outline-secondary"
                                        disabled
                                        >

                                        🔒 Bloccato

                                    </button>


                                    <%
                                    } else if (completato) {
                                    %>

                                    <a
                                        href="<%= request.getContextPath()%>/page/user/video.jsp?videoId=<%= v.getId()%>"
                                        class="btn btn-outline-success"
                                        >

                                        Rivedi

                                    </a>


                                    <%
                                    } else if (inCorso) {
                                    %>

                                    <a
                                        href="<%= request.getContextPath()%>/page/user/video.jsp?videoId=<%= v.getId()%>"
                                        class="btn btn-warning"
                                        >

                                        Continua

                                    </a>


                                    <%
                                    } else {
                                    %>

                                    <a
                                        href="<%= request.getContextPath()%>/page/user/video.jsp?videoId=<%= v.getId()%>"
                                        class="btn btn-primary"
                                        >

                                        Inizia

                                    </a>


                                    <%
                                        }
                                    %>


                                </div>


                            </div>


                        </div>

                    </div>


                </div>


                <%
                        }

                    }
                %>


            </div>


        </main>

                <%@include file="../admin/footer.jsp" %>

        <!-- Bootstrap JS -->

        <script
            src="<%= request.getContextPath()%>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js"
        ></script>


    </body>

</html>
