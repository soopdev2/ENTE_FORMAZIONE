<%@page import="entity.User"%>
<%@page import="Utility.Utils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


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

%>

<!DOCTYPE html>
<html lang="it">
    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
            >

        <title>Dashboard Admin</title>

        <!-- Bootstrap -->
        <link
            href="../../assets/bootstrap/assets/css/bootstrap.min.css"
            rel="stylesheet"
            >

    </head>

    <body class="bg-light">


        <%@ include file="Header.jsp" %>
        <%@ include file="navbar.jsp" %>



        <main class="container py-5">



            <div class="mb-5">

                <h1 class="fw-bold mb-2">
                    Dashboard
                </h1>

                <p class="text-muted mb-0">
                    Gestisci i moduli, i video e il monitoraggio
                    della formazione.
                </p>

            </div>


            <div class="row g-4">


                <!-- MODULI -->

                <div class="col-md-6 col-xl-4">

                    <div class="card shadow-sm h-100">

                        <div class="card-body p-4 d-flex flex-column">

                            <div class="mb-3">

                                <div
                                    class="bg-primary bg-opacity-10 rounded p-3 d-inline-block"
                                    >
                                    <span class="fs-3">
                                        📚
                                    </span>
                                </div>

                            </div>


                            <h4 class="card-title">
                                Corsi
                            </h4>

                            <p class="card-text text-muted">

                                Crea e gestisci i corsi della
                                formazione e organizza i relativi moduli.

                            </p>


                            <div class="mt-auto pt-3">

                                <a
                                    href="<%= request.getContextPath()%>/page/admin/corsi/lista.jsp"
                                    class="btn btn-primary"
                                    >
                                    Gestisci corsi →
                                </a>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- VIDEO -->

                <div class="col-md-6 col-xl-4">

                    <div class="card shadow-sm h-100">

                        <div class="card-body p-4 d-flex flex-column">

                            <div class="mb-3">

                                <div
                                    class="bg-success bg-opacity-10 rounded p-3 d-inline-block"
                                    >
                                    <span class="fs-3">
                                        🎬
                                    </span>
                                </div>

                            </div>


                            <h4 class="card-title">
                                Video
                            </h4>

                            <p class="card-text text-muted">

                                Gestisci i video della formazione,
                                assegnali ai moduli e stabilisci
                                il loro ordine.

                            </p>


                            <div class="mt-auto pt-3">

                                <a
                                    href="<%= request.getContextPath()%>/page/admin/video/lista.jsp"
                                    class="btn btn-success"
                                    >
                                    Gestisci video →
                                </a>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- STATISTICHE -->

                <div class="col-md-6 col-xl-4">

                    <div class="card shadow-sm h-100">

                        <div class="card-body p-4 d-flex flex-column">

                            <div class="mb-3">

                                <div
                                    class="bg-warning bg-opacity-10 rounded p-3 d-inline-block"
                                    >
                                    <span class="fs-3">
                                        📊
                                    </span>
                                </div>

                            </div>


                            <h4 class="card-title">
                                Statistiche
                            </h4>

                            <p class="card-text text-muted">

                                Controlla lo stato di avanzamento degli
                                utenti e il completamento dei video.

                            </p>


                            <div class="mt-auto pt-3">

                                <a
                                    href="<%= request.getContextPath()%>/page/admin/video/statistiche.jsp"
                                    class="btn btn-warning"
                                    >
                                    Visualizza statistiche →
                                </a>

                            </div>

                        </div>

                    </div>

                </div>


            </div>


            <!--div class="card shadow-sm mt-5">

                <div class="card-body p-4">

                    <div class="row align-items-center">

                        <div class="col-lg-8">

                            <h4 class="mb-2">
                                Gestione formazione
                            </h4>

                            <p class="text-muted mb-lg-0">

                                Crea un modulo, aggiungi i video e
                                controlla successivamente l'avanzamento
                                degli utenti.

                            </p>

                        </div>


                        <div class="col-lg-4 mt-3 mt-lg-0 text-lg-end">

                            <a
                                href="<%= request.getContextPath()%>/page/admin/moduli/crea.jsp"
                                class="btn btn-outline-primary"
                                >
                                + Crea nuovo modulo
                            </a>

                        </div>

                    </div>

                </div>

            </div-->


        </main>

        <%@include file="footer.jsp" %>



        <script
            src="../../assets/bootstrap/assets/js/bootstrap.bundle.min.js">
        </script>

    </body>

</html>