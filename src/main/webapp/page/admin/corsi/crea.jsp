<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="it">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>
            Nuovo corso
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


            <div class="row justify-content-center">

                <div class="col-lg-8">


                    <!-- HEADER -->

                    <div class="d-flex justify-content-between align-items-center mb-4">

                        <div>

                            <h1 class="mb-1">

                                Nuovo corso

                            </h1>


                            <p class="text-muted mb-0">

                                Crea un nuovo corso di formazione.

                            </p>

                        </div>


                        <a
                            href="<%= request.getContextPath()%>/page/admin/corsi/lista.jsp"
                            class="btn btn-outline-secondary"
                            >

                            ← Torna alla lista

                        </a>

                    </div>


                    <!-- FORM -->

                    <div class="card shadow-sm">

                        <div class="card-body p-4">


                            <form
                                action="<%= request.getContextPath()%>/CorsoServlet"
                                method="post"
                                >


                                <!-- ACTION -->

                                <input
                                    type="hidden"
                                    name="action"
                                    value="create"
                                    >


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
                                        autofocus
                                        >


                                    <div class="form-text">

                                        Inserisci il titolo del corso.

                                    </div>

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
                                        rows="6"
                                        maxlength="1000"
                                        ></textarea>


                                    <div class="form-text">

                                        Inserisci una breve descrizione del corso.

                                    </div>

                                </div>


                                <!-- STATO INIZIALE -->

                                <div class="mb-4">

                                    <label class="form-label fw-semibold">

                                        Stato

                                    </label>


                                    <div>

                                        <span class="badge bg-success">

                                            Attivo

                                        </span>

                                    </div>


                                    <div class="form-text">

                                        Il corso viene creato attivo.

                                    </div>

                                </div>


                                <!-- AZIONI -->

                                <div class="d-flex justify-content-end gap-2 mt-4">


                                    <!-- ANNULLA -->

                                    <a
                                        href="<%= request.getContextPath()%>/page/admin/corsi/lista.jsp"
                                        class="btn btn-secondary"
                                        >

                                        Annulla

                                    </a>


                                    <!-- CREA -->

                                    <button
                                        type="submit"
                                        class="btn btn-primary"
                                        >

                                        Crea corso

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