<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="entity.Corso" %>
<%@ page import="entity.Modulo" %>
<%@ page import="entity.UserCorso" %>

<%@ page import="service.CorsoService" %>
<%@ page import="service.ModuloService" %>
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

    String corsoIdParam
            = request.getParameter(
                    "corsoId"
            );

    if (corsoIdParam == null
            || corsoIdParam.isBlank()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Parametro corsoId mancante."
        );

        return;
    }

    Long corsoId;

    try {

        corsoId
                = Long.parseLong(
                        corsoIdParam
                );

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "corsoId non valido."
        );

        return;
    }

    UserCorsoService userCorsoService
            = new UserCorsoService();

    CorsoService corsoService
            = new CorsoService();

    ModuloService moduloService
            = new ModuloService();

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

    Corso corso
            = corsoService.getCorso(
                    corsoId
            );

    if (corso == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Corso non trovato."
        );

        return;
    }

    List<Modulo> moduli
            = moduloService.getModuliAttiviCorso(
                    corsoId
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
            Moduli - <%= corso.getTitolo()%>
        </title>


    </head>


    <body class="d-flex flex-column min-vh-100">


        <!-- NAVBAR -->

        <%@ include file="../admin/Header.jsp" %>
        <%@ include file="navbar.jsp" %>


        <main class="container py-5 flex-grow-1">



            <div class="d-flex justify-content-between
                 align-items-center mb-5">


                <div>

                    <h1 class="h3 mb-2">

                        <%= corso.getTitolo()%>

                    </h1>


                    <p class="text-muted mb-0">

                        Seleziona un modulo per visualizzare
                        i video del percorso formativo.

                    </p>

                </div>


                <div>

                    <a
                        href="<%= request.getContextPath()%>/page/user/dashboard.jsp"
                        class="btn btn-outline-secondary"
                        >

                        ← I miei corsi

                    </a>

                </div>


            </div>


            <%
                if (corso.getDescrizione() != null
                        && !corso.getDescrizione()
                                .isBlank()) {
            %>

            <div class="card shadow-sm mb-4">

                <div class="card-body">

                    <p class="mb-0 text-muted">

                        <%= corso.getDescrizione()%>

                    </p>

                </div>

            </div>

            <%
                }
            %>


            <div class="row g-4">


                <%
                    if (moduli == null
                            || moduli.isEmpty()) {
                %>


                <!-- NESSUN MODULO -->

                <div class="col-12">

                    <div class="card shadow-sm">

                        <div class="card-body
                             text-center py-5">


                            <h2 class="h5">

                                Nessun modulo disponibile

                            </h2>


                            <p class="text-muted mb-0">

                                Al momento questo corso
                                non contiene moduli.

                            </p>


                        </div>

                    </div>

                </div>


                <%
                } else {

                    for (Modulo modulo : moduli) {
                %>



                <div class="col-md-6 col-xl-4">


                    <div class="card shadow-sm h-100">


                        <div class="card-body
                             d-flex flex-column p-4">


                            <!-- STATO -->

                            <div class="mb-3">

                                <%
                                    if (Boolean.TRUE.equals(
                                            modulo.getAttivo())) {
                                %>

                                <span class="badge bg-success">

                                    Attivo

                                </span>

                                <%
                                } else {
                                %>

                                <span class="badge bg-secondary">

                                    Non disponibile

                                </span>

                                <%
                                    }
                                %>

                            </div>


                            <!-- TITOLO -->

                            <h2 class="h5 mb-3">

                                <%= modulo.getTitolo()%>

                            </h2>


                            <!-- DESCRIZIONE -->

                            <div class="text-muted mb-4">

                                <%
                                    if (modulo.getDescrizione() != null
                                            && !modulo.getDescrizione()
                                                    .isBlank()) {
                                %>

                                <%= modulo.getDescrizione()%>

                                <%
                                } else {
                                %>

                                Nessuna descrizione disponibile.

                                <%
                                    }
                                %>

                            </div>


                            <!-- NUMERO VIDEO -->

                            <div class="small text-muted mb-3">

                                Video disponibili:

                                <strong>

                                    <%
                                        int numeroVideo = 0;

                                        try {
                                            if (modulo.getVideo() != null) {
                                                numeroVideo = modulo.getVideo().size();
                                            }
                                        } catch (org.hibernate.LazyInitializationException e) {
                                            numeroVideo = 0;
                                        }
                                    %>

                                    <%= numeroVideo%>


                                </strong>

                            </div>


                            <!-- AZIONE -->

                            <div class="mt-auto">


                                <%
                                    if (Boolean.TRUE.equals(
                                            modulo.getAttivo())) {
                                %>

                                <a
                                    href="<%= request.getContextPath()%>/page/user/video-list.jsp?moduloId=<%= modulo.getId()%>"
                                    class="btn btn-primary w-100"
                                    >

                                    Visualizza video →

                                </a>

                                <%
                                } else {
                                %>

                                <button
                                    type="button"
                                    class="btn btn-secondary w-100"
                                    disabled
                                    >

                                    Modulo non disponibile

                                </button>

                                <%
                                    }
                                %>


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
