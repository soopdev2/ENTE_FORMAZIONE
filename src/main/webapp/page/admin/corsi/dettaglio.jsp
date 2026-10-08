<%@page import="java.util.List"%>
<%@page import="service.ModuloService"%>
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

    ModuloService moduloService = new ModuloService();

    List<Modulo> moduli = moduloService.getModuliConVideo(corsoId);

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
            <%= corso.getTitolo()%>
        </title>

    </head>


    <body class="d-flex flex-column min-vh-100">


        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>


        <main class="container py-5 flex-grow-1">


            <!-- HEADER -->

            <div class="d-flex justify-content-between align-items-center mb-4">


                <div class="d-flex gap-2">

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/lista.jsp"
                        class="btn btn-outline-secondary"
                        >
                        <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-left-circle"></use></svg>
                        CORSI
                    </a>
                </div>

                <div class="justify-content-end">

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/utenti.jsp?corsoId=<%= corso.getId()%>"
                        class="btn btn-outline-success"
                        >
                        <svg class="icon icon-sm me-2 icon-success" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-user"></use></svg>
                        GESTISCI UTENTI
                    </a>

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/modifica.jsp?id=<%= corso.getId()%>"
                        class="btn btn-outline-primary"
                        >
                        <svg class="icon icon-sm me-2 icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                        MODIFICA
                    </a>
                </div>

            </div>


            <!-- INFORMAZIONI CORSO -->

            <div class="card shadow-sm mb-4">

                <div class="card-body p-4">


                    <div class="row">


                        <!-- TITOLO -->

                        <div class="col-md-8 mb-4">

                            <h6 class="text-muted mb-2 text-uppercase">

                                Titolo

                            </h6>


                            <h5 class="mb-0 text-uppercase">

                                <%= corso.getTitolo()%>

                            </h5>

                        </div>


                        <!-- STATO -->

                        <div class="col-md-4 mb-4">

                            <h6 class="text-muted mb-2 text-uppercase">

                                Stato

                            </h6>


                            <%

                                if (Boolean.TRUE.equals(corso.getAttivo())) {

                            %>

                            <span class="badge bg-success text-uppercase">

                                Attivo

                            </span>

                            <%                            } else {

                            %>

                            <span class="badge bg-secondary text-uppercase">

                                Disattivato

                            </span>

                            <%                                }

                            %>

                        </div>


                        <!-- DESCRIZIONE -->

                        <div class="col-12">

                            <h6 class="text-muted mb-2 text-uppercase">

                                Descrizione

                            </h6>


                            <%                                if (corso.getDescrizione() == null
                                        || corso.getDescrizione().trim().isEmpty()) {

                            %>

                            <p class="text-muted mb-0 text-uppercase">

                                Nessuna descrizione disponibile.

                            </p>

                            <%                            } else {

                            %>

                            <p class="mb-0 text-uppercase">

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

                            <h2 class="text-black">

                                Moduli del corso

                            </h2>


                            <p class="text-muted mb-0">

                                Gestisci i moduli appartenenti a questo corso.

                            </p>

                        </div>


                        <a
                            href="<%= request.getContextPath()%>/page/admin/moduli/crea.jsp?corsoId=<%= corso.getId()%>"
                            class="btn btn-outline-primary"
                            >

                            AGGIUNGI 
                            <svg class="icon icon-sm icon-primary" aria-hidden="true" style="margin-left: 5px"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>

                        </a>

                    </div>

                </div>


                <div class="card-body p-0">


                    <div class="table-responsive">

                        <table class="table table-hover table-responsive">


                            <thead>

                                <tr>

                                    <th class="bg-primary text-center text-white text-uppercase">
                                        ID
                                    </th>

                                    <th class="bg-primary text-center  text-white text-uppercase">
                                        Titolo
                                    </th>

                                    <th class="bg-primary text-center  text-white text-uppercase">
                                        Descrizione
                                    </th>

                                    <th class="bg-primary text-center  text-white text-uppercase">
                                        Video
                                    </th>

                                    <th class="bg-primary text-center  text-white text-uppercase">
                                        Stato
                                    </th>

                                    <th class="bg-primary text-center  text-white text-uppercase">
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
                                        class="py-5"
                                        >

                                        <div class="text-muted text-uppercase">

                                            Nessun modulo presente in questo corso.

                                        </div>


                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/moduli/crea.jsp?corsoId=<%= corso.getId()%>"
                                            class="btn btn-sm btn-outline-primary mt-3"
                                            >

                                            Crea il primo modulo

                                        </a>

                                    </td>

                                </tr>

                                <%

                                } else {

                                    for (Modulo modulo : moduli) {

                                %>

                                <tr>


                                    <!-- ID -->

                                    <td class="text-center text-uppercase"> 

                                        <%= modulo.getId()%>

                                    </td>


                                    <!-- TITOLO -->

                                    <td class="text-center text-uppercase">

                                        <strong>

                                            <%= modulo.getTitolo()%>

                                        </strong>

                                    </td>


                                    <!-- DESCRIZIONE -->

                                    <td class="text-center text-uppercase">

                                        <%

                                            String descrizione
                                                    = modulo.getDescrizione();

                                            if (descrizione == null
                                                    || descrizione.trim().isEmpty()) {

                                        %>

                                        <span class="text-muted text-uppercase">

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

                                    <td class="text-center text-uppercase">

                                        <%        int numeroVideo = 0;

                                            if (modulo.getVideo() != null) {
                                                numeroVideo = modulo.getVideo().size();
                                            }
                                        %>

                                        <span class="badge text-primary">
                                            <%= numeroVideo%>
                                        </span>

                                    </td>


                                    <!-- STATO -->


                                    <td class="text-center text-uppercase">

                                        <%
                                            boolean moduloAttivo
                                                    = modulo.getVideo() != null
                                                    && !modulo.getVideo().isEmpty();
                                        %>

                                        <% if (moduloAttivo) { %>

                                        <span class="badge bg-success text-uppercase">
                                            Attivo
                                        </span>

                                        <% } else { %>

                                        <span class="badge bg-secondary text-uppercase">
                                            Disattivato
                                        </span>

                                        <% }%>

                                    </td>


                                    <!-- AZIONI -->

                                    <td class="text-center text-uppercase">


                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/moduli/dettaglio.jsp?id=<%= modulo.getId()%>"
                                            class="btn btn-sm btn-outline-primary"
                                            >

                                            <svg class="icon icon-sm me-2 icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-burger"></use></svg>
                                            Dettaglio

                                        </a>


                                        <a
                                            href="<%= request.getContextPath()%>/page/admin/moduli/modifica.jsp?id=<%= modulo.getId()%>"
                                            class="btn btn-sm btn-outline-secondary"
                                            >
                                            <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>

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


        <div class="it-footer">
            <%@include file="../footer.jsp" %> 
        </div>           



        <script
            src="<%= request.getContextPath()%>/assets/bootstrap/assets/js/bootstrap-italia.bundle.min.js">
        </script>


    </body>

</html>