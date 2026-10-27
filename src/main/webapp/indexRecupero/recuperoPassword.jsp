<%-- 
    Document   : recuperoPassword
    Created on : 21 ott 2026, 14:18:51
    Author     : Aldo
--%>
<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Objects"%>



<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8" />
        <title>Recupero password - FAD VIDEO</title>

        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="description" content="Recupero password della piattaforma FAD VIDEO" />

        <!-- BOOTSTRAP ITALIA E FONT -->
        <link rel="stylesheet"
              href="../Bootstrap2024/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet"
              href="../Bootstrap2024/assets/css/global.css"/>
        <link rel="stylesheet"
              href="../Bootstrap2024/assets/css/ita.min.css"/>
        <link href="https://fonts.googleapis.com/css?family=Titillium+Web"
              rel="stylesheet">

        <style>
            html,
            body {
                min-height: 100%;
                font-family: 'Titillium Web', sans-serif;
            }

            .recovery-main {
                padding: 48px 0;
            }

            .recovery-card-wrapper {
                display: block;
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

            #feedback {
                overflow-wrap: anywhere;
            }

            @media (max-width: 575px) {
                .recovery-main {
                    padding: 28px 12px;
                }

                .recovery-card .card-body {
                    padding: 24px 20px;
                }
            }
        </style>
    </head>

    <body class="d-flex flex-column min-vh-100">


        <%@include file="../Bootstrap2024/index/login/menu_login.jsp" %>
        <%@include file="../Bootstrap2024/index/login/Header_login.jsp" %>


        <hr style="color: white">

        <main class="recovery-main flex-grow-1 d-flex align-items-center">
            <div class="container">

                <div class="recovery-card-wrapper">
                    <div class="card shadow-sm recovery-card">

                        <div class="card-body">

                            <div id="feedback" aria-live="polite">
                                <%                                    String esito = request.getParameter("esito");

                                    if ("ok".equals(esito)) {
                                %>
                                <div class="alert alert-success" role="alert">
                                    <strong>Richiesta ricevuta.</strong>
                                    Se l'indirizzo inserito è associato a un account,
                                    riceverai le istruzioni per reimpostare la password.
                                </div>
                                <%
                                } else if ("errore".equals(esito)) {
                                %>
                                <div class="alert alert-danger" role="alert">
                                    Non è stato possibile elaborare la richiesta.
                                    Riprova più tardi.
                                </div>
                                <%
                                    }
                                %>
                            </div>

                            <div class="text-center mb-4">
                                <div class="recovery-icon" aria-hidden="true">
                                    &#128274;
                                </div>

                                <div class="text-primary text-uppercase mb-2">
                                    <strong>Ente formazione</strong>
                                </div>

                                <h1 class="h3 recovery-heading mb-3">
                                    Recupero password
                                </h1>

                                <p class="recovery-description mb-0">
                                    Hai dimenticato la password?
                                    Inserisci l'indirizzo email associato al tuo account.
                                    Ti forniremo le istruzioni per reimpostarla.
                                </p>
                            </div>

                            <form action="<%= request.getContextPath()%>/LoginServlet"
                                  method="POST"
                                  onsubmit="return validaForm();">

                                <input type="hidden"
                                       name="azione"
                                       value="recuperoPassword"/>

                                <div class="mb-4">
                                    <label for="email"
                                           class="form-label text-primary text-uppercase">
                                        Indirizzo email
                                    </label>

                                    <input type="email"
                                           class="form-control"
                                           id="email"
                                           name="email"
                                           placeholder="nome@esempio.it"
                                           autocomplete="email"
                                           maxlength="254"
                                           required
                                           aria-describedby="email-help">

                                    <div id="email-help"
                                         class="form-text mt-2">
                                        Inserisci l'email utilizzata per registrarti
                                        alla piattaforma.
                                    </div>
                                </div>

                                <div class="recovery-actions">

                                    <button type="submit"
                                            class="btn btn-primary w-100 text-uppercase">
                                        Richiedi recupero password
                                    </button>

                                    <a href="../index.jsp"
                                       class="btn btn-outline-secondary w-100">
                                        ← Torna al login
                                    </a>

                                </div>
                            </form>

                        </div>
                    </div>
                </div>

            </div>
        </main>

        <!-- FOOTER -->

        <div class="it-footer">          
            <%@include file="../page/admin/footer.jsp" %>
        </div>

        <script src="../Bootstrap2024/assets/js/bootstrap-italia.bundle.min.js"
        type="text/javascript"></script>

        <script>
                                      function validaForm() {
                                          var email = document.getElementById("email");
                                          var valore = email.value.trim();

                                          if (valore === "" || !email.checkValidity()) {
                                              email.focus();
                                              email.reportValidity();
                                              return false;
                                          }

                                          return true;
                                      }
        </script>

    </body>
</html>