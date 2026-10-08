<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Corso" %>
<%@ page import="service.CorsoService" %>
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

    if (idParam == null || idParam.trim().isEmpty()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID corso mancante"
        );

        return;
    }

    Long corsoId;

    try {

        corsoId = Long.valueOf(idParam);

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID corso non valido"
        );

        return;
    }

    CorsoService corsoService = new CorsoService();

    Corso corso = corsoService.getCorso(corsoId);

    if (corso == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Corso non trovato"
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
            Modifica Corso
        </title>


    </head>


    <body class="d-flex flex-column min-vh-100">



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

                                Modifica corso

                            </h2>


                            <p class="text-muted mb-0">

                                Modifica i dati del corso.

                            </p>

                        </div>


                        <a
                            href="<%= request.getContextPath()%>/page/admin/corsi/lista.jsp"
                            class="btn btn-outline-secondary"
                            >
                            <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="<%= request.getContextPath()%>/Bootstrap2024/assets/svg/sprites.svg#it-arrow-left-circle"></use></svg>
                            TORNA ALLA LISTA

                        </a>

                    </div>


                    <!-- FORM -->

                    <div class="card shadow-sm">

                        <div class="card-body p-4">


                            <form
                                action="<%= request.getContextPath()%>/CorsoServlet"
                                method="post"
                                >


                                <!-- ACTION -->

                                <input
                                    type="hidden"
                                    name="action"
                                    value="update"
                                    >


                                <!-- ID -->

                                <input
                                    type="hidden"
                                    name="id"
                                    value="<%= corso.getId()%>"
                                    >


                                <!-- ID VISIBILE -->

                                <div class="mb-4">

                                    <label
                                        class="form-label fw-semibold text-uppercase"
                                        >

                                        ID

                                    </label>


                                    <input
                                        type="text"
                                        class="form-control text-uppercase"
                                        value="<%= corso.getId()%>"
                                        disabled
                                        >

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
                                        value="<%= corso.getTitolo()%>"
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
                                        rows="6"
                                        maxlength="1000"
                                        ><%= corso.getDescrizione() != null
                                                ? corso.getDescrizione()
                                                : ""%></textarea>

                                </div>


                                <!-- STATO -->

                                <div class="mb-4">

                                    <label
                                        class="form-label fw-semibold text-uppercase"
                                        >

                                        Stato

                                    </label>


                                    <div>

                                        <%

                                            if (Boolean.TRUE.equals(corso.getAttivo())) {

                                        %>

                                        <span class="badge bg-success text-uppercase">

                                            Attivo

                                        </span>

                                        <%                                        } else {

                                        %>

                                        <span class="badge bg-secondary text-uppercase">

                                            Disattivato

                                        </span>

                                        <%                                            }

                                        %>

                                    </div>

                                </div>


                                <!-- AZIONI -->

                                <div class="d-flex justify-content-end gap-2 mt-4">


                                    <!-- SALVA -->

                                    <button
                                        type="submit"
                                        class="btn btn-outline-success"
                                        >

                                        <svg class="icon icon-sm me-2 icon-success" aria-hidden="true"><use href="<%= request.getContextPath()%>/Bootstrap2024/assets/svg/sprites.svg#it-check-circle"></use></svg>

                                        SALVA MODIFICHE

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
            src="<%= request.getContextPath()%>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>


    </body>

</html>