<%@page import="entity.User"%>
<%@page import="entity.Modulo"%>
<%@page import="Utility.Utils"%>
<%@page import="service.ModuloService"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    String moduloId
            = request.getParameter("moduloId");

    ModuloService moduloService
            = new ModuloService();

    java.util.List<Modulo> moduli
            = moduloService.getAllModuli();


%>

<!DOCTYPE html> <html lang="it">
    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>Nuovo video</title>


        <link
            href="../../../assets/bootstrap/assets/css/bootstrap.min.css"
            rel="stylesheet"
            >

    </head>


    <body>


        <%@ include file="../Header.jsp" %>
        <%@ include file="../navbar.jsp" %>


        <main class="container py-5">


            <div class="row justify-content-center">


                <div class="col-lg-8">


                    <!-- HEADER -->

                    <div class="d-flex justify-content-between align-items-center mb-4">


                        <div>

                            <h1 class="h3 mb-1">
                                Nuovo video
                            </h1>

                            <p class="text-muted mb-0">
                                Inserisci i dati del nuovo video.
                            </p>

                        </div>

                        <%                            String videoUrl;

                            if (moduloId != null && !moduloId.trim().isEmpty()) {
                                videoUrl = request.getContextPath()
                                        + "/VideoServlet?action=listByModulo&moduloId=" + moduloId;
                            } else {
                                videoUrl = request.getContextPath()
                                        + "/VideoServlet?action=list";
                            }
                        %>

                        <a href="<%= videoUrl%>" class="btn btn-outline-secondary">
                            ← Torna ai video
                        </a>






                    </div>


                    <!-- FORM -->

                    <div class="card shadow-sm">


                        <div class="card-body p-4">


                            <form
                                action="<%= request.getContextPath()%>/VideoServlet"
                                method="post"
                                >


                                <!-- ACTION -->

                                <input
                                    type="hidden"
                                    name="action"
                                    value="create"
                                    >


                                <!-- MODULO -->

                                <div class="mb-3">


                                    <label
                                        for="moduloId"
                                        class="form-label"
                                        >

                                        Modulo

                                    </label>


                                    <select
                                        class="form-select"
                                        id="moduloId"
                                        name="moduloId"
                                        required
                                        >


                                        <option value="">
                                            -- Seleziona un modulo --
                                        </option>


                                        <%

                                            if (moduli != null
                                                    && !moduli.isEmpty()) {

                                                for (Modulo modulo : moduli) {

                                                    boolean selezionato
                                                            = moduloId != null
                                                            && moduloId.equals(
                                                                    String.valueOf(
                                                                            modulo.getId()
                                                                    )
                                                            );

                                        %>


                                        <option
                                            value="<%= modulo.getId()%>"
                                            <%= selezionato ? "selected" : ""%>
                                            >

                                            <%= modulo.getTitolo()%>

                                        </option>


                                        <%

                                                }

                                            }

                                        %>


                                    </select>


                                    <div class="form-text">

                                        Se sei entrato dalla pagina di un modulo,
                                        il modulo viene selezionato automaticamente.

                                    </div>


                                    <%                                    if (moduli == null
                                                || moduli.isEmpty()) {

                                    %>


                                    <div class="alert alert-warning mt-3 mb-0">

                                        Non sono presenti moduli disponibili.
                                        Crea prima un modulo per poter inserire un video.

                                    </div>


                                    <%                                    }

                                    %>


                                </div>


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
                                        maxlength="255"
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
                                        maxlength="1000"
                                        ></textarea>


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
                                        placeholder="es. /videos/formazione/video1.mp4"
                                        required
                                        >


                                    <div class="form-text">

                                        Inserisci il percorso del file video.

                                    </div>


                                </div>


                                <!-- DURATA E ORDINE -->

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

                                            Ordine nel modulo

                                        </label>


                                        <input
                                            type="number"
                                            class="form-control"
                                            id="ordine"
                                            name="ordine"
                                            min="1"
                                            required
                                            >


                                        <div class="form-text">

                                            Ogni video deve avere un ordine
                                            diverso all'interno dello stesso modulo.

                                        </div>


                                    </div>


                                </div>


                                <!-- PULSANTI -->

                                <div class="d-flex justify-content-end gap-2 mt-4">


                                    <a
                                        href="<%= request.getContextPath()%>/VideoServlet?action=listByModulo<%= moduloId != null && !moduloId.trim().isEmpty() ? "&moduloId=" + moduloId : ""%>"
                                        class="btn btn-secondary"
                                        >

                                        Annulla

                                    </a>


                                    <button
                                        type="submit"
                                        class="btn btn-primary"
                                        <%= (moduli == null || moduli.isEmpty()) ? "disabled" : ""%>
                                        >

                                        Crea video

                                    </button>


                                </div>


                            </form>


                        </div>


                    </div>


                </div>


            </div>


        </main>


        <%@include file="../footer.jsp" %>


        <script
            src="../../../assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>


    </body>

</html>