<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="entity.Video" %>
<%@ page import="entity.UserVideo" %>
<%@ page import="entity.Corso" %>
<%@ page import="entity.UserCorso" %>

<%@ page import="service.VideoService" %>
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
                "ID utente non valido."
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

    String videoIdParam
            = request.getParameter(
                    "videoId"
            );

    if (videoIdParam == null
            || videoIdParam.isBlank()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID video mancante."
        );

        return;
    }

    Long videoId;

    try {

        videoId
                = Long.valueOf(
                        videoIdParam
                );

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID video non valido."
        );

        return;
    }

    VideoService videoService
            = new VideoService();

    UserVideoService userVideoService
            = new UserVideoService();

    UserCorsoService userCorsoService
            = new UserCorsoService();

    Video video
            = videoService.getVideo(
                    videoId
            );

    if (video == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Video non trovato."
        );

        return;
    }

    if (!Boolean.TRUE.equals(
            video.getAttivo()
    )) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Questo video non è disponibile."
        );

        return;
    }

    UserVideo userVideo
            = userVideoService.getUserVideo(
                    userId,
                    videoId
            );

    if (userVideo == null) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Non hai accesso a questo video."
        );

        return;
    }

    Corso corso = null;

    if (video.getModulo() != null) {

        corso
                = video.getModulo().getCorso();
    }

    if (corso == null) {

        response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Il video non è associato correttamente a un corso."
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
                "Non sei assegnato a questo corso."
        );

        return;
    }

    if (video.getModulo() == null
            || !Boolean.TRUE.equals(
                    video.getModulo().getAttivo()
            )) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Il modulo di questo video non è disponibile."
        );

        return;
    }

    boolean sbloccato
            = userVideoService.isVideoSbloccato(
                    userId,
                    videoId
            );

    if (!sbloccato) {
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



        <title>Video bloccato</title>

    </head>


    <body class="d-flex flex-column min-vh-100">


        <jsp:include page="/page/admin/Header.jsp" />
        <jsp:include page="/page/user/navbar.jsp" />


        <main class="container py-5 flex-grow-1">


            <div class="alert alert-warning text-center">

                <h2 class="mb-3">

                    Video bloccato

                </h2>


                <p class="mb-4">

                    Devi completare il video precedente
                    prima di poter guardare questo contenuto.

                </p>


                <a
                    href="<%= request.getContextPath()%>/page/user/video-list.jsp?moduloId=<%= video.getModulo().getId()%>"
                    class="btn btn-primary"
                    >

                    Torna ai video

                </a>

            </div>


        </main>

        <%@include file="../admin/footer.jsp" %>

    </body>

</html>


<%
        return;
    }

    Long secondiGuardati
            = userVideo.getSecondiGuardati();

    if (secondiGuardati == null) {

        secondiGuardati = 0L;
    }

    Long ultimaPosizione
            = userVideo.getUltimaPosizione();

    if (ultimaPosizione == null) {

        ultimaPosizione = 0L;
    }

    double percentuale
            = userVideo.getPercentuale();

    if (percentuale < 0) {

        percentuale = 0;
    }

    if (percentuale > 100) {

        percentuale = 100;
    }

    String stato
            = userVideo.getStato() != null
            ? userVideo.getStato().toString()
            : "DA_GUARDARE";

    String titolo
            = video.getTitolo();

    String descrizione
            = video.getDescrizione();

    String filePath
            = video.getFilePath();

    Long durataSecondi
            = video.getDurataSecondi();

    if (durataSecondi == null) {

        durataSecondi = 0L;
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
            <%= titolo%>
        </title>


        <!-- Bootstrap -->

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/assets/bootstrap/assets/css/bootstrap.min.css"
            >


        <style>

            body {
                background: #f5f6f8;
            }


            .video-container {
                max-width: 1100px;
                margin: 0 auto;
            }


            .video-wrapper {
                background: #000;
                border-radius: 12px;
                overflow: hidden;
            }


            .video-wrapper video {
                width: 100%;
                display: block;
            }


            .progress {
                height: 10px;
                border-radius: 10px;
            }


            .info-card {
                border: none;
                border-radius: 12px;
            }


            .presence-box {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.65);
                z-index: 9999;
                align-items: center;
                justify-content: center;
            }


            .presence-card {
                width: 90%;
                max-width: 450px;
                background: white;
                border-radius: 15px;
                padding: 30px;
                text-align: center;
            }

        </style>

    </head>


    <body>


        <!-- NAVBAR -->

        <jsp:include page="/page/user/navbar.jsp" />


        <main class="container py-4">


            <div class="video-container">


                <div class="mb-4">


                    <a
                        href="<%= request.getContextPath()%>/page/user/video-list.jsp?moduloId=<%= video.getModulo().getId()%>"
                        class="btn btn-outline-secondary mb-3"
                        >

                        ← Torna ai video

                    </a>


                    <p class="text-muted mb-1">

                        <%= corso.getTitolo()%>

                    </p>


                    <h1>

                        <%= titolo%>

                    </h1>


                    <%
                        if (descrizione != null
                                && !descrizione.isEmpty()) {
                    %>

                    <p class="text-muted">

                        <%= descrizione%>

                    </p>

                    <%
                        }
                    %>


                </div>



                <div class="video-wrapper shadow">


                    <video
                        id="videoPlayer"
                        controls
                        preload="metadata"
                        >

                        <source
                            src="<%= request.getContextPath()%>/VideoFileServlet?file=<%= filePath.substring(filePath.lastIndexOf("/") + 1)%>"
                            type="video/mp4"
                            >


                        Il tuo browser non supporta
                        la riproduzione video.

                    </video>


                </div>


                <div class="card info-card shadow-sm mt-4">


                    <div class="card-body">


                        <div class="d-flex justify-content-between mb-2">


                            <strong>

                                Progresso

                            </strong>


                            <span id="percentuale">

                                <%= String.format(
                                        "%.0f",
                                        percentuale
                                )%>%

                            </span>


                        </div>


                        <div class="progress">


                            <div
                                id="progressBar"
                                class="progress-bar"
                                role="progressbar"
                                style="width: <%= percentuale%>%"
                                ></div>


                        </div>


                        <div class="mt-3 text-muted">

                            Stato:

                            <strong id="statoVideo">

                                <%= stato%>

                            </strong>

                        </div>


                    </div>

                </div>


                <div class="card info-card shadow-sm mt-4">


                    <div class="card-body">


                        <h5 class="card-title">

                            Informazioni

                        </h5>


                        <div class="row">


                            <!-- DURATA -->

                            <div class="col-md-4">


                                <small class="text-muted">

                                    Durata

                                </small>


                                <div>

                                    <span id="durataVideo">

                                        0:00

                                    </span>

                                </div>


                            </div>


                            <!-- TEMPO GUARDATO -->

                            <div class="col-md-4">


                                <small class="text-muted">

                                    Tempo guardato

                                </small>


                                <div>

                                    <span id="tempoGuardato">

                                        <%= secondiGuardati%>
                                        secondi

                                    </span>

                                </div>


                            </div>


                            <!-- ULTIMA POSIZIONE -->

                            <div class="col-md-4">


                                <small class="text-muted">

                                    Ultima posizione

                                </small>


                                <div>

                                    <span id="ultimaPosizione">

                                        <%= ultimaPosizione%>
                                        secondi

                                    </span>

                                </div>


                            </div>


                        </div>


                    </div>

                </div>


            </div>


        </main>


        <div
            id="presenceBox"
            class="presence-box"
            >


            <div class="presence-card">


                <h3>

                    Stai ancora guardando?

                </h3>


                <p class="text-muted mt-3">

                    Conferma per continuare la riproduzione.

                </p>


                <button
                    type="button"
                    id="continueButton"
                    class="btn btn-primary"
                    >

                    Sì, continua

                </button>


            </div>


        </div>


        <script>


            const contextPath =
                    "<%= request.getContextPath()%>";


            const userId =
            <%= userId%>;


            const videoId =
            <%= videoId%>;


            const posizioneIniziale =
            <%= ultimaPosizione%>;


            const videoPlayer =
                    document.getElementById("videoPlayer");


            const progressBar =
                    document.getElementById("progressBar");


            const percentualeElement =
                    document.getElementById("percentuale");


            const statoElement =
                    document.getElementById("statoVideo");


            const tempoGuardatoElement =
                    document.getElementById("tempoGuardato");


            const ultimaPosizioneElement =
                    document.getElementById("ultimaPosizione");


            const durataElement =
                    document.getElementById("durataVideo");


            const presenceBox =
                    document.getElementById("presenceBox");


            const continueButton =
                    document.getElementById("continueButton");


            const servletUrl =
                    contextPath + "/UserVideoServlet";


            async function sendAction(action, position) {


                const params =
                        new URLSearchParams();


                params.append(
                        "action",
                        action
                        );


                params.append(
                        "userId",
                        userId
                        );


                params.append(
                        "videoId",
                        videoId
                        );


                params.append(
                        "position",
                        Math.floor(position)
                        );


                try {


                    const response =
                            await fetch(
                                    servletUrl,
                                    {
                                        method: "POST",

                                        headers: {
                                            "Content-Type":
                                                    "application/x-www-form-urlencoded"
                                        },

                                        body:
                                                params.toString()
                                    }
                            );


                    if (!response.ok) {

                        console.error(
                                "Errore UserVideoServlet:",
                                response.status
                                );

                    }


                    return response.ok;


                } catch (error) {


                    console.error(
                            "Errore comunicazione server:",
                            error
                            );


                    return false;
                }
            }



            function formatTime(seconds) {


                seconds =
                        Math.floor(seconds);


                const minutes =
                        Math.floor(
                                seconds / 60
                                );


                const remainingSeconds =
                        seconds % 60;


                return minutes
                        + ":"
                        + remainingSeconds
                        .toString()
                        .padStart(2, "0");
            }


            videoPlayer.addEventListener(
                    "loadedmetadata",
                    function () {


                        durataElement.textContent =
                                formatTime(
                                        videoPlayer.duration
                                        );


                        if (
                                posizioneIniziale > 0
                                &&
                                posizioneIniziale
                                < videoPlayer.duration
                                ) {


                            videoPlayer.currentTime =
                                    posizioneIniziale;
                        }

                    }
            );


            videoPlayer.addEventListener(
                    "play",
                    async function () {


                        const position =
                                videoPlayer.currentTime;


                        await sendAction(
                                "start",
                                position
                                );


                        statoElement.textContent =
                                "IN_CORSO";

                    }
            );



            let heartbeatInterval =
                    null;


            videoPlayer.addEventListener(
                    "play",
                    function () {


                        if (heartbeatInterval !== null) {

                            return;
                        }


                        heartbeatInterval =
                                setInterval(
                                        async function () {


                                            if (videoPlayer.paused) {

                                                return;
                                            }


                                            const position =
                                                    videoPlayer.currentTime;


                                            await sendAction(
                                                    "heartbeat",
                                                    position
                                                    );


                                            updateProgress();

                                        },
                                        10000
                                        );

                    }
            );

            videoPlayer.addEventListener(
                    "pause",
                    async function () {


                        const position =
                                videoPlayer.currentTime;


                        await sendAction(
                                "pause",
                                position
                                );


                        updateProgress();

                    }
            );

            function updateProgress() {


                if (!videoPlayer.duration) {

                    return;
                }


                const position =
                        videoPlayer.currentTime;


                const percentuale =
                        Math.floor(
                                (
                                        position
                                        /
                                    videoPlayer.duration
                                        ) * 100
                                );


                progressBar.style.width =
                        percentuale + "%";


                percentualeElement.textContent =
                        percentuale + "%";


                ultimaPosizioneElement.textContent =
                        Math.floor(position)
                        + " secondi";


                tempoGuardatoElement.textContent =
                        Math.floor(position)
                        + " secondi";

            }

            videoPlayer.addEventListener(
                    "timeupdate",
                    function () {

                        updateProgress();

                    }
            );


            videoPlayer.addEventListener(
                    "ended",
                    async function () {


                        const position =
                                Math.floor(
                                        videoPlayer.duration
                                        );


                        const completed =
                                await sendAction(
                                        "complete",
                                        position
                                        );


                        if (completed) {


                            progressBar.style.width =
                                    "100%";


                            percentualeElement.textContent =
                                    "100%";


                            statoElement.textContent =
                                    "COMPLETATO";

                        }

                    }
            );


            const PRESENCE_INTERVAL =
                    5 * 60 * 1000;


            let presenceTimer =
                    null;


            function startPresenceTimer() {


                clearTimeout(
                        presenceTimer
                        );


                presenceTimer =
                        setTimeout(
                                function () {


                                    if (!videoPlayer.paused) {


                                        videoPlayer.pause();


                                        presenceBox.style.display =
                                                "flex";
                                    }

                                },
                                PRESENCE_INTERVAL
                                );
            }



            continueButton.addEventListener(
                    "click",
                    function () {


                        presenceBox.style.display =
                                "none";


                        startPresenceTimer();


                        videoPlayer.play();

                    }
            );



            videoPlayer.addEventListener(
                    "play",
                    function () {

                        startPresenceTimer();

                    }
            );


            videoPlayer.addEventListener(
                    "pause",
                    function () {

                        clearTimeout(
                                presenceTimer
                                );

                    }
            );


        </script>


    </body>

</html>
