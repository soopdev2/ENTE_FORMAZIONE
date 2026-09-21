<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="entity.Corso" %>
<%@ page import="service.CorsoService" %>

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
                + "page/error/403.jsp"
        );

        return;
    }

    CorsoService corsoService = new CorsoService();

    List<Corso> corsi
            = corsoService.getCorsiAttivi();

    String corsoIdParam = request.getParameter("corsoId");

%>


<!DOCTYPE html>



    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>
            Nuovo Modulo
        </title>


        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/assets/bootstrap/assets/css/bootstrap.min.css"
            />

    </head>


    <body class="bg-light">


        <%@ include file="../../admin/Header.jsp" %>
        <%@ include file="../../admin/navbar.jsp" %>

        <main class="container py-5">


            <div class="container py-5">


                <div class="row justify-content-center">

                    <div class="col-lg-8">


                        <!-- HEADER -->

                        <div class="d-flex justify-content-between align-items-center mb-4">

                            <div>

                                <h1 class="mb-1">

                                    Nuovo modulo

                                </h1>


                                <p class="text-muted mb-0">

                                    Crea un nuovo modulo di formazione.

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
                                        value="create"
                                        >


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
                                                <%= corsoIdParam == null
                                                        ? "selected"
                                                        : ""%>
                                                >

                                                Seleziona un corso

                                            </option>


                                            <%

                                                if (corsi != null
                                                        && !corsi.isEmpty()) {

                                                    for (Corso corso : corsi) {

                                                        boolean selezionato
                                                                = corsoIdParam != null
                                                                && corsoIdParam.equals(
                                                                        String.valueOf(
                                                                                corso.getId()
                                                                        )
                                                                );

                                            %>


                                            <option
                                                value="<%= corso.getId()%>"
                                                <%= selezionato ? "selected" : ""%>
                                                >

                                                <%= corso.getTitolo()%>

                                            </option>


                                            <%

                                                }

                                            } else {

                                            %>


                                            <option
                                                value=""
                                                disabled
                                                >

                                                Nessun corso disponibile

                                            </option>


                                            <%                                            }

                                            %>

                                        </select>


                                        <div class="form-text">

                                            Seleziona il corso a cui appartiene
                                            questo modulo.

                                        </div>

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
                                            placeholder="Es. Sicurezza sul lavoro"
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
                                            placeholder="Inserisci una descrizione del modulo..."
                                            ></textarea>

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


                                        <!-- CREA -->

                                        <button
                                            type="submit"
                                            class="btn btn-primary"
                                            <%= (corsi == null || corsi.isEmpty())
                                                    ? "disabled"
                                                    : ""%>
                                            >

                                            Crea modulo

                                        </button>

                                    </div>


                                </form>

                            </div>

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

