<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Corso" %>
<%@ page import="service.CorsoService" %>
<%@ page import="java.util.List" %>

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

    CorsoService corsoService = new CorsoService();

    List<Corso> corsi = corsoService.getAllCorsi();

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
            Gestione Corsi
        </title>

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
                        Corsi
                    </h2>

                    <p class="text-muted mb-0">
                        Gestisci i corsi di formazione.
                    </p>

                </div>


                <a
                    href="<%= request.getContextPath()%>/page/admin/corsi/crea.jsp"
                    class="btn btn-outline-primary"
                    >

                    AGGIUNGI 
                    <svg class="icon icon-sm icon-primary" aria-hidden="true" style="margin-left: 5px;"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>

                </a>

            </div>


            <!-- TABELLA -->

            <div class="card-wrapper">

                <div class="card">

                    <div class="card-body p-0">

                        <div class="table-responsive">

                            <table class="table  table-hover align-middle mb-0">

                                <thead>

                                    <tr>

                                        <th scope="col"
                                            class="bg-primary text-white text-center text-uppercase">
                                            ID
                                        </th>

                                        <th scope="col"
                                            class="bg-primary text-white text-center text-uppercase">
                                            Titolo
                                        </th>

                                        <th scope="col"
                                            class="bg-primary text-white text-center text-uppercase">
                                            Descrizione
                                        </th>

                                        <th scope="col"
                                            class="bg-primary text-white text-center text-uppercase">
                                            Moduli
                                        </th>

                                        <th scope="col"
                                            class="bg-primary text-white text-center text-uppercase">
                                            Stato
                                        </th>

                                        <th scope="col"
                                            class="bg-primary text-white text-center text-uppercase">
                                            Azioni
                                        </th>

                                    </tr>

                                </thead>


                                <tbody>

                                    <%

                                        if (corsi == null || corsi.isEmpty()) {

                                    %>

                                    <tr>

                                        <td colspan="6"
                                            class="text-center py-5">

                                            <div class="d-flex flex-column align-items-center">

                                                <svg class="icon icon-lg icon-secondary mb-3"
                                                     aria-hidden="true">

                                                <use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-info-circle"></use>

                                                </svg>

                                                <span class="text-secondary">
                                                    Nessun corso presente.
                                                </span>

                                            </div>

                                        </td>

                                    </tr>

                                    <%                        } else {

                                        for (Corso corso : corsi) {

                                    %>

                                    <tr>

                                        <!-- ID -->

                                        <td class="text-center">

                                            <span class="fw-semibold">
                                                <%= corso.getId()%>
                                            </span>

                                        </td>


                                        <!-- TITOLO -->

                                        <td class="text-center">

                                            <span class="fw-semibold text-uppercase">
                                                <%= corso.getTitolo()%>
                                            </span>

                                        </td>


                                        <!-- DESCRIZIONE -->

                                        <td class="text-center text-uppercase">

                                            <%

                                                String descrizione
                                                        = corso.getDescrizione();

                                                if (descrizione == null
                                                        || descrizione.trim().isEmpty()) {

                                            %>

                                            <span class="text-secondary text-uppercase">
                                                Nessuna descrizione
                                            </span>

                                            <%                                } else {

                                                String testo = descrizione;

                                                if (testo.length() > 80) {

                                                    testo
                                                            = testo.substring(0, 80)
                                                            + "...";

                                                }

                                            %>

                                            <span class="text-uppercase">
                                                <%= testo%>
                                            </span>

                                            <%

                                                }

                                            %>

                                        </td>


                                        <!-- MODULI -->

                                        <td class="text-center">

                                            <span class="badge text-black">

                                                <%= corso.getModuli() != null
                                                        ? corso.getModuli().size()
                                                        : 0%>

                                            </span>

                                        </td>


                                        <!-- STATO -->

                                        <td class="text-center">

                                            <%

                                                if (Boolean.TRUE.equals(corso.getAttivo())) {

                                            %>

                                            <span class="badge bg-success text-uppercase">

                                                Attivo

                                            </span>

                                            <%                                } else {

                                            %>

                                            <span class="badge bg-secondary text-uppercase">

                                                Disattivato

                                            </span>

                                            <%                                    }

                                            %>

                                        </td>


                                        <!-- AZIONI -->

                                        <td class="text-center">

                                            <div class="d-flex justify-content-center align-items-center gap-2 flex-wrap">

                                                <!-- DETTAGLIO -->

                                                <a href="<%= request.getContextPath()%>/page/admin/corsi/dettaglio.jsp?id=<%= corso.getId()%>"
                                                   class="btn btn-outline-primary btn-xs d-inline-flex align-items-center">

                                                    <svg class="icon icon-xs icon-primary"
                                                         aria-hidden="true">

                                                    <use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-burger"></use>

                                                    </svg>
                                                </a>


                                                <!-- MODIFICA -->

                                                <a href="<%= request.getContextPath()%>/page/admin/corsi/modifica.jsp?id=<%= corso.getId()%>"
                                                   class="btn btn-outline-secondary btn-xs d-inline-flex align-items-center">

                                                    <svg class="icon icon-xs icon-secondary"
                                                         aria-hidden="true">

                                                    <use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use>

                                                    </svg>


                                                </a>

                                            </div>

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