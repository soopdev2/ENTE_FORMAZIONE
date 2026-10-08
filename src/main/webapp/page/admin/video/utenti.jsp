<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Video" %>
<%@ page import="entity.UserVideo" %>
<%@ page import="java.util.List" %>
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

    Video video = (Video) request.getAttribute("video");

    if (video == null) {
        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Video non trovato"
        );
        return;
    }

    List<UserVideo> utenti
            = (List<UserVideo>) request.getAttribute("utenti");

    if (utenti == null) {
        utenti = new java.util.ArrayList<>();
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

        <title>Utenti - <%= video.getTitolo()%></title>

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
                        Utenti del video
                    </h1>

                    <p class="text-muted mb-0">
                        <%= video.getTitolo()%>
                    </p>

                </div>

                <a
                    href="<%= request.getContextPath()%>/AdminVideoStatsServlet?action=stats&videoId=<%= video.getId()%>"
                    class="btn btn-outline-secondary"
                    >
                    ← Torna alle statistiche
                </a>

            </div>


            <!-- INFORMAZIONI VIDEO -->

            <div class="card shadow-sm mb-4">

                <div class="card-body">

                    <div class="row">

                        <div class="col-md-4">

                            <small class="text-muted">
                                Video
                            </small>

                            <div class="fw-bold">
                                <%= video.getTitolo()%>
                            </div>

                        </div>


                        <div class="col-md-4">

                            <small class="text-muted">
                                Modulo
                            </small>

                            <div class="fw-bold">
                                <%= video.getModulo().getTitolo()%>
                            </div>

                        </div>


                        <div class="col-md-4">

                            <small class="text-muted">
                                Utenti assegnati
                            </small>

                            <div class="fw-bold">
                                <%= utenti.size()%>
                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- TABELLA UTENTI -->

            <div class="card shadow-sm">

                <div class="card-header">

                    <h2 class="h5 mb-0">
                        Stato utenti
                    </h2>

                </div>

                <div class="card-body p-0">

                    <%
                        if (utenti.isEmpty()) {
                    %>

                    <div class="p-4 text-center">

                        <h3 class="h5">
                            Nessun utente
                        </h3>

                        <p class="text-muted mb-0">
                            Nessun utente è stato ancora associato a questo video.
                        </p>

                    </div>

                    <%
                    } else {
                    %>

                    <div class="table-responsive">

                        <table class="table table-hover align-middle mb-0">

                            <thead class="table-light">

                                <tr>

                                    <th>
                                        Utente
                                    </th>

                                    <th>
                                        Username
                                    </th>

                                    <th>
                                        Stato
                                    </th>

                                    <th>
                                        Progresso
                                    </th>

                                    <th>
                                        Secondi guardati
                                    </th>

                                    <th>
                                        Ultima visualizzazione
                                    </th>

                                </tr>

                            </thead>

                            <tbody>

                                <%
                                    for (UserVideo userVideo : utenti) {
                                %>

                                <tr>

                                    <!-- UTENTE -->

                                    <td>

                                        <%
                                            if (userVideo.getUser() != null) {
                                        %>

                                        <strong>
                                            <%= userVideo.getUser().getNome()%>
                                            <%= userVideo.getUser().getCognome()%>
                                        </strong>

                                        <%
                                        } else {
                                        %>

                                        <span class="text-muted">
                                            Utente non disponibile
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>


                                    <!-- USERNAME -->

                                    <td>

                                        <%
                                            if (userVideo.getUser() != null) {
                                        %>

                                        <%= userVideo.getUser().getUsername()%>

                                        <%
                                        } else {
                                        %>

                                        <span class="text-muted">
                                            -
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>


                                    <!-- STATO -->

                                    <td>

                                        <%
                                            String stato
                                                    = userVideo.getStato() != null
                                                    ? userVideo.getStato().toString()
                                                    : "DA_GUARDARE";

                                            if ("COMPLETATO".equals(stato)) {
                                        %>

                                        <span class="badge bg-success">
                                            Completato
                                        </span>

                                        <%
                                        } else if ("IN_CORSO".equals(stato)) {
                                        %>

                                        <span class="badge bg-warning text-dark">
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

                                    </td>


                                    <!-- PROGRESSO -->

                                    <td style="min-width: 180px;">

                                        <%
                                            double percentuale
                                                    = userVideo.getPercentuale();

                                            if (percentuale == 0.0) {
                                                percentuale = 0L;
                                            }
                                        %>

                                        <div class="progress">

                                            <div
                                                class="progress-bar"
                                                role="progressbar"
                                                style="width: <%= percentuale%>%"
                                                aria-valuenow="<%= percentuale%>"
                                                aria-valuemin="0"
                                                aria-valuemax="100"
                                                >
                                                <%= percentuale%>%
                                            </div>

                                        </div>

                                    </td>


                                    <!-- SECONDI GUARDATI -->

                                    <td>

                                        <%
                                            Long secondi
                                                    = userVideo.getSecondiGuardati();

                                            if (secondi == null) {
                                                secondi = 0L;
                                            }

                                            long minutiGuardati
                                                    = secondi / 60;

                                            long secondiRimanenti
                                                    = secondi % 60;
                                        %>

                                        <%= String.format(
                                                "%02d:%02d",
                                                minutiGuardati,
                                                secondiRimanenti
                                        )%>

                                    </td>


                                    <!-- ULTIMA VISUALIZZAZIONE -->

                                    <td>

                                        <%
                                            if (userVideo.getUltimaVisualizzazione() != null) {
                                        %>

                                        <%= userVideo.getUltimaVisualizzazione()%>

                                        <%
                                        } else {
                                        %>

                                        <span class="text-muted">
                                            Mai visualizzato
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                    <%
                        }
                    %>

                </div>

            </div>

        </main>

        <div class="it-footer">
            <%@include file="../footer.jsp" %> 
        </div>           



        <script src="../../../assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js"></script>

    </body>

</html>