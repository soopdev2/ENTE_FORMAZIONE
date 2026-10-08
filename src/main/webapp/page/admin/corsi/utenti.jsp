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
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />

        <!-- BOOTSTRAP COMUNI E FONT TITILLIUM WEB -->
        <link rel="stylesheet" href="../../../Bootstrap2024/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="../../../Bootstrap2024/assets/css/global.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium+Web' rel='stylesheet'>

        <title>Utenti - <%= corso.getTitolo()%></title>

    </head>

    <body>

        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>


        <main class="container py-4">

            <hr style="color:white">


            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h2 class="mb-1">
                        Utenti del corso
                    </h2>

                    <p class="text-muted mb-0 text-uppercase">
                        <strong>
                            <%= corso.getTitolo()%>
                        </strong>
                    </p>

                </div>

                <div>

                    <a
                        href="<%= request.getContextPath()%>/page/admin/corsi/dettaglio.jsp?id=<%= corsoId%>"
                        class="btn btn-outline-secondary"
                        >
                        <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-left-circle"></use></svg>
                        TORNA AL CORSO
                    </a>

                </div>

            </div>


            <div class="card shadow-sm mb-4">

                <div class="card-header">

                    <h5 class="mb-0 text-uppercase">
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
                                    class="form-label class="text-uppercase"
                                    >
                                    UTENTE
                                </label>

                                <select
                                    id="userId"
                                    name="userId"
                                    class="form-select class="text-uppercase"
                                    required
                                    >

                                    <option value="" class="text-uppercase">
                                        -- SELEZIONA UTENTE --
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

                                    <option class="text-uppercase" value="<%= user.getId()%>">

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

                                    <option class="text-uppercase" value="" disabled>
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
                                    class="btn btn-outline-primary class="text-uppercase" w-100"
                                    <%= !utentiDisponibili ? "disabled" : ""%>
                                    >
                                    <svg class="icon icon-sm me-2 icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>
                                    ASSEGNA CORSO
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

                    <div class="p-4 text-center text-muted text-uppercase">

                        <p class="mb-0">
                            Nessun utente è stato ancora assegnato a questo corso.
                        </p>

                    </div>

                    <%
                    } else {
                    %>

                    <div class="table-responsive">

                        <table class="table table-hover align-middle mb-0">

                            <thead>

                                <tr>

                                    <th scope="col" class="bg-primary text-white text-center text-uppercase">
                                        Utente
                                    </th class="bg-primary text-white text-center text-uppercase">

                                    <th scope="col" class="bg-primary text-white text-center text-uppercase">
                                        Email
                                    </th>

                                    <th scope="col" class="bg-primary text-white text-center text-uppercase">
                                        Assegnazione
                                    </th>

                                    <th scope="col" class="bg-primary text-white text-center text-uppercase">
                                        Stato
                                    </th>

                                    <th scope="col" class="bg-primary text-white text-center text-uppercase">
                                        Completamento
                                    </th>

                                    <th scope="col" class="bg-primary text-white text-center text-uppercase">
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

                                    <td class="text-center text-uppercase">

                                        <strong >

                                            <%= user != null && user.getNome() != null
                                                    ? user.getNome()
                                                    : ""%>

                                            <%= user != null && user.getCognome() != null
                                                    ? user.getCognome()
                                                    : ""%>

                                        </strong>

                                    </td>


                                    <!-- EMAIL -->

                                    <td class="text-center text-uppercase">

                                        <%= user != null && user.getEmail() != null
                                                ? user.getEmail()
                                                : "-"%>

                                    </td>


                                    <!-- DATA ASSEGNAZIONE -->

                                    <td class="text-center text-uppercase">

                                        <%= userCorso.getDataAssegnazione() != null
                                                ? userCorso.getDataAssegnazione()
                                                : "-"%>

                                    </td>


                                    <!-- STATO -->

                                    <td class="text-center text-uppercase">

                                        <%
                                            String stato = userCorso.getStato() != null
                                                    ? userCorso.getStato().name()
                                                    : "-";

                                            String badgeClass = "bg-secondary";

                                            if ("ASSEGNATO".equals(stato)) {
                                                badgeClass = "bg-secondary";
                                            } else if ("IN_CORSO".equals(stato)) {
                                                badgeClass = "bg-warning ";
                                            } else if ("COMPLETATO".equals(stato)) {
                                                badgeClass = "bg-success";
                                            }
                                        %>

                                        <span class="badge <%= badgeClass%>">
                                            <%= stato%>
                                        </span>

                                    </td>


                                    <!-- PERCENTUALE -->

                                    <td style="min-width: 180px;" class="text-center">

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

                                    <td class="text-center">

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
                                                <svg class="icon icon-sm me-2 icon-danger"
                                                     aria-hidden="true">

                                                <use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-close-circle"></use>

                                                </svg>
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


        <div class="it-footer">
            <%@include file="../footer.jsp" %> 
        </div>           



        <script
            src="../../../assets/bootstrap/assets/js/bootstrap.bundle.min.js"
        ></script>

    </body>

</html>