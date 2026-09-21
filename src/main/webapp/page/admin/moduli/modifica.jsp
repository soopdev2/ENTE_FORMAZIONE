<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="entity.Modulo" %>
<%@ page import="entity.Corso" %>
<%@ page import="service.ModuloService" %>
<%@ page import="service.CorsoService" %>
<%@ page import="java.util.List" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

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
    
    String idParam = request.getParameter("id");

    if (idParam == null || idParam.isEmpty()) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID modulo mancante"
        );

        return;
    }

    Long moduloId;

    try {

        moduloId = Long.valueOf(idParam);

    } catch (NumberFormatException e) {

        response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "ID modulo non valido"
        );

        return;
    }

    ModuloService moduloService = new ModuloService();

    Modulo modulo = moduloService.getModulo(moduloId);

    if (modulo == null) {

        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Modulo non trovato"
        );

        return;
    }


    CorsoService corsoService = new CorsoService();

    List<Corso> corsi = corsoService.getCorsiAttivi();

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
            Modifica Modulo
        </title>


        <link
            href="<%= request.getContextPath()%>/assets/bootstrap/assets/css/bootstrap.min.css"
            rel="stylesheet"
            >

    </head>


    <body class="bg-light">


        <%@ include file="../../admin/Header.jsp" %>
        <%@ include file="../../admin/navbar.jsp" %>


        <main class="container py-5">


            <div class="row justify-content-center">

                <div class="col-lg-8">


                    <!-- HEADER -->

                    <div class="d-flex justify-content-between align-items-center mb-4">

                        <div>

                            <h1 class="mb-1">

                                Modifica modulo

                            </h1>


                            <p class="text-muted mb-0">

                                Modifica i dati del modulo.

                            </p>

                        </div>


                        <a
                            href="<%= request.getContextPath()%>/page/admin/moduli/lista.jsp"
                            class="btn btn-outline-secondary"
                            >

                            ← Torna alla lista

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
                                    value="update"
                                    >


                                <!-- ID -->

                                <input
                                    type="hidden"
                                    name="id"
                                    value="<%= modulo.getId()%>"
                                    >


                                <!-- ID VISIBILE -->

                                <div class="mb-4">

                                    <label
                                        class="form-label fw-semibold"
                                        >

                                        ID

                                    </label>


                                    <input
                                        type="text"
                                        class="form-control"
                                        value="<%= modulo.getId()%>"
                                        disabled
                                        >

                                </div>


                                <!-- CORSO -->

                                <div class="mb-4">

                                    <label
                                        for="corsoId"
                                        class="form-label fw-semibold"
                                        >

                                        Corso

                                    </label>


                                    <select
                                        class="form-select"
                                        id="corsoId"
                                        name="corsoId"
                                        required
                                        >

                                        <option
                                            value=""
                                            disabled
                                            >

                                            Seleziona un corso

                                        </option>


                                        <%

                                            Long corsoAttualeId = null;

                                            if (modulo.getCorso() != null) {

                                                corsoAttualeId
                                                        = modulo.getCorso().getId();

                                            }

                                            for (Corso corso : corsi) {

                                                boolean selezionato
                                                        = corsoAttualeId != null
                                                        && corsoAttualeId.equals(corso.getId());

                                        %>

                                        <option
                                            value="<%= corso.getId()%>"
                                            <%= selezionato ? "selected" : ""%>
                                            >

                                            <%= corso.getTitolo()%>

                                        </option>

                                        <%

                                            }

                                        %>

                                    </select>

                                </div>


                                <!-- TITOLO -->

                                <div class="mb-4">

                                    <label
                                        for="titolo"
                                        class="form-label fw-semibold"
                                        >

                                        Titolo

                                    </label>


                                    <input
                                        type="text"
                                        class="form-control"
                                        id="titolo"
                                        name="titolo"
                                        maxlength="255"
                                        required
                                        value="<%= modulo.getTitolo()%>"
                                        >

                                </div>


                                <!-- DESCRIZIONE -->

                                <div class="mb-4">

                                    <label
                                        for="descrizione"
                                        class="form-label fw-semibold"
                                        >

                                        Descrizione

                                    </label>


                                    <textarea
                                        class="form-control"
                                        id="descrizione"
                                        name="descrizione"
                                        rows="5"
                                        ><%= modulo.getDescrizione() != null
                                                ? modulo.getDescrizione()
                                                : ""%></textarea>

                                </div>


                                <!-- STATO -->

                                <div class="mb-4">

                                    <label
                                        class="form-label fw-semibold"
                                        >

                                        Stato

                                    </label>


                                    <div>

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

                                    </div>

                                </div>


                                <!-- AZIONI -->

                                <div class="d-flex justify-content-end gap-2">


                                    <!-- ANNULLA -->

                                    <a
                                        href="<%= request.getContextPath()%>/page/admin/moduli/lista.jsp"
                                        class="btn btn-secondary"
                                        >

                                        Annulla

                                    </a>


                                    <!-- SALVA -->

                                    <button
                                        type="submit"
                                        class="btn btn-primary"
                                        >

                                        Salva modifiche

                                    </button>


                                </div>


                            </form>

                        </div>

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