<%-- 
    Document   : navbar.jsp
    Author     : Aldo
--%>

<%

    String dashboard_active = "";
    String corsi_active = "";

    String uri1
            = request.getRequestURI();

    String pageName1
            = uri1.substring(
                    uri1.lastIndexOf("/") + 1
            );

    if (pageName1.equals("dashboard.jsp")) {

        dashboard_active = "active";

    } else if (pageName1.equals("moduli.jsp")
            || pageName1.equals("video-list.jsp")
            || pageName1.equals("video.jsp")) {

        corsi_active = "active";
    }

%>




<nav
    class="navbar navbar-expand-lg has-megamenu"
    aria-label="Menu principale"
    >

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


                <li class="nav-item">

                    <a
                        class="nav-link <%=dashboard_active%>"
                        href="<%=request.getContextPath()%>/page/user/dashboard.jsp"
                        >

                        <span>Dashboard</span>

                    </a>

                </li>


                <!--li class="nav-item dropdown megamenu">

                    <button
                        type="button"
                        class="nav-link <%=corsi_active%> dropdown-toggle px-lg-2 px-xl-3"
                        data-bs-toggle="dropdown"
                        aria-expanded="false"
                        id="megamenu-corsi-user"
                        data-focus-mouse="false"
                        >

                        <span>I miei corsi</span>

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
                        aria-labelledby="megamenu-corsi-user"
                        >

                        <div
                            class="megamenu pb-5 pt-3 py-lg-0"
                            >

                            <div class="row">

                                <div class="col-12">

                                    <div class="row">

                                        <div
                                            class="col-12 col-lg-4"
                                            >

                                            <div
                                                class="link-list-wrapper"
                                                >

                                                <ul
                                                    class="link-list"
                                                    >


                                                    <li>

                                                        <a
                                                            class="list-item dropdown-item"
                                                            href="<%=request.getContextPath()%>/page/user/dashboard.jsp"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="../../Bootstrap2024/assets/svg/sprites.svg#it-list"></use>

                                                            </svg>

                                                            <span>I miei corsi</span>

                                                        </a>

                                                    </li>


                                                    <li>

                                                        <span
                                                            class="list-item dropdown-item"
                                                            style="cursor: default;"
                                                            >

                                                            <svg
                                                                role="img"
                                                                class="icon icon-sm me-2"
                                                                >

                                                            <use href="<%=request.getContextPath()%>/assets/bootstrap/assets/svg/sprites.svg#it-info-circle"></use>

                                                            </svg>

                                                            <span>
                                                                Seleziona un corso dalla dashboard
                                                            </span>

                                                        </span>

                                                    </li>


                                                </ul>

                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </li-->


            </ul>


        </div>

    </div>

</nav>
