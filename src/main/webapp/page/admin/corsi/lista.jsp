<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Corso" %>
<%@ page import="service.CorsoService" %>
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

    String pageName =
            uri.substring(
                    uri.lastIndexOf("/") + 1
            );

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

    CorsoService corsoService = new CorsoService();

    List<Corso> corsi = corsoService.getAllCorsi();

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
            Gestione Corsi
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
                        Corsi
                    </h1>

                    <p class="text-muted mb-0">
                        Gestisci i corsi di formazione.
                    </p>

                </div>


                <a
                    href="<%= request.getContextPath()%>/page/admin/corsi/crea.jsp"
                    class="btn btn-primary"
                    >

                    + Nuovo corso

                </a>

            </div>


            <!-- TABELLA -->

            <div class="card shadow-sm">

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
                                        Moduli
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

                                    if (corsi == null || corsi.isEmpty()) {

                                %>

                                <tr>

                                    <td
                                        colspan="6"
                                        class="text-center py-5 text-muted"
                                        >

                                        Nessun corso presente.

                                    </td>

                                </tr>

                                <%

                                    } else {

                                        for (Corso corso : corsi) {

                                %>

                                <tr>


                                    <!-- ID -->

                                    <td>

                                        <%= corso.getId() %>

                                    </td>


                                    <!-- TITOLO -->

                                    <td>

                                        <strong>

                                            <%= corso.getTitolo() %>

                                        </strong>

                                    </td>


                                    <!-- DESCRIZIONE -->

                                    <td>

                                        <%

                                            String descrizione =
                                                    corso.getDescrizione();

                                            if (descrizione == null
                                                    || descrizione.trim().isEmpty()) {

                                        %>

                                        <span class="text-muted">

                                            Nessuna descrizione

                                        </span>

                                        <%

                                            } else {

                                                String testo = descrizione;

                                                if (testo.length() > 80) {

                                                    testo =
                                                            testo.substring(0, 80)
                                                            + "...";

                                                }

                                        %>

                                        <%= testo %>

                                        <%

                                            }

                                        %>

                                    </td>


                                    <!-- MODULI -->

                                    <td>

                                        <span class="badge bg-primary">

                                            <%= corso.getModuli() != null
                                                    ? corso.getModuli().size()
                                                    : 0 %>

                                        </span>

                                    </td>


                                    <!-- STATO -->

                                    <td>

                                        <%

                                            if (Boolean.TRUE.equals(corso.getAttivo())) {

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


                                    <!-- AZIONI -->

                                    <td class="text-end">


                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/corsi/dettaglio.jsp?id=<%= corso.getId() %>"
                                            class="btn btn-sm btn-outline-primary"
                                            >

                                            Dettaglio

                                        </a>


                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/corsi/modifica.jsp?id=<%= corso.getId() %>"
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