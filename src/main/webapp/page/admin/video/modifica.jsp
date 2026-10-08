<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Video" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Video" %>
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

        <title>Modifica video</title>

    </head>

    <body>

        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>

        <main class="container py-5 flex-grow-1">

            <div class="row justify-content-center">

                <div class="col-lg-8">

                    <div class="d-flex justify-content-between align-items-center mb-4">

                        <div>
                            <h1 class="h3 mb-1">Modifica video</h1>
                            <p class="text-muted mb-0">
                                Modifica i dati del video.
                            </p>
                        </div>

                        <a
                            href="<%= request.getContextPath()%>/VideoServlet?action=get&id=<%= video.getId()%>"
                            class="btn btn-outline-secondary"
                            >
                            Annulla
                        </a>

                    </div>


                    <div class="card shadow-sm">

                        <div class="card-body p-4">

                            <form
                                action="<%= request.getContextPath()%>/VideoServlet"
                                method="post"
                                >

                                <input
                                    type="hidden"
                                    name="action"
                                    value="update"
                                    >

                                <input
                                    type="hidden"
                                    name="id"
                                    value="<%= video.getId()%>"
                                    >

                                <input
                                    type="hidden"
                                    name="moduloId"
                                    value="<%= video.getModulo().getId()%>"
                                    >


                                <!-- TITOLO -->

                                <div class="mb-3">

                                    <label
                                        for="titolo"
                                        class="form-label"
                                        >
                                        Titolo
                                    </label>

                                    <input
                                        type="text"
                                        class="form-control"
                                        id="titolo"
                                        name="titolo"
                                        value="<%= video.getTitolo()%>"
                                        required
                                        >

                                </div>


                                <!-- DESCRIZIONE -->

                                <div class="mb-3">

                                    <label
                                        for="descrizione"
                                        class="form-label"
                                        >
                                        Descrizione
                                    </label>

                                    <textarea
                                        class="form-control"
                                        id="descrizione"
                                        name="descrizione"
                                        rows="4"
                                        ><%= video.getDescrizione() != null
                                                ? video.getDescrizione()
                                                : ""%></textarea>

                                </div>


                                <!-- FILE PATH -->

                                <div class="mb-3">

                                    <label
                                        for="filePath"
                                        class="form-label"
                                        >
                                        Percorso video
                                    </label>

                                    <input
                                        type="text"
                                        class="form-control"
                                        id="filePath"
                                        name="filePath"
                                        value="<%= video.getFilePath()%>"
                                        required
                                        >

                                </div>


                                <div class="row">

                                    <!-- DURATA -->

                                    <div class="col-md-6 mb-3">

                                        <label
                                            for="durataSecondi"
                                            class="form-label"
                                            >
                                            Durata (secondi)
                                        </label>

                                        <input
                                            type="number"
                                            class="form-control"
                                            id="durataSecondi"
                                            name="durataSecondi"
                                            value="<%= String.valueOf(video.getDurataSecondi())%>"
                                            min="1"
                                            required
                                            >

                                    </div>


                                    <!-- ORDINE -->

                                    <div class="col-md-6 mb-3">

                                        <label
                                            for="ordine"
                                            class="form-label"
                                            >
                                            Ordine
                                        </label>

                                        <input
                                            type="number"
                                            class="form-control"
                                            id="ordine"
                                            name="ordine"
                                            value="<%= String.valueOf(video.getOrdine())%>"
                                            min="1"
                                            required
                                            >

                                    </div>

                                </div>


                                <!-- MODULO -->

                                <div class="mb-4">

                                    <label class="form-label">
                                        Modulo
                                    </label>

                                    <input
                                        type="text"
                                        class="form-control"
                                        value="<%= video.getModulo().getTitolo()%>"
                                        disabled
                                        >

                                    <div class="form-text">
                                        Il modulo non viene modificato da questa pagina.
                                    </div>

                                </div>


                                <!-- PULSANTI -->

                                <div class="d-flex justify-content-end gap-2">

                                    <a
                                        href="<%= request.getContextPath()%>/VideoServlet?action=get&id=<%= video.getId()%>"
                                        class="btn btn-secondary"
                                        >
                                        Annulla
                                    </a>

                                    <button
                                        type="submit"
                                        class="btn btn-primary"
                                        >
                                        Salva modifiche
                                    </button>

                                </div>

                            </form>

                        </div>

                    </div>

                </div>

            </div>

        </main>

        <div class="it-footer">
            <%@include file="../footer.jsp" %> 
        </div>           


        <script src="../../../assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js"></script>

    </body>

</html>