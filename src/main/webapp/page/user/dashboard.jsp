<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.UserCorso" %>
<%@ page import="service.UserCorsoService" %>

<%@ page import="java.util.List" %>


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



    UserCorsoService userCorsoService =
            new UserCorsoService();

    List<UserCorso> corsiUtente =
            userCorsoService.getCorsiUtente(
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

    <title>Dashboard</title>

</head>


<body class="d-flex flex-column min-vh-100">


    <!-- NAVBAR -->

    <%@ include file="../admin/Header.jsp" %>
    <%@ include file="../user/navbar.jsp" %>


    <main class="container py-5 flex-grow-1">


        <div class="mb-5">

            <h1 class="h3 mb-2">

                Benvenuto

                <%
                    Object nome =
                            session.getAttribute("nome");

                    if (nome != null) {
                %>

                    <%= nome %>

                <%
                    }
                %>

            </h1>


            <p class="text-muted mb-0">

                Qui puoi visualizzare i tuoi corsi
                e continuare il tuo percorso formativo.

            </p>

        </div>


        <div class="mb-4">

            <h2 class="h4 mb-1">

                I miei corsi

            </h2>


            <p class="text-muted">

                Corsi di formazione a te assegnati.

            </p>

        </div>


        <%
            if (corsiUtente == null || corsiUtente.isEmpty()) {
        %>


            <!-- NESSUN CORSO -->

            <div class="card shadow-sm">

                <div class="card-body text-center py-5">

                    <div class="mb-3">

                        <span class="badge bg-secondary">

                            Formazione

                        </span>

                    </div>


                    <h3 class="h5">

                        Nessun corso assegnato

                    </h3>


                    <p class="text-muted mb-0">

                        Al momento non hai nessun corso
                        di formazione assegnato.

                    </p>

                </div>

            </div>


        <%
            } else {
        %>


            <!-- CORSI -->

            <div class="row g-4">

                <%
                    for (UserCorso userCorso : corsiUtente) {

                        if (userCorso == null
                                || userCorso.getCorso() == null) {

                            continue;
                        }

                        Double percentuale =
                                userCorso.getPercentuale();

                        if (percentuale == null) {
                            percentuale = 0.0;
                        }

                        String stato =
                                userCorso.getStato() != null
                                ? userCorso.getStato().name()
                                : "ASSEGNATO";


                        String badgeClass = "bg-secondary";
                        String statoTesto = "Assegnato";


                        if ("IN_CORSO".equals(stato)) {

                            badgeClass =
                                    "bg-warning text-dark";

                            statoTesto =
                                    "In corso";

                        } else if ("COMPLETATO".equals(stato)) {

                            badgeClass =
                                    "bg-success";

                            statoTesto =
                                    "Completato";
                        }
                %>


                    <div class="col-md-6 col-lg-4">


                        <div class="card shadow-sm h-100">


                            <div class="card-body p-4">


                                <!-- STATO -->

                                <div class="mb-3">

                                    <span
                                        class="badge <%= badgeClass %>"
                                    >

                                        <%= statoTesto %>

                                    </span>

                                </div>


                                <!-- TITOLO -->

                                <h3 class="h5">

                                    <%= userCorso
                                            .getCorso()
                                            .getTitolo() %>

                                </h3>


                                <!-- DESCRIZIONE -->

                                <%
                                    String descrizione =
                                            userCorso
                                                .getCorso()
                                                .getDescrizione();

                                    if (descrizione != null
                                            && !descrizione
                                                .trim()
                                                .isEmpty()) {

                                        if (descrizione.length() > 120) {

                                            descrizione =
                                                descrizione
                                                    .substring(0, 120)
                                                    + "...";
                                        }
                                %>

                                    <p class="text-muted">

                                        <%= descrizione %>

                                    </p>

                                <%
                                    } else {
                                %>

                                    <p class="text-muted">

                                        Nessuna descrizione disponibile.

                                    </p>

                                <%
                                    }
                                %>


                                <!-- PROGRESSO -->

                                <div class="mb-3">

                                    <div
                                        class="d-flex justify-content-between
                                               align-items-center mb-1"
                                    >

                                        <small class="text-muted">

                                            Completamento

                                        </small>

                                        <small class="fw-bold">

                                            <%= String.format(
                                                    "%.0f",
                                                    percentuale
                                               ) %>%

                                        </small>

                                    </div>


                                    <div class="progress">

                                        <div
                                            class="progress-bar"
                                            role="progressbar"
                                            style="width: <%= percentuale %>%"
                                            aria-valuenow="<%= percentuale %>"
                                            aria-valuemin="0"
                                            aria-valuemax="100"
                                        ></div>

                                    </div>

                                </div>


                                <!-- AZIONE -->

                                <a
                                    href="<%= request.getContextPath() %>/page/user/moduli.jsp?corsoId=<%= userCorso.getCorso().getId() %>"
                                    class="btn btn-primary w-100"
                                >

                                    <%
                                        if ("COMPLETATO".equals(stato)) {
                                    %>

                                        Visualizza corso →

                                    <%
                                        } else if ("IN_CORSO".equals(stato)) {
                                    %>

                                        Continua corso →

                                    <%
                                        } else {
                                    %>

                                        Inizia corso →

                                    <%
                                        }
                                    %>

                                </a>


                            </div>

                        </div>


                    </div>


                <%
                    }
                %>

            </div>


        <%
            }
        %>


    </main>


    <!-- Bootstrap JS -->

    <script
        src="<%= request.getContextPath() %>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js"
    ></script>


</body>

</html>
