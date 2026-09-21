
<%-- 
    Document   : navbar
    Author     : Aldo
--%>

<%

    String dashboard_active = "";
    String corsi_active = "";
    String moduli_active = "";
    String video_active = "";
    String statistiche_active = "";
    String utenti_active = "";

    String uri1
            = request.getRequestURI();

    String pageName1
            = uri1.substring(
                    uri1.lastIndexOf("/") + 1
            );

    if (pageName1.equals("dashboard.jsp")) {

        dashboard_active = "active";

    } else if (pageName1.equals("lista.jsp")
            || pageName1.equals("crea.jsp")
            || pageName1.equals("modifica.jsp")
            || pageName1.equals("dettaglio.jsp")
            || pageName1.equals("utenti.jsp")) {

        String path
                = request.getRequestURI();

        if (path.contains("/corsi/")) {

            corsi_active = "active";
        }

    } else if (pageName1.equals("modifica.jsp")
            || pageName1.equals("dettaglio.jsp")) {

        String path
                = request.getRequestURI();

        if (path.contains("/moduli/")) {

            moduli_active = "active";
        }

    } else if (pageName1.equals("modifica.jsp")
            || pageName1.equals("dettaglio.jsp")
            || pageName1.equals("statistiche.jsp")
            || pageName1.equals("utenti.jsp")) {

        String path
                = request.getRequestURI();

        if (path.contains("/video/")) {

            video_active = "active";
        }

    } else if (pageName1.equals("statistiche.jsp")) {

        statistiche_active = "active";

    } else if (pageName1.equals("utenti.jsp")) {

        utenti_active = "active";
    }

%>




<nav
    class="navbar navbar-expand-lg has-megamenu"
    aria-label="Menu principale"
    >

    <!-- ========================================================
         TOGGLE MOBILE
    ========================================================= -->

    <button
        type="button"
        aria-label="Mostra o nascondi il menu"
        class="custom-navbar-toggler"
        aria-controls="menu"
        aria-expanded="false"
        data-bs-toggle="navbarcollapsible"
        data-bs-target="#navbar-E"
        >

        <span>

            <svg
                role="img"
                class="icon"
                >

            <use href=""></use>

            </svg>

        </span>

    </button>


    <div
        class="navbar-collapsable"
        id="navbar-E"
        >

        <div class="overlay fade"></div>


        <div class="close-div">

            <button
                type="button"
                aria-label="Chiudi il menu"
                class="btn close-menu"
                >

                <span>

                    <svg
                        role="img"
                        class="icon"
                        >

                    <use href=""></use>

                    </svg>

                </span>

            </button>

        </div>


        <div class="menu-wrapper justify-content-lg-between">


            <ul class="navbar-nav">


                <!-- =================================================
                     DASHBOARD
                ================================================== -->

                <li class="nav-item">

                    <a
                        class="nav-link <%=dashboard_active%>"
                        href="<%=request.getContextPath()%>/page/admin/dashboard.jsp"
                        >

                        <span>Dashboard</span>

                    </a>

                </li>


                <li class="nav-item dropdown megamenu">

                    <button
                        type="button"
                        class="nav-link <%=corsi_active%> dropdown-toggle px-lg-2 px-xl-3"
                        data-bs-toggle="dropdown"
                        aria-expanded="false"
                        id="megamenu-corsi"
                        data-focus-mouse="false"
                        >

                        <span>Corsi</span>

                        <svg
                            role="img"
                            class="icon icon-xs ms-1"
                            >

                        <use href=""></use>

                        </svg>

                    </button>


                    <div
                        class="dropdown-menu shadow-lg"
                        role="region"
                        aria-labelledby="megamenu-corsi"
                        >

                        <div class="megamenu pb-5 pt-3 py-lg-0">

                            <div class="row">

                                <div class="col-12">

                                    <div class="row">

                                        <div class="col-12 col-lg-4">

                                            <div class="link-list-wrapper">

                                                <ul class="link-list">


                                                    <li>

                                                        <a
                                                            class="list-item dropdown-item"
                                                            href="<%=request.getContextPath()%>/page/admin/corsi/lista.jsp"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="../../Bootstrap2024/assets/svg/sprites.svg#it-list"></use>

                                                            </svg>

                                                            <span>Lista corsi</span>

                                                        </a>

                                                    </li>


                                                    <li>

                                                        <a
                                                            class="list-item dropdown-item"
                                                            href="<%=request.getContextPath()%>/page/admin/corsi/crea.jsp"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use>

                                                            </svg>

                                                            <span>Crea corso</span>

                                                        </a>

                                                    </li>

                                                </ul>

                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </li>


                <li class="nav-item dropdown megamenu">

                    <button
                        type="button"
                        class="nav-link <%=moduli_active%> dropdown-toggle px-lg-2 px-xl-3"
                        data-bs-toggle="dropdown"
                        aria-expanded="false"
                        id="megamenu-moduli"
                        data-focus-mouse="false"
                        >

                        <span>Moduli</span>

                        <svg
                            role="img"
                            class="icon icon-xs ms-1"
                            >

                        <use href=""></use>

                        </svg>

                    </button>


                    <div
                        class="dropdown-menu shadow-lg"
                        role="region"
                        aria-labelledby="megamenu-moduli"
                        >

                        <div class="megamenu pb-5 pt-3 py-lg-0">

                            <div class="row">

                                <div class="col-12">

                                    <div class="row">

                                        <div class="col-12 col-lg-4">

                                            <div class="link-list-wrapper">

                                                <ul class="link-list">


                                                    <li>

                                                        <a
                                                            class="list-item dropdown-item"
                                                            href="<%=request.getContextPath()%>/page/admin/moduli/lista.jsp"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="../../Bootstrap2024/assets/svg/sprites.svg#it-list"></use>

                                                            </svg>

                                                            <span>Lista moduli</span>

                                                        </a>

                                                    </li>


                                                    <li>

                                                        <a
                                                            class="list-item dropdown-item"
                                                            href="<%=request.getContextPath()%>/page/admin/moduli/crea.jsp"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use>

                                                            </svg>

                                                            <span>Crea modulo</span>

                                                        </a>

                                                    </li>

                                                </ul>

                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </li>


                <li class="nav-item dropdown megamenu">

                    <button
                        type="button"
                        class="nav-link <%=video_active%> dropdown-toggle px-lg-2 px-xl-3"
                        data-bs-toggle="dropdown"
                        aria-expanded="false"
                        id="megamenu-video"
                        data-focus-mouse="false"
                        >

                        <span>Video</span>

                        <svg
                            role="img"
                            class="icon icon-xs ms-1"
                            >

                        <use href=""></use>

                        </svg>

                    </button>


                    <div
                        class="dropdown-menu shadow-lg"
                        role="region"
                        aria-labelledby="megamenu-video"
                        >

                        <div class="megamenu pb-5 pt-3 py-lg-0">

                            <div class="row">

                                <div class="col-12">

                                    <div class="row">

                                        <div class="col-12 col-lg-4">

                                            <div class="link-list-wrapper">

                                                <ul class="link-list">


                                                    <li>

                                                        <a
                                                            class="list-item dropdown-item"
                                                            href="<%=request.getContextPath()%>/page/admin/video/lista.jsp"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="../../Bootstrap2024/assets/svg/sprites.svg#it-list"></use>

                                                            </svg>

                                                            <span>Lista video</span>

                                                        </a>

                                                    </li>


                                                    <li>

                                                        <a
                                                            class="list-item dropdown-item"
                                                            href="<%=request.getContextPath()%>/page/admin/video/crea.jsp"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use>

                                                            </svg>

                                                            <span>Crea video</span>

                                                        </a>

                                                    </li>


                                                    <!--li>

                                                        <a
                                                            class="list-item dropdown-item"
                                                            href="<%=request.getContextPath()%>/page/admin/video/statistiche.jsp"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="../../Bootstrap2024/assets/svg/sprites.svg#it-chart"></use>

                                                            </svg>

                                                            <span>Statistiche video</span>

                                                        </a>

                                                    </li-->

                                                </ul>

                                            </div>

                                        </div-->

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </li>


                <!--li class="nav-item">

                    <a
                        class="nav-link <%=statistiche_active%>"
                        href="<%=request.getContextPath()%>/page/admin/video/statistiche.jsp"
                        >

                        <span>Statistiche</span>

                    </a>

                </li-->

                <!--li class="nav-item">

                    <a
                        class="nav-link <%=utenti_active%>"
                        href="<%=request.getContextPath()%>/page/admin/corsi/utenti.jsp"
                        >

                        <span>Utenti</span>

                    </a>

                </li-->


            </ul>

        </div>

    </div>

</nav>
