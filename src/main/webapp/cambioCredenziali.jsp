<%-- 
    Document   : cambioCredenziali
    Created on : 23 ott 2026, 09:31:12
    Author     : Aldo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null
            || !Boolean.TRUE.equals(
                    session.getAttribute("cambioPasswordObbligatorio"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Cambia credenziali - FAD VIDEO</title>

        <link rel="stylesheet"
              href="Bootstrap2024/assets/css/bootstrap-italia.min.css">
        <link rel="stylesheet"
              href="/Bootstrap2024/assets/css/global.css">
        <link rel="stylesheet"
              href="/Bootstrap2024/assets/css/ita.min.css">
        <link href="https://fonts.googleapis.com/css?family=Titillium+Web"
              rel="stylesheet">

        <style>
            body {
                min-height: 100%;
                font-family: 'Titillium Web', sans-serif;
            }

            .credentials-main {
                padding: 40px 12px;
            }

            .credentials-card {
                width: 100%;
                max-width: 560px;
                margin: 0 auto;
                border: 0;
                border-radius: 8px;
            }

            .credentials-card .card-body {
                padding: 32px;
            }

            .credentials-heading {
                color: #0066cc;
                font-weight: 600;
            }

            @media (max-width: 575px) {
                .credentials-card .card-body {
                    padding: 24px 20px;
                }
            }
        </style>
    </head>

    <body class="d-flex flex-column min-vh-100">

        <%@include file="/Bootstrap2024/index/login/menu_login.jsp" %>
        <%@include file="/Bootstrap2024/index/login/Header_login.jsp" %>

        <main class="credentials-main flex-grow-1">
            <div class="container">
                <div class="card shadow-sm credentials-card">
                    <div class="card-body">

                        <h1 class="h3 credentials-heading text-center mb-3">
                            Completa il tuo primo accesso
                        </h1>

                        <p class="text-secondary text-center mb-4">
                            Per proteggere il tuo account devi scegliere
                            una nuova password. Puoi anche personalizzare
                            il tuo nome utente.
                        </p>

                        <%
                            String esito = request.getParameter("esito");

                            if ("passwordNonValida".equals(esito)) {
                        %>
                        <div class="alert alert-danger" role="alert">
                            Controlla la password, la conferma e il nome utente.
                        </div>
                        <%
                        } else if ("usernameNonDisponibile".equals(esito)) {
                        %>
                        <div class="alert alert-danger" role="alert">
                            Il nome utente scelto potrebbe essere già utilizzato.
                            Prova con un altro nome.
                        </div>
                        <%
                        } else if ("errore".equals(esito)) {
                        %>
                        <div class="alert alert-danger" role="alert">
                            Non è stato possibile aggiornare le credenziali.
                            Riprova.
                        </div>
                        <%
                            }
                        %>

                        <form action="<%= request.getContextPath()%>/LoginServlet"
                              method="POST"
                              onsubmit="return validaCredenziali();">

                            <input type="hidden"
                                   name="azione"
                                   value="cambiaCredenziali">

                            <div class="mb-4">
                                <label for="nuovoUsername" class="form-label">
                                    Nuovo nome utente (facoltativo)
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="nuovoUsername"
                                       name="nuovoUsername"
                                       minlength="3"
                                       maxlength="50"
                                       pattern="[a-zA-Z0-9._-]*"
                                       autocomplete="username"
                                       placeholder="Lascia vuoto per mantenere quello attuale">

                                <div class="form-text">
                                    Puoi usare lettere, numeri, punto, trattino
                                    e trattino basso.
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label">
                                    Nuova password
                                </label>
                                <input type="password"
                                       class="form-control"
                                       id="password"
                                       name="password"
                                       minlength="8"
                                       maxlength="72"
                                       autocomplete="new-password"
                                       required>
                            </div>

                            <div class="mb-4">
                                <label for="confermaPassword" class="form-label">
                                    Conferma nuova password
                                </label>
                                <input type="password"
                                       class="form-control"
                                       id="confermaPassword"
                                       name="confermaPassword"
                                       minlength="8"
                                       maxlength="72"
                                       autocomplete="new-password"
                                       required>
                            </div>

                            <button type="submit"
                                    class="btn btn-primary w-100 text-uppercase">
                                Salva credenziali
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <div class="it-footer">
            <%@include file="page/admin/footer.jsp" %>
        </div>

        <script>
            function validaCredenziali() {
                const password = document.getElementById("password");
                const conferma = document.getElementById("confermaPassword");

                if (password.value.length < 8 || password.value.length > 72) {
                    alert("La password deve contenere da 8 a 72 caratteri.");
                    password.focus();
                    return false;
                }

                if (password.value !== conferma.value) {
                    alert("Le password non coincidono.");
                    conferma.focus();
                    return false;
                }

                return true;
            }
        </script>

        <script src="Bootstrap2024/assets/js/bootstrap-italia.bundle.min.js"></script>
    </body>
</html>
