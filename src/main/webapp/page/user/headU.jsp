<%@page import="Utility.Utils"%>
<%@page import="entity.User"%>
<%@page import="java.util.Date"%>
<%
    String no_cache = "?dummy=" + String.valueOf(new Date().getTime());
    String guida = Utils.checkAttribute(session, "guida");

    String userIdParam = session.getAttribute("userId").toString();
    Long userId2 = Long.parseLong(userIdParam);
    User us = Utils.findUserById(userId2);

    String nome_profilo = us.getUsername();
    String iniziale_profilo = (nome_profilo == null || nome_profilo.trim().isEmpty())
            ? "U" : nome_profilo.trim().substring(0, 1).toUpperCase();
%>
<!-- Barra utente / menu profilo -->
<div class="it-header-slim-wrapper">
    <div class="it-header-slim-wrapper-content w-100">

        <span class="d-none d-lg-inline text-white-50 small text-uppercase fw-semibold profile-area-label">
            Area utente
        </span>

        <div class="dropdown ms-auto">
            <a href="#" class="d-flex align-items-center text-white text-decoration-none" id="userDropdown"
               data-bs-toggle="dropdown" aria-expanded="false" aria-label="Menu utente">
                <span class="d-none d-md-inline me-2 small text-white">Ciao, <strong><%=nome_profilo%></strong></span>
                <span class="avatar profile-avatar fw-bold text-primary"><%=iniziale_profilo%></span>
            </a>

            <style>
                /* Rimuove la striscia bianca (padding verticale) e la freccia bianca del dropdown utente */
                .it-header-slim-wrapper .dropdown-menu {
                    --bs-dropdown-padding-y: 0;
                    --bs-dropdown-border-width: 0;
                    border: 0;
                    overflow: hidden;
                }
                .it-header-slim-wrapper .dropdown-menu:before {
                    display: none;
                }
            </style>

            <ul class="dropdown-menu bg-primary dropdown-menu-end shadow border-0" aria-labelledby="userDropdown" style="min-width:270px;">
                <li>
                    <div class="d-flex align-items-center p-3 profile-dropdown-head" style="border-bottom : 1px solid white">
                        <span class="avatar profile-avatar profile-avatar-lg fw-bold me-3"><%=iniziale_profilo%></span>
                        <div class="text-white lh-sm text-break">
                            <div class="fw-bold"><%=nome_profilo%></div>
                            <div class="small text-white">Admin</div>
                        </div>
                    </div>
                </li>

                <li>
                    <a class="dropdown-item d-flex align-items-center text-primary bg-white" href="href="#">
                        <svg class="icon icon-sm me-2 icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-user"></use></svg>
                        Dati personali
                    </a>
                </li>
                
                <li>
                    <a class="dropdown-item d-flex align-items-center border-bottom text-primary bg-white href="href="#">
                        <svg class="icon icon-sm me-2 icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-key"></use></svg>
                        Cambia Password
                    </a>
                </li>
                

                <li>
                    <a class="dropdown-item d-flex align-items-center text-primary bg-white" href="<%=request.getContextPath()%>/LoginServlet?isLogin">
                        <svg class="icon icon-sm me-2 icon-primary" aria-hidden="true"><use href="../../../Bootstrap2024/assets/svg/sprites.svg#it-logout"></use></svg>
                        Esci
                    </a>
                </li>
            </ul>
        </div>

    </div>
</div>
