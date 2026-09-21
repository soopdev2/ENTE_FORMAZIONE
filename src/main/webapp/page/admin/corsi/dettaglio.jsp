<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Corso" %>
<%@ page import="entity.Modulo" %>
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

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>
            <%= corso.getTitolo()%>
        </title>


        <link
            href="<%= request.getContextPath()%>/assets/bootstrap/assets/css/bootstrap.min.css"
            rel="stylesheet"
            >

    </head>


    <body class="bg-light">


        <%@ include file="../Header.jsp" %>
        <%@ include file="../navbar.jsp" %>


        <main class="container py-5">


            <!-- HEADER -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="mb-1">

                        <%= corso.getTitolo()%>

                    </h1>


                    <p class="text-muted mb-0">

                        Dettaglio del corso e gestione dei moduli.

                    </p>

                </div>


                <div class="d-flex gap-2">

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/lista.jsp"
                        class="btn btn-outline-secondary"
                        >
                        ← Corsi
                    </a>

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/utenti.jsp?corsoId=<%= corso.getId()%>"
                        class="btn btn-outline-success"
                        >
                        👥 Gestisci utenti
                    </a>

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/modifica.jsp?id=<%= corso.getId()%>"
                        class="btn btn-outline-primary"
                        >
                        Modifica
                    </a>

                </div>


            </div>


            <!-- INFORMAZIONI CORSO -->

            <div class="card shadow-sm mb-4">

                <div class="card-body p-4">


                    <div class="row">


                        <!-- TITOLO -->

                        <div class="col-md-8 mb-4">

                            <h6 class="text-muted mb-2">

                                Titolo

                            </h6>


                            <h3 class="mb-0">

                                <%= corso.getTitolo()%>

                            </h3>

                        </div>


                        <!-- STATO -->

                        <div class="col-md-4 mb-4">

                            <h6 class="text-muted mb-2">

                                Stato

                            </h6>


                            <%

                                if (Boolean.TRUE.equals(corso.getAttivo())) {

                            %>

                            <span class="badge bg-success">

                                Attivo

                            </span>

                            <%                            } else {

                            %>

                            <span class="badge bg-secondary">

                                Disattivato

                            </span>

                            <%                                }

                            %>

                        </div>


                        <!-- DESCRIZIONE -->

                        <div class="col-12">

                            <h6 class="text-muted mb-2">

                                Descrizione

                            </h6>


                            <%                                if (corso.getDescrizione() == null
                                        || corso.getDescrizione().trim().isEmpty()) {

                            %>

                            <p class="text-muted mb-0">

                                Nessuna descrizione disponibile.

                            </p>

                            <%                            } else {

                            %>

                            <p class="mb-0">

                                <%= corso.getDescrizione()%>

                            </p>

                            <%

                                }

                            %>

                        </div>

                    </div>

                </div>

            </div>


            <!-- MODULI -->

            <div class="card shadow-sm">


                <div class="card-header bg-white">

                    <div class="d-flex justify-content-between align-items-center">


                        <div>

                            <h2 class="h5 mb-1">

                                Moduli del corso

                            </h2>


                            <p class="text-muted mb-0">

                                Gestisci i moduli appartenenti a questo corso.

                            </p>

                        </div>


                        <a
                            href="<%= request.getContextPath()%>/page/admin/moduli/crea.jsp?corsoId=<%= corso.getId()%>"
                            class="btn btn-primary"
                            >

                            + Nuovo modulo

                        </a>

                    </div>

                </div>


                <div class="card-body p-0">


                    <div class="table-responsive">

                        <table class="table table-hover align-middle mb-0">


                            <thead class="table-light">

                                <tr>

                                    <th>
                                        ID
                                    </th>

                                    <th>
                                        Titolo
                                    </th>

                                    <th>
                                        Descrizione
                                    </th>

                                    <th>
                                        Video
                                    </th>

                                    <th>
                                        Stato
                                    </th>

                                    <th class="text-end">
                                        Azioni
                                    </th>

                                </tr>

                            </thead>


                            <tbody>

                                <%

                                    if (corso.getModuli() == null
                                            || corso.getModuli().isEmpty()) {

                                %>

                                <tr>

                                    <td
                                        colspan="6"
                                        class="text-center py-5"
                                        >

                                        <div class="text-muted">

                                            Nessun modulo presente in questo corso.

                                        </div>


                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/moduli/crea.jsp?corsoId=<%= corso.getId()%>"
                                            class="btn btn-sm btn-primary mt-3"
                                            >

                                            Crea il primo modulo

                                        </a>

                                    </td>

                                </tr>

                                <%

                                } else {

                                    for (Modulo modulo : corso.getModuli()) {

                                %>

                                <tr>


                                    <!-- ID -->

                                    <td>

                                        <%= modulo.getId()%>

                                    </td>


                                    <!-- TITOLO -->

                                    <td>

                                        <strong>

                                            <%= modulo.getTitolo()%>

                                        </strong>

                                    </td>


                                    <!-- DESCRIZIONE -->

                                    <td>

                                        <%

                                            String descrizione
                                                    = modulo.getDescrizione();

                                            if (descrizione == null
                                                    || descrizione.trim().isEmpty()) {

                                        %>

                                        <span class="text-muted">

                                            Nessuna descrizione

                                        </span>

                                        <%                                        } else {

                                            String testo = descrizione;

                                            if (testo.length() > 70) {

                                                testo
                                                        = testo.substring(0, 70)
                                                        + "...";

                                            }

                                        %>

                                        <%= testo%>

                                        <%

                                            }

                                        %>

                                    </td>


                                    <!-- VIDEO -->

                                    <td>

                                        <span class="badge bg-primary">
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

                                            <%= numeroVideo %>
                                        </span>


                                    </td>


                                    <!-- STATO -->

                                    <td>

                                        <%

                                            if (Boolean.TRUE.equals(modulo.getAttivo())) {

                                        %>

                                        <span class="badge bg-success">

                                            Attivo

                                        </span>

                                        <%                                        } else {

                                        %>

                                        <span class="badge bg-secondary">

                                            Disattivato

                                        </span>

                                        <%                                            }

                                        %>

                                    </td>


                                    <!-- AZIONI -->

                                    <td class="text-end">


                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/moduli/dettaglio.jsp?id=<%= modulo.getId()%>"
                                            class="btn btn-sm btn-outline-primary"
                                            >

                                            Dettaglio

                                        </a>


                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/moduli/modifica.jsp?id=<%= modulo.getId()%>"
                                            class="btn btn-sm btn-outline-secondary"
                                            >

                                            Modifica

                                        </a>

                                    </td>


                                </tr>

                                <%

                                        }

                                    }

                                %>

                            </tbody>


                        </table>

                    </div>

                </div>

            </div>


        </main>

        <%@include file="../footer.jsp" %>


        <script
            src="<%= request.getContextPath()%>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>


    </body>

</html>