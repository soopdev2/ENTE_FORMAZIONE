<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="entity.Video" %>
<%@ page import="entity.Modulo" %>

<%@ page import="service.VideoService" %>
<%@ page import="service.ModuloService" %>

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

    VideoService videoService = new VideoService();

    ModuloService moduloService = new ModuloService();

    String moduloIdParam = request.getParameter("moduloId");

    Long moduloId = null;

    if (moduloIdParam != null
            && !moduloIdParam.trim().isEmpty()) {

        try {

            moduloId = Long.valueOf(
                    moduloIdParam.trim()
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "ID modulo non valido"
            );

            return;
        }
    }

    List<Video> video;

    if (moduloId != null) {

        video = videoService.getVideoModulo(moduloId);

    } else {

        video = videoService.getAllVideos();

    }

    Modulo modulo = null;

    if (moduloId != null) {

        modulo = moduloService.getModulo(moduloId);

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
        <title>Gestione Video</title>


    </head>


    <body class="d-flex flex-column min-vh-100">



        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>



        <main class="container py-5 flex-grow-1">


            <!-- HEADER -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h2 class="mb-1">
                        Video
                    </h2>


                    <p class="text-muted mb-0">

                        <%                            if (moduloId != null) {

                                if (modulo != null) {
                        %>

                        Video del modulo:
                        <strong>
                            <%= modulo.getTitolo()%>
                        </strong>

                        <%
                        } else {
                        %>

                        Video appartenenti al modulo selezionato.

                        <%
                            }

                        } else {
                        %>

                        Gestisci tutti i video della formazione.

                        <%
                            }
                        %>

                    </p>

                </div>


                <!-- NUOVO VIDEO -->

                <!--div>

                <%
                    if (moduloId != null) {
                %>

                <a
                    href="<%= request.getContextPath()%>/page/admin/video/crea.jsp?moduloId=<%= moduloId%>"
                    class="btn btn-primary"
                    >
                    + Nuovo video
                </a>

                <%
                } else {
                %>

                <a
                    href="<%= request.getContextPath()%>/page/admin/video/crea.jsp?moduloId=<%= moduloId%>"
                    class="btn btn-primary"
                    >
                    + Nuovo video
                </a>

                <%
                    }
                %>

            </div-->

            </div>


            <!-- =================================================
                 TABELLA
            ================================================== -->

            <div class="card shadow-sm">

                <div class="card-body p-0">

                    <div class="table-responsive">

                        <table class="table table-hover table-responsive">


                            <thead>

                                <tr>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Ordine
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Titolo
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Durata
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Stato
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Modulo
                                    </th>

                                    <th class="bg-primary text-white text-uppercase text-center">
                                        Azioni
                                    </th>

                                </tr>

                            </thead>


                            <tbody>


                                <%
                                    if (video != null && !video.isEmpty()) {

                                        for (Video v : video) {
                                %>


                                <tr>


                                    <!-- ORDINE -->

                                    <td>

                                        <span class="badge bg-secondary">

                                            <%= v.getOrdine()%>

                                        </span>

                                    </td>


                                    <!-- TITOLO -->

                                    <td class="text-uppercase text-center">

                                        <span class="fw-semibold">
                                            <%= v.getTitolo()%>
                                        </span>


                                        <%
                                            if (v.getDescrizione() != null
                                                    && !v.getDescrizione().isBlank()) {
                                        %>

                                        <span class="text-muted small mt-1 fw-semibold">

                                            <%= v.getDescrizione()%>

                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>


                                    <!-- DURATA -->

                                    <td class="text-uppercase text-center">

                                        <%
                                            Long durata
                                                    = v.getDurataSecondi();

                                            if (durata == null) {
                                                durata = 0L;
                                            }

                                            long minuti
                                                    = durata / 60;

                                            long secondi
                                                    = durata % 60;
                                        %>

                                        <%= String.format(
                                                "%02d:%02d",
                                                minuti,
                                                secondi
                                        )%>




                                    </td>

                                    <!-- STATO -->

                                    <td class="text-uppercase text-center">

                                        <%
                                            if (Boolean.TRUE.equals(
                                                    v.getAttivo())) {
                                        %>

                                        <span class="badge bg-success">
                                            Attivo
                                        </span>

                                        <%
                                        } else {
                                        %>

                                        <span class="badge bg-secondary">
                                            Disattivato
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>

                                    <!-- MODULO -->

                                    <td class="text-uppercase text-center">

                                        <%
                                            if (v.getModulo() != null) {
                                        %>

                                        <span class="fw-semibold">
                                            <%= v.getModulo().getTitolo()%>
                                        </span>

                                        <%
                                        } else {
                                        %>

                                        <span class="text-muted fw-semibold">
                                            Nessun modulo
                                        </span>

                                        <%
                                            }
                                        %>

                                    </td>


                                    <!-- AZIONI -->

                                    <td class="text-uppercase text-center">

                                        <div class="btn-group">


                                            <!-- DETTAGLIO -->

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/dettaglio.jsp?id=<%= v.getId()%>"
                                                class="btn btn-xs btn-outline-primary"
                                                >
                                                <svg class="icon icon-xs icon-primary text-uppercase" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-burger"></use></svg>
                                            </a>


                                            <!-- MODIFICA -->

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/modifica.jsp?id=<%= v.getId()%>"
                                                class="btn btn-xs btn-outline-secondary"
                                                >
                                                <svg class="icon icon-xs icon-secondary text-uppercase" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                                            </a>


                                            <!-- STATISTICHE -->

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/statistiche.jsp?videoId=<%= v.getId()%>"
                                                class="btn btn-xs btn-outline-info"
                                                >
                                                <svg class="icon icon-xs icon-primary text-uppercase" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-box"></use></svg>
                                            </a>

                                            <!-- ATTIVA / DISATTIVA -->

                                            <%
                                                if (Boolean.TRUE.equals(
                                                        v.getAttivo())) {
                                            %>

                                            <a
                                                href="<%= request.getContextPath()%>/VideoServlet?action=deactivate&id=<%= v.getId()%>"
                                                class="btn btn-sm btn-outline-danger text-uppercase"
                                                onclick="return confirm('Disattivare questo video?');"
                                                >
                                                <svg class="icon icon-sm me-2 icon-danger text-uppercase" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-close-circle"></use></svg>
                                                Disattiva
                                            </a>

                                            <%
                                            } else {
                                            %>

                                            <a
                                                href="<%= request.getContextPath()%>/VideoServlet?action=activate&id=<%= v.getId()%>"
                                                class="btn btn-sm btn-outline-success text-uppercase"
                                                >
                                                <svg class="icon icon-sm me-2 icon-success text-uppercase" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-check-circle"></use></svg>
                                                Attiva
                                            </a>

                                            <%
                                                }
                                            %>


                                        </div>

                                    </td>

                                </tr>


                                <%
                                    }
                                } else {
                                %>


                                <!-- NESSUN VIDEO -->

                                <tr>

                                    <td
                                        colspan="6"
                                        class="text-center py-5"
                                        >

                                        <div class="text-muted">


                                            <h5 class="text-uppercase">
                                                Nessun video presente
                                            </h5>


                                            <p class="mb-3">
                                                Non sono ancora stati aggiunti video.
                                            </p>


                                            <%
                                                if (moduloId != null) {
                                            %>

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/crea.jsp?moduloId=<%= moduloId%>"
                                                class="btn btn-outline-primary"
                                                >
                                                <svg class="icon icon-sm me-2 icon-primary text-uppercase" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>
                                                CREA IL PRIMO VIDEO
                                            </a>

                                            <%
                                            } else {
                                            %>

                                            <a
                                                href="<%= request.getContextPath()%>/page/admin/video/crea.jsp"
                                                class="btn btn-outline-primary"
                                                >
                                                <svg class="icon icon-sm me-2 icon-primary text-uppercase" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>
                                                CREA IL PRIMO VIDEO
                                            </a>

                                            <%
                                                }
                                            %>


                                        </div>

                                    </td>

                                </tr>


                                <%
                                    }
                                %>


                            </tbody>

                        </table>

                    </div>

                </div>

            </div>


        </main>

        <div class="it-footer">
            <%@include file="../footer.jsp" %> 
        </div>           

        <!-- Bootstrap JS -->

        <script
            src="<%= request.getContextPath()%>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>


    </body>

</html>