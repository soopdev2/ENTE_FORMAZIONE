<%@page import="Utility.Utils"%>
<%@ page import="entity.Corso" %>
<%@ page import="entity.User" %>
<%@ page import="entity.UserCorso" %>
<%@ page import="service.CorsoService" %>
<%@ page import="service.UserCorsoService" %>
<%@ page import="repositories.UserRepository" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>

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

    String corsoIdParam = request.getParameter("corsoId");

    if (corsoIdParam == null || corsoIdParam.isBlank()) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                "Parametro corsoId mancante.");
        return;
    }

    Long corsoId;

    try {
        corsoId = Long.parseLong(corsoIdParam);
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                "corsoId non valido.");
        return;
    }

    CorsoService corsoService = new CorsoService();
    UserCorsoService userCorsoService = new UserCorsoService();
    UserRepository userRepository = new UserRepository();

    Corso corso = corsoService.getCorso(corsoId);

    if (corso == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND,
                "Corso non trovato.");
        return;
    }

    List<User> tuttiGliUtenti = userRepository.findAll();

    List<UserCorso> assegnazioni
            = userCorsoService.getUtentiCorso(corsoId);

    Set<Long> utentiAssegnati = new HashSet<>();

    for (UserCorso userCorso : assegnazioni) {

        if (userCorso.getUser() != null) {
            utentiAssegnati.add(
                    userCorso.getUser().getId()
            );
        }
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

        <title>Utenti - <%= corso.getTitolo()%></title>

        <link
            rel="stylesheet"
            href="../../../assets/bootstrap/assets/css/bootstrap.min.css"
            >

    </head>

    <body>

        <%@ include file="../Header.jsp" %>
        <%@ include file="../navbar.jsp" %>


        <main class="container py-4">


            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="mb-1">
                        Utenti del corso
                    </h1>

                    <p class="text-muted mb-0">
                        <strong>
                            <%= corso.getTitolo()%>
                        </strong>
                    </p>

                </div>

                <div>

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/dettaglio.jsp?id=<%= corsoId%>"
                        class="btn btn-secondary"
                        >
                        Torna al corso
                    </a>

                </div>

            </div>


            <div class="card shadow-sm mb-4">

                <div class="card-header">

                    <h5 class="mb-0">
                        Assegna corso a un utente
                    </h5>

                </div>

                <div class="card-body">

                    <form
                        method="post"
                        action="<%= request.getContextPath()%>/UserCorsoServlet"
                        >

                        <input
                            type="hidden"
                            name="action"
                            value="assign"
                            >

                        <input
                            type="hidden"
                            name="corsoId"
                            value="<%= corsoId%>"
                            >


                        <div class="row align-items-end">

                            <div class="col-md-9">

                                <label
                                    for="userId"
                                    class="form-label"
                                    >
                                    Utente
                                </label>

                                <select
                                    id="userId"
                                    name="userId"
                                    class="form-select"
                                    required
                                    >

                                    <option value="">
                                        -- Seleziona utente --
                                    </option>

                                    <%
                                        boolean utentiDisponibili = false;

                                        for (User user : tuttiGliUtenti) {

                                            if (user == null || user.getId() == null) {
                                                continue;
                                            }

                                            if (utentiAssegnati.contains(user.getId())) {
                                                continue;
                                            }

                                            utentiDisponibili = true;
                                    %>

                                    <option value="<%= user.getId()%>">

                                        <%= user.getNome() != null
                                                ? user.getNome()
                                                : ""%>

                                        <%= user.getCognome() != null
                                                ? user.getCognome()
                                                : ""%>

                                        -

                                        <%= user.getEmail() != null
                                                ? user.getEmail()
                                                : ""%>

                                    </option>

                                    <%
                                        }

                                        if (!utentiDisponibili) {
                                    %>

                                    <option value="" disabled>
                                        Tutti gli utenti sono già assegnati
                                    </option>

                                    <%
                                        }
                                    %>

                                </select>

                            </div>


                            <div class="col-md-3">

                                <button
                                    type="submit"
                                    class="btn btn-primary w-100"
                                    <%= !utentiDisponibili ? "disabled" : ""%>
                                    >
                                    Assegna corso
                                </button>

                            </div>

                        </div>

                    </form>

                </div>

            </div>


            <div class="card shadow-sm">

                <div class="card-header">

                    <div class="d-flex justify-content-between align-items-center">

                        <h5 class="mb-0">
                            Utenti assegnati
                        </h5>

                        <span class="badge bg-primary">
                            <%= assegnazioni.size()%>
                        </span>

                    </div>

                </div>


                <div class="card-body p-0">

                    <%
                        if (assegnazioni.isEmpty()) {
                    %>

                    <div class="p-4 text-center text-muted">

                        <p class="mb-0">
                            Nessun utente è stato ancora assegnato a questo corso.
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
                                        Email
                                    </th>

                                    <th>
                                        Assegnazione
                                    </th>

                                    <th>
                                        Stato
                                    </th>

                                    <th>
                                        Completamento
                                    </th>

                                    <th class="text-end">
                                        Azioni
                                    </th>

                                </tr>

                            </thead>

                            <tbody>

                                <%
                                    for (UserCorso userCorso : assegnazioni) {

                                        User user = userCorso.getUser();
                                %>

                                <tr>

                                    <!-- UTENTE -->

                                    <td>

                                        <strong>

                                            <%= user != null && user.getNome() != null
                                                    ? user.getNome()
                                                    : ""%>

                                            <%= user != null && user.getCognome() != null
                                                    ? user.getCognome()
                                                    : ""%>

                                        </strong>

                                    </td>


                                    <!-- EMAIL -->

                                    <td>

                                        <%= user != null && user.getEmail() != null
                                                ? user.getEmail()
                                                : "-"%>

                                    </td>


                                    <!-- DATA ASSEGNAZIONE -->

                                    <td>

                                        <%= userCorso.getDataAssegnazione() != null
                                                ? userCorso.getDataAssegnazione()
                                                : "-"%>

                                    </td>


                                    <!-- STATO -->

                                    <td>

                                        <%
                                            String stato = userCorso.getStato() != null
                                                    ? userCorso.getStato().name()
                                                    : "-";

                                            String badgeClass = "bg-secondary";

                                            if ("ASSEGNATO".equals(stato)) {
                                                badgeClass = "bg-secondary";
                                            } else if ("IN_CORSO".equals(stato)) {
                                                badgeClass = "bg-warning text-dark";
                                            } else if ("COMPLETATO".equals(stato)) {
                                                badgeClass = "bg-success";
                                            }
                                        %>

                                        <span class="badge <%= badgeClass%>">
                                            <%= stato%>
                                        </span>

                                    </td>


                                    <!-- PERCENTUALE -->

                                    <td style="min-width: 180px;">

                                        <%
                                            Double percentuale
                                                    = userCorso.getPercentuale();

                                            if (percentuale == null) {
                                                percentuale = 0.0;
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
                                                <%= String.format("%.0f", percentuale)%>%
                                            </div>

                                        </div>

                                    </td>


                                    <!-- AZIONI -->

                                    <td class="text-end">

                                        <form
                                            method="post"
                                            action="<%= request.getContextPath()%>/UserCorsoServlet"
                                            class="d-inline"
                                            onsubmit="return confirm('Vuoi rimuovere questo utente dal corso?');"
                                            >

                                            <input
                                                type="hidden"
                                                name="action"
                                                value="remove"
                                                >

                                            <input
                                                type="hidden"
                                                name="userId"
                                                value="<%= user.getId()%>"
                                                >

                                            <input
                                                type="hidden"
                                                name="corsoId"
                                                value="<%= corsoId%>"
                                                >

                                            <button
                                                type="submit"
                                                class="btn btn-sm btn-outline-danger"
                                                >
                                                Rimuovi
                                            </button>

                                        </form>

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

        <%@include file="../footer.jsp" %>


        <script
            src="../../../assets/bootstrap/assets/js/bootstrap.bundle.min.js"
        ></script>

    </body>

</html>