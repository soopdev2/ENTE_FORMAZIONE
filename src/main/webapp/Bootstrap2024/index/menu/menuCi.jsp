<%-- 
    Document   : menuCi
    Created on : 15 set 2026
--%>
<%

    String home_active = "";
    String cad_active = "";

    String uri1 = request.getRequestURI();
    String pageName1 = uri1.substring(uri1.lastIndexOf("/") + 1);

    if (pageName1.equals("indexCi.jsp")) {
        home_active = "active";
    } else if (pageName1.equals("createCad.jsp") || pageName1.equals("myCad.jsp")) {
        cad_active = "active";
    }

%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg has-megamenu" aria-label="Menu principale">
    <button type="button" aria-label="Mostra o nascondi il menu" class="custom-navbar-toggler" aria-controls="menu" aria-expanded="false" data-bs-toggle="navbarcollapsible" data-bs-target="#navbar-E">
        <span>
            <svg role="img" class="icon"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-burger"></use></svg>
        </span>
    </button>
    <div class="navbar-collapsable" id="navbar-E">
        <div class="overlay fade"></div>
        <div class="close-div">
            <button type="button" aria-label="Chiudi il menu" class="btn close-menu">
                <span><svg role="img" class="icon"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-close-big"></use></svg></span>
            </button>
        </div>
        <div class="menu-wrapper justify-content-lg-between">
            <ul class="navbar-nav">
                <li class="nav-item active">
                    <a class="nav-link <%=home_active%>" href="indexCi.jsp"><span>Home</span></a>
                </li>
                <li class="nav-item dropdown megamenu">
                    <button type="button" class="nav-link <%=cad_active%> dropdown-toggle px-lg-2 px-xl-3" data-bs-toggle="dropdown" aria-expanded="false" id="megamenu-base-Ci" data-focus-mouse="false">
                        <span>CAD</span><svg role="img" class="icon icon-xs ms-1"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-down-triangle"></use></svg>
                    </button>
                    <div class="dropdown-menu shadow-lg" role="region" aria-labelledby="megamenu-base-Ci">
                        <div class="megamenu pb-5 pt-3 py-lg-0">
                            <div class="row">
                                <div class="col-12">
                                    <div class="row">
                                        <div class="col-12 col-lg-4">
                                            <div class="link-list-wrapper">
                                                <ul class="link-list">
                                                    <li>
                                                        <a class="list-item dropdown-item" href="createCad.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                                                            <span>Crea</span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="list-item dropdown-item" href="myCad.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-search"></use></svg>
                                                            <span>I Miei CAD</span>
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
            </ul>
        </div>
    </div>
</nav>