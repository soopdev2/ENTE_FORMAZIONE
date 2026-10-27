<%-- 
    Document   : registrazione
    Created on : 23 ott 2026, 09:26:18
    Author     : Aldo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Registrazione - FAD VIDEO</title>

        <link rel="stylesheet"
              href="<%= request.getContextPath()%>/Bootstrap2024/assets/css/bootstrap-italia.min.css">
        <link rel="stylesheet"
              href="<%= request.getContextPath()%>/Bootstrap2024/assets/css/global.css">
        <link rel="stylesheet"
              href="<%= request.getContextPath()%>/Bootstrap2024/assets/css/ita.min.css">
        <link href="https://fonts.googleapis.com/css?family=Titillium+Web"
              rel="stylesheet">

        <style>
            body {
                min-height: 100%;
                font-family: 'Titillium Web', sans-serif;
            }

            .registration-main {
                padding: 40px 12px;
            }

            .registration-card {
                max-width: 620px;
                width: 100%;
                margin: 0 auto;
                border: 0;
                border-radius: 8px;
            }

            .registration-card .card-body {
                padding: 32px;
            }

            .registration-heading {
                color: #0066cc;
                font-weight: 600;
            }

            @media (max-width: 575px) {
                .registration-card .card-body {
                    padding: 24px 20px;
                }
            }
        </style>
    </head>

    <body class="d-flex flex-column min-vh-100">

        <%@include file="../Bootstrap2024/index/login/menu_login.jsp" %>
        <%@include file="../Bootstrap2024/index/login/Header_login.jsp" %>

        <main class="registration-main flex-grow-1">
            <div class="container">
                <div class="card shadow-sm registration-card">
                    <div class="card-body">

                        <div class="text-center mb-4">
                            <h1 class="h3 registration-heading">
                                Crea il tuo account
                            </h1>
                            <p class="text-secondary">
                                Compila i tuoi dati. Riceverai via email
                                le credenziali per il primo accesso.
                            </p>
                        </div>

                        <%
                            String esito = request.getParameter("esito");

                            if ("duplicato".equals(esito)) {
                        %>
                        <div class="alert alert-warning" role="alert">
                            Esiste già un account con questa email oppure
                            non è possibile utilizzare i dati inseriti.
                        </div>
                        <%
                        } else if ("erroreEmail".equals(esito)) {
                        %>
                        <div class="alert alert-danger" role="alert">
                            Non è stato possibile inviare l'email delle credenziali.
                            Se il problema persiste, contatta l'assistenza.
                        </div>
                        <%
                        } else if ("errore".equals(esito)) {
                        %>
                        <div class="alert alert-danger" role="alert">
                            Non è stato possibile completare la registrazione.
                            Riprova più tardi.
                        </div>
                        <%
                            }
                        %>

                        <form action="<%= request.getContextPath()%>/LoginServlet"
                              method="POST">

                            <input type="hidden"
                                   name="azione"
                                   value="registrazione">

                            <div class="mb-3">
                                <label for="nome" class="form-label">
                                    Nome
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="nome"
                                       name="nome"
                                       maxlength="80"
                                       autocomplete="given-name"
                                       required>
                            </div>

                            <div class="mb-3">
                                <label for="cognome" class="form-label">
                                    Cognome
                                </label>
                                <input type="text"
                                       class="form-control"
                                       id="cognome"
                                       name="cognome"
                                       maxlength="80"
                                       autocomplete="family-name"
                                       required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    Indirizzo email
                                </label>
                                <input type="email"
                                       class="form-control"
                                       id="email"
                                       name="email"
                                       maxlength="254"
                                       autocomplete="email"
                                       required>
                            </div>

                            <div class="mb-4">
                                <label for="telefono" class="form-label">
                                    Telefono (facoltativo)
                                </label>
                                <input type="tel"
                                       class="form-control"
                                       id="telefono"
                                       name="telefono"
                                       maxlength="30"
                                       autocomplete="tel">
                            </div>

                            <button type="submit"
                                    class="btn btn-primary w-100 text-uppercase">
                                Crea account
                            </button>

                            <div class="text-center mt-3">
                                <a href="<%= request.getContextPath()%>/index.jsp">
                                    Hai già un account? Accedi
                                </a>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </main>

        <div class="it-footer">
            <%@include file="../page/admin/footer.jsp" %>
        </div>

        <script src="<%= request.getContextPath()%>/Bootstrap2024/assets/js/bootstrap-italia.bundle.min.js"></script>
    </body>
</html>
