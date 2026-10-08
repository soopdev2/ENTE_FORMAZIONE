<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
            Nuovo corso
        </title>
    </head>


    <body class="d-flex flex-column min-vh-100">


        <%@ include file="../menu/head.jsp" %>
        <%@ include file="../../../Bootstrap2024/index/index_SoggettoAttuatore/Header_soggettoAttuatore.jsp"%>
        <%@ include file="../navbar.jsp" %>

        <main class="container py-5 flex-grow-1">


            <div class="row justify-content-center">

                <div class="col-lg-8">


                    <!-- HEADER -->

                    <div class="d-flex justify-content-between align-items-center mb-4">

                        <div>

                            <h2 class="mb-1">
                                Nuovo corso
                            </h2>


                            <p class="text-muted mb-0">

                                Crea un nuovo corso di formazione.

                            </p>

                        </div>


                        <a
                            href="<%= request.getContextPath()%>/page/admin/corsi/lista.jsp"
                            class="btn btn-outline-secondary"
                            >

                            <svg class="icon icon-sm me-2 icon-secondary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-left-circle"></use></svg>
                            TORNA ALLA LISTA

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
                                        class="form-label fw-semibold text-uppercase"
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
                                        class="form-label fw-semibold text-uppercase"
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

                                    <label class="form-label fw-semibold text-uppercase">

                                        Stato

                                    </label>


                                    <div>

                                        <span class="badge bg-success text-uppercase">

                                            Attivo

                                        </span>

                                    </div>


                                    <div class="form-text">

                                        Il corso viene creato attivo.

                                    </div>

                                </div>


                                <!-- AZIONI -->

                                <div class="d-flex justify-content-end gap-2 mt-4">


                                    <!-- CREA -->    
                                    <button
                                        type="submit"
                                        class="btn btn-outline-primary text-uppercase"
                                        >
                                        <svg class="icon icon-sm me-2 icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-plus-circle"></use></svg>

                                        Crea corso

                                    </button>

                                </div>


                            </form>

                        </div>

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