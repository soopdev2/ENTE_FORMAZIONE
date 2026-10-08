<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="entity.Corso" %>
<%@ page import="service.CorsoService" %>

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

    CorsoService corsoService = new CorsoService();

    List<Corso> corsi
            = corsoService.getCorsiAttivi();

    String corsoIdParam = request.getParameter("corsoId");

%>


<!DOCTYPE html>



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
        Nuovo Modulo
    </title>

</head>


<body class="d-flex flex-column min-vh-100">


    <%@ include file="../menu/head.jsp" %>
    <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
    <%@ include file="../navbar.jsp" %>

    <main class="container py-5 flex-grow-1">


        <div class="container py-5 flex-grow-1">


            <div class="row justify-content-center">

                <div class="col-lg-8">


                    <!-- HEADER -->

                    <div class="d-flex justify-content-between align-items-center mb-4">

                        <div>

                            <h2 class="mb-1">

                                Nuovo modulo

                            </h2>


                            <p class="text-muted mb-0">

                                Crea un nuovo modulo di formazione.

                            </p>

                        </div>


                        <a
                            href="<%= request.getContextPath()%>/page/admin/moduli/lista.jsp"
                            class="btn btn-outline-secondary"
                            >

                            <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-left-circle"></use></svg>
                            TORNA ALLA LISTA

                        </a>

                    </div>


                    <!-- FORM -->

                    <div class="card shadow-sm">

                        <div class="card-body p-4">


                            <form
                                action="<%= request.getContextPath()%>/ModuloServlet"
                                method="post"
                                >


                                <!-- ACTION -->

                                <input
                                    type="hidden"
                                    name="action"
                                    value="create"
                                    >


                                <!-- CORSO -->

                                <div class="mb-4">

                                    <label
                                        for="corsoId"
                                        class="form-label fw-semibold text-uppercase"
                                        >

                                        Corso

                                    </label>


                                    <select
                                        class="form-select text-uppercase"
                                        id="corsoId"
                                        name="corsoId"
                                        required
                                        >

                                        <option class="text-uppercase"
                                                value=""
                                                disabled
                                                <%= corsoIdParam == null
                                                        ? "selected"
                                                        : ""%>
                                                >

                                            Seleziona un corso

                                        </option>


                                        <%

                                            if (corsi != null
                                                    && !corsi.isEmpty()) {

                                                for (Corso corso : corsi) {

                                                    boolean selezionato
                                                            = corsoIdParam != null
                                                            && corsoIdParam.equals(
                                                                    String.valueOf(
                                                                            corso.getId()
                                                                    )
                                                            );

                                        %>


                                        <option class="text-uppercase"
                                                value="<%= corso.getId()%>"
                                                <%= selezionato ? "selected" : ""%>
                                                >

                                            <%= corso.getTitolo()%>

                                        </option>


                                        <%

                                            }

                                        } else {

                                        %>


                                        <option class="text-uppercase"
                                                value=""
                                                disabled
                                                >

                                            Nessun corso disponibile

                                        </option>


                                        <%                                            }

                                        %>

                                    </select>


                                    <div class="form-text">

                                        Seleziona il corso a cui appartiene
                                        questo modulo.

                                    </div>

                                </div>


                                <!-- TITOLO -->

                                <div class="mb-4">

                                    <label
                                        for="titolo"
                                        class="form-label fw-semibold text-uppercase"
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
                                        placeholder="Es. Sicurezza sul lavoro"
                                        >

                                </div>


                                <!-- DESCRIZIONE -->

                                <div class="mb-4">

                                    <label
                                        for="descrizione"
                                        class="form-label fw-semibold text-uppercase"
                                        >

                                        Descrizione

                                    </label>


                                    <textarea
                                        class="form-control text-uppercase"
                                        id="descrizione"
                                        name="descrizione"
                                        rows="5"
                                        placeholder="Inserisci una descrizione del modulo..."
                                        ></textarea>

                                </div>


                                <!-- AZIONI -->

                                <div class="d-flex justify-content-end gap-2">

                                    <!-- CREA -->

                                    <button
                                        type="submit"
                                        class="btn btn-outline-primary"
                                        <%= (corsi == null || corsi.isEmpty())
                                                ? "disabled"
                                                : ""%>
                                        >

                                        <svg class="icon icon-sm me-2 icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>
                                        CREA MODULO

                                    </button>

                                </div>


                            </form>

                        </div>

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

