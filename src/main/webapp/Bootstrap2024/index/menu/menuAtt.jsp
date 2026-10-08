<%-- 
    Document   : menuAtt
    Created on : 4 set 2025, 09:16:45
    Author     : Aldo
--%>

<%

    String home_active = "";
    String allievi_active = "";
    String docenti_active = "";
    String progettiF_active = "";
    String materialeD_active = "";
    String faq_active = "";

    String uri1 = request.getRequestURI();
    String pageName1 = uri1.substring(uri1.lastIndexOf("/") + 1);

    if (pageName1.equals("indexSoggettoAttuatore.jsp")) {
        home_active = "active";
    } else if (pageName1.equals("modello1.jsp") || pageName1.equals("searchAllievi.jsp")) {
        allievi_active = "active";

    } else if (pageName1.equals("newDocente.jsp") || pageName1.equals("searchDocenti_sa.jsp")) {
        docenti_active = "active";
    } else if (pageName1.equals("newProgettoFormativo.jsp") || pageName1.equals("searchProgettiFormativi.jsp")) {
        progettiF_active = "active";
    } else if (pageName1.equals("downloadModelli.jsp") || pageName1.equals("downloadModelliFS.jsp")) {
        materialeD_active = "active";
    } else if (pageName1.equals("myFAQ.jsp") || pageName1.equals("allFAQ.jsp")) {
        faq_active = "active";
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
                    <a class="nav-link <%=home_active%>" href="indexSoggettoAttuatore.jsp"><span>Home</span></a>
                </li>
                <li class="nav-item dropdown megamenu">
                    <button type="button" class="nav-link <%=allievi_active%> dropdown-toggle px-lg-2 px-xl-3" data-bs-toggle="dropdown" aria-expanded="false" id="megamenu-base-E" data-focus-mouse="false">
                        <span>Allievi</span><svg role="img" class="icon icon-xs ms-1"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-down-triangle"></use></svg>
                    </button>
                    <div class="dropdown-menu shadow-lg" role="region" aria-labelledby="megamenu-base-E">
                        <div class="megamenu pb-5 pt-3 py-lg-0">
                            <div class="row">
                                <div class="col-12">
                                    <div class="row">
                                        <div class="col-12 col-lg-4">
                                            <div class="link-list-wrapper">
                                                <ul class="link-list">
                                                    <li>
                                                        <a class="list-item dropdown-item active" href="modello1.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                                                            <span>Aggiungi</span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="list-item dropdown-item" href="searchAllievi.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-search"></use></svg>
                                                            <span>Cerca</span>
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
                    <button type="button" class="nav-link <%=docenti_active%> dropdown-toggle px-lg-2 px-xl-3" data-bs-toggle="dropdown" aria-expanded="false" id="megamenu-base-E" data-focus-mouse="false">
                        <span>Docenti</span><svg role="img" class="icon icon-xs ms-1"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-down-triangle"></use></svg>
                    </button>
                    <div class="dropdown-menu shadow-lg" role="region" aria-labelledby="megamenu-base-E">
                        <div class="megamenu pb-5 pt-3 py-lg-0">
                            <div class="row">
                                <div class="col-12">
                                    <div class="row">
                                        <div class="col-12 col-lg-4">
                                            <div class="link-list-wrapper">
                                                <ul class="link-list">
                                                    <li>
                                                        <a class="list-item dropdown-item" href="newDocente.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                                                            <span>Aggiungi</span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="list-item dropdown-item" href="searchDocenti_sa.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-search"></use></svg>
                                                            <span>Cerca</span>
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
                    <button type="button" class="nav-link <%=progettiF_active%> dropdown-toggle px-lg-2 px-xl-3" data-bs-toggle="dropdown" aria-expanded="false" id="megamenu-base-E" data-focus-mouse="false">
                        <span>Progetti Formativi</span><svg role="img" class="icon icon-xs ms-1"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-down-triangle"></use></svg>
                    </button>
                    <div class="dropdown-menu shadow-lg" role="region" aria-labelledby="megamenu-base-E">
                        <div class="megamenu pb-5 pt-3 py-lg-0">
                            <div class="row">
                                <div class="col-12">
                                    <div class="row">
                                        <div class="col-12 col-lg-4">
                                            <div class="link-list-wrapper">
                                                <ul class="link-list">
                                                    <li>
                                                        <a class="list-item dropdown-item" href="newProgettoFormativo.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-pencil"></use></svg>
                                                            <span>Aggiungi</span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="list-item dropdown-item" href="searchProgettiFormativi.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-search"></use></svg>
                                                            <span>Cerca</span>
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
                    <button type="button" class="nav-link <%=materialeD_active%> dropdown-toggle px-lg-2 px-xl-3" data-bs-toggle="dropdown" aria-expanded="false" id="megamenu-base-E" data-focus-mouse="false">
                        <span>Materiale Didattico</span><svg role="img" class="icon icon-xs ms-1"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-down-triangle"></use></svg>
                    </button>
                    <div class="dropdown-menu shadow-lg" role="region" aria-labelledby="megamenu-base-E">
                        <div class="megamenu pb-5 pt-3 py-lg-0">
                            <div class="row">
                                <div class="col-12">
                                    <div class="row">
                                        <div class="col-12 col-lg-4">
                                            <div class="link-list-wrapper">
                                                <ul class="link-list">
                                                    <li>
                                                        <a class="list-item dropdown-item" href="downloadModelli.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-download"></use></svg>
                                                            <span>Download</span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="list-item dropdown-item" href="downloadModelliFS.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-download"></use></svg>
                                                            <span>Modelli in Facsimile</span>
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
                    <button type="button" class="nav-link <%=faq_active%> dropdown-toggle px-lg-2 px-xl-3" data-bs-toggle="dropdown" aria-expanded="false" id="megamenu-base-E" data-focus-mouse="false">
                        <span>FAQ</span><svg role="img" class="icon icon-xs ms-1"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-arrow-down-triangle"></use></svg>
                    </button>
                    <div class="dropdown-menu shadow-lg" role="region" aria-labelledby="megamenu-base-E">
                        <div class="megamenu pb-5 pt-3 py-lg-0">
                            <div class="row">
                                <div class="col-12">
                                    <div class="row">
                                        <div class="col-12 col-lg-4">
                                            <div class="link-list-wrapper">
                                                <ul class="link-list">
                                                    <li>
                                                        <a class="list-item dropdown-item" href="myFAQ.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-comment"></use></svg>
                                                            <span>Le Mie Domande</span>
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="list-item dropdown-item" href="allFAQ.jsp">
                                                            <svg role="img" class="icon icon-sm me-2"><use href="../../Bootstrap2024/assets/svg/sprites.svg#it-comment"></use></svg>
                                                            <span>FAQ</span>
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

