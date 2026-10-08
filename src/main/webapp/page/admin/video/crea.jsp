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

        <title>Nuovo video</title>


    </head>


    <body>


        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>


        <main class="container py-5 flex-grow-1">


            <div class="row justify-content-center">


                <div class="col-lg-8">


                    <!-- HEADER -->

                    <div class="d-flex justify-content-between align-items-center mb-4">


                        <div>

                            <h2 class="mb-1">

                                Nuovo video

                            </h2>

                            <p class="text-muted mb-0">

                                Inserisci i dati del nuovo video.

                            </p>

                        </div>


                        <%                            String videoUrl;

                            if (moduloId != null
                                    && !moduloId.trim().isEmpty()) {

                                videoUrl = request.getContextPath()
                                        + "/VideoServlet?action=listByModulo&moduloId="
                                        + moduloId;

                            } else {

                                videoUrl = request.getContextPath()
                                        + "/VideoServlet?action=list";

                            }

                        %>


                        <a
                            href="<%= videoUrl%>"
                            class="btn btn-outline-secondary"
                            >

                            <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-left-circle"></use></svg>
                            TORNA AI VIDEO

                        </a>


                    </div>


                    <!-- FORM -->

                    <div class="card shadow-sm">


                        <div class="card-body p-4">


                            <form
                                action="<%= request.getContextPath()%>/VideoServlet"
                                method="post"
                                enctype="multipart/form-data"
                                >


                                <!-- ACTION -->

                                <input
                                    type="hidden"
                                    name="action"
                                    value="create"
                                    >


                                <!-- CORSO E MODULO -->

                                <div class="row">


                                    <!-- CORSO -->

                                    <div class="col-md-6 mb-3">


                                        <label
                                            for="corsoId"
                                            class="form-label"
                                            >

                                            CORSO

                                        </label>


                                        <select
                                            class="form-select text-uppercase"
                                            id="corsoId"
                                            required
                                            >

                                            <option class="text-uppercase" value="">

                                                -- SELEZIONA UN CORSO --

                                            </option>


                                            <%

                                                java.util.Set<Long> corsiVisti
                                                        = new java.util.HashSet<>();

                                                if (moduli != null
                                                        && !moduli.isEmpty()) {

                                                    for (Modulo modulo : moduli) {

                                                        if (modulo.getCorso() == null) {
                                                            continue;
                                                        }

                                                        Long corsoId
                                                                = modulo.getCorso().getId();

                                                        if (corsiVisti.contains(corsoId)) {
                                                            continue;
                                                        }

                                                        corsiVisti.add(corsoId);

                                            %>


                                            <option class="text-uppercase"
                                                    value="<%= corsoId%>"
                                                    >

                                                <%= modulo.getCorso().getTitolo()%>

                                            </option>


                                            <%

                                                    }

                                                }

                                            %>


                                        </select>


                                    </div>


                                    <!-- MODULO -->

                                    <div class="col-md-6 mb-3">


                                        <label
                                            for="moduloId"
                                            class="form-label text-uppercase"
                                            >

                                            Modulo

                                        </label>


                                        <select
                                            class="form-select text-uppercase"
                                            id="moduloId"
                                            name="moduloId"
                                            required
                                            disabled
                                            >


                                            <option class="text-uppercase" value="">

                                                -- SELEZIONA PRIMA UN CORSO --

                                            </option>


                                            <%                                                if (moduli != null
                                                        && !moduli.isEmpty()) {

                                                    for (Modulo modulo : moduli) {

                                                        if (modulo.getCorso() == null) {
                                                            continue;
                                                        }

                                            %>


                                            <option class="text-uppercase"
                                                    value="<%= modulo.getId()%>"
                                                    data-corso="<%= modulo.getCorso().getId()%>"
                                                    <%= moduloId != null
                                                            && moduloId.equals(
                                                                    String.valueOf(
                                                                            modulo.getId()
                                                                    )
                                                            )
                                                            ? "selected"
                                                            : ""%>
                                                    >

                                                <%= modulo.getTitolo()%>

                                            </option>


                                            <%

                                                    }

                                                }

                                            %>


                                        </select>


                                        <div class="form-text">

                                            Seleziona prima il corso per visualizzare
                                            i relativi moduli.

                                        </div>


                                    </div>


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


                                <!-- TITOLO -->

                                <div class="mb-3">


                                    <label
                                        for="titolo"
                                        class="form-label text-uppercase"
                                        >

                                        Titolo

                                    </label>


                                    <input
                                        type="text"
                                        class="form-control text-uppercase"
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
                                        class="form-label text-uppercase"
                                        >

                                        Descrizione

                                    </label>


                                    <textarea
                                        class="form-control text-uppercase"
                                        id="descrizione"
                                        name="descrizione"
                                        rows="4"
                                        maxlength="1000"
                                        ></textarea>


                                </div>


                                <!-- FILE VIDEO -->

                                <div class="mb-3">


                                    <label
                                        for="video"
                                        class="form-label text-uppercase"
                                        >

                                        Video

                                    </label>


                                    <input
                                        type="file"
                                        class="form-control"
                                        id="video"
                                        name="video"
                                        accept="video/mp4"
                                        required
                                        >


                                    <div class="form-text">

                                        Seleziona il file video dal PC.
                                        La durata verrà rilevata automaticamente.

                                    </div>


                                </div>


                                <!-- ORDINE -->

                                <div class="row">


                                    <!-- ORDINE -->

                                    <div class="col-md-6 mb-3">


                                        <label
                                            for="ordine"
                                            class="form-label text-uppercase"
                                            >

                                            Ordine nel modulo

                                        </label>


                                        <input
                                            type="number"
                                            class="form-control text-uppercase"
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
                                    
                                    
                                    


                                    <button
                                        type="submit"
                                        class="btn btn-outline-primary"
                                        <%= (moduli == null || moduli.isEmpty()) ? "disabled" : ""%>
                                        >
                                        CREA VIDEO
                                        <svg class="icon icon-sm icon-primary" aria-hidden="true" style="margin-left:5px"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>

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



        <script
            src="../../../assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>


        <script>

            const corsoSelect =
                    document.getElementById("corsoId");

            const moduloSelect =
                    document.getElementById("moduloId");


            corsoSelect.addEventListener(
                    "change",
                    function () {

                        const corsoId =
                                this.value;


                        moduloSelect.value = "";


                        if (corsoId === "") {

                            moduloSelect.disabled = true;

                        } else {

                            moduloSelect.disabled = false;

                        }


                        const moduli =
                                moduloSelect.querySelectorAll(
                                        "option[data-corso]"
                                        );


                        moduli.forEach(
                                function (modulo) {

                                    modulo.hidden =
                                            modulo.dataset.corso
                                            !== corsoId;

                                }
                        );

                    }
            );


            const moduloSelezionato =
                    moduloSelect.querySelector(
                            "option[selected]"
                            );


            if (moduloSelezionato) {

                const corsoId =
                        moduloSelezionato.dataset.corso;


                if (corsoId) {

                    corsoSelect.value =
                            corsoId;

                    moduloSelect.disabled =
                            false;


                    const moduli =
                            moduloSelect.querySelectorAll(
                                    "option[data-corso]"
                                    );


                    moduli.forEach(
                            function (modulo) {

                                modulo.hidden =
                                        modulo.dataset.corso
                                        !== corsoId;

                            }
                    );

                }

            }

        </script>


    </body>

</html>
