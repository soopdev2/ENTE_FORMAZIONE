<%-- 
    Document   : reimpostaPassword
    Created on : 21 ott 2026, 15:04:52
    Author     : Aldo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Reimposta password - FAD VIDEO</title>

        <link rel="stylesheet"
              href="Bootstrap2024/assets/css/bootstrap-italia.min.css">
        <link rel="stylesheet"
              href="Bootstrap2024/assets/css/global.css">
        <link rel="stylesheet"
              href="Bootstrap2024/assets/css/ita.min.css">
        <link href="https://fonts.googleapis.com/css?family=Titillium+Web"
              rel="stylesheet">

        <style>
            html, body {
                min-height: 100%;
                font-family: 'Titillium Web', sans-serif;
            }

            .recovery-main {
                padding: 48px 12px;
            }

            .recovery-card-wrapper {
                width: 100%;
                max-width: 520px;
                margin: 0 auto;
            }

            .recovery-card {
                border: 0;
                border-radius: 8px;
                overflow: hidden;
            }

            .recovery-card .card-body {
                padding: 32px;
            }

            .recovery-heading {
                color: #0066cc;
                font-weight: 600;
            }

            .recovery-icon {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 64px;
                height: 64px;
                margin: 0 auto 20px;
                border-radius: 50%;
                background-color: #eaf2ff;
                color: #0066cc;
                font-size: 30px;
            }

            .recovery-description {
                color: #5c6f82;
                line-height: 1.6;
            }

            .recovery-actions {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            @media (max-width: 575px) {
                .recovery-card .card-body {
                    padding: 24px 20px;
                }
            }
        </style>
    </head>

    <body class="d-flex flex-column min-vh-100">


        <%@include file="Bootstrap2024/index/login/menu_login.jsp" %>
        <%@include file="Bootstrap2024/index/login/Header_login.jsp" %>


        <hr style="color: white">

        <main class="recovery-main flex-grow-1 d-flex align-items-center">
            <div class="container">
                <div class="recovery-card-wrapper">
                    <div class="card shadow-sm recovery-card">
                        <div class="card-body">

                            <div class="text-center mb-4">
                                <div class="recovery-icon" aria-hidden="true">
                                    &#128274;
                                </div>

                                <div class="text-primary text-uppercase mb-2">
                                    <strong>Ente formazione</strong>
                                </div>

                                <h1 class="h3 recovery-heading mb-3">
                                    Reimposta password
                                </h1>

                                <p class="recovery-description mb-0">
                                    Inserisci la nuova password e confermala
                                    per completare il recupero del tuo account.
                                </p>
                            </div>


                            <div id="feedback" aria-live="polite">
                                <%
                                    String esito = request.getParameter("esito");

                                    if ("successo".equals(esito)) {
                                %>
                                <div class="alert alert-success" role="alert">
                                    <strong>Password aggiornata!</strong>
                                    Ora puoi accedere utilizzando la tua nuova password.

                                    <div class="mt-3">
                                        <a href="<%= request.getContextPath()%>/index.jsp"
                                           class="btn btn-primary">
                                            Torna al login
                                        </a>
                                    </div>
                                </div>
                                <%
                                } else if ("tokenNonValido".equals(esito)) {
                                %>
                                <div class="alert alert-danger" role="alert">
                                    Il link di recupero non è valido oppure è scaduto.
                                    Richiedi un nuovo recupero password.
                                </div>
                                <%
                                } else if ("passwordNonValida".equals(esito)) {
                                %>
                                <div class="alert alert-danger" role="alert">
                                    Le password non coincidono oppure non rispettano
                                    i requisiti richiesti.
                                </div>
                                <%
                                } else if ("errore".equals(esito)) {
                                %>
                                <div class="alert alert-danger" role="alert">
                                    Non è stato possibile reimpostare la password.
                                    Riprova più tardi.
                                </div>
                                <%
                                    }
                                %>
                            </div>

                            <% if (!"successo".equals(esito)) {%>
                            <form action="LoginServlet"
                                  method="POST"
                                  onsubmit="return validaForm();">

                                <input type="hidden"
                                       name="azione"
                                       value="reimpostaPassword">

                                <input type="hidden"
                                       name="token"
                                       id="token">

                                <div class="mb-4">
                                    <label for="password"
                                           class="form-label text-primary text-uppercase">
                                        Nuova password
                                    </label>

                                    <input type="password"
                                           class="form-control"
                                           id="password"
                                           name="password"
                                           autocomplete="new-password"
                                           minlength="8"
                                           maxlength="128"
                                           required>

                                    <div class="form-text mt-2">
                                        Inserisci una password di almeno 8 caratteri.
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="confermaPassword"
                                           class="form-label text-primary text-uppercase">
                                        Conferma nuova password
                                    </label>

                                    <input type="password"
                                           class="form-control"
                                           id="confermaPassword"
                                           name="confermaPassword"
                                           autocomplete="new-password"
                                           minlength="8"
                                           maxlength="128"
                                           required>
                                </div>

                                <div class="recovery-actions">
                                    <button type="submit"
                                            class="btn btn-primary w-100 text-uppercase">
                                        Salva nuova password
                                    </button>

                                    <a href="<%= request.getContextPath()%>/index.jsp"
                                       class="btn btn-outline-secondary w-100">
                                        Torna al login
                                    </a>
                                </div>
                            </form>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <div class="it-footer">          
            <%@include file="page/admin/footer.jsp" %>
        </div>


        <script src="Bootstrap2024/assets/js/bootstrap-italia.bundle.min.js"
        type="text/javascript"></script>

        <script>
                                      // Recupera il token presente nel link ricevuto via email.
                                      const parametri = new URLSearchParams(window.location.search);
                                      document.getElementById("token").value =
                                              parametri.get("token") || "";

                                      function validaForm() {
                                          const token = document.getElementById("token");
                                          const password = document.getElementById("password");
                                          const conferma = document.getElementById("confermaPassword");

                                          if (!token.value.trim()) {
                                              alert("Il link di recupero non contiene un token valido. Richiedi un nuovo link.");
                                              return false;
                                          }

                                          if (password.value.length < 8) {
                                              password.focus();
                                              alert("La password deve contenere almeno 8 caratteri.");
                                              return false;
                                          }

                                          if (password.value !== conferma.value) {
                                              conferma.focus();
                                              conferma.setCustomValidity("Le password non coincidono.");
                                              conferma.reportValidity();
                                              return false;
                                          }

                                          conferma.setCustomValidity("");
                                          return true;
                                      }

                                      document.getElementById("confermaPassword")
                                              .addEventListener("input", function () {
                                                  this.setCustomValidity("");
                                              });
        </script>

    </body>
</html>
