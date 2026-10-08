

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
        <meta charset="utf-8" />
        <title>FAD VIDEO</title>

        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />

        <!-- BOOTSTRAP COMUNI E FONT TITILLIUM WEB -->
        <link rel="stylesheet" href="Bootstrap2024/assets/css/bootstrap-italia.min.css"/>
        <link rel="stylesheet" href="Bootstrap2024/assets/css/global.css"/>
        <link rel="stylesheet" href="Bootstrap2024/assets/css/ita.min.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium+Web' rel='stylesheet'>

        <meta name="_csrf" content="4bfd1575-3ad1-4d21-96c7-4ef2d9f86721"/>
        <meta name="_csrf_header" content="X-CSRF-TOKEN"/>

        <script>
            function heidiDecode(hex) {
                var str = '';
                var shift = parseInt(hex.substr(-1));
                hex = hex.substr(0, hex.length - 1);

                for (var i = 0; i < hex.length; i += 2) {
                    str += String.fromCharCode(
                            parseInt(hex.substr(i, 2), 16) - shift
                            );
                }

                return str;
            }

            /* =========================================================
             ALERT BOOTSTRAP ITALIA
             ========================================================= */
            function biAlert(type, title, message) {

                var box = document.getElementById('bi-alerts');

                if (!box) {
                    return null;
                }

                /* Elimina eventuali alert precedenti */
                box.innerHTML = '';

                var el = document.createElement('div');

                el.className = 'alert alert-' + type
                        + ' alert-dismissible fade show mb-3';

                el.setAttribute('role', 'alert');
                el.setAttribute('aria-live', 'assertive');

                /*
                 * NON inseriamo manualmente l'icona:
                 * Bootstrap Italia la gestisce già tramite
                 * la classe alert-danger / alert-info / ecc.
                 */
                el.innerHTML =
                        '<div class="d-flex align-items-center pe-4 bi-alert-content">'
                        + '<div>'
                        + '<strong>' + title + '</strong>'
                        + (message
                                ? ' - ' + message
                                : '')
                        + '</div>'
                        + '</div>'

                        + '<button type="button"'
                        + ' class="btn-close"'
                        + ' data-bs-dismiss="alert"'
                        + ' aria-label="Chiudi notifica">'
                        + '</button>';

                box.appendChild(el);

                /*
                 * Porta l'alert nella visualizzazione
                 */
                el.scrollIntoView({
                    block: 'nearest',
                    behavior: 'smooth'
                });

                return el;
            }
        </script>



        <style>

            /* =========================================================
               ESTETICA LOGIN SPID + CIE
               ========================================================= */

            /* I due pulsanti occupano ciascuno la propria cella */
            .spid-login-container > .ita {
                position: relative;
                width: 100%;
                min-width: 0;
            }

            /* Pulsante SPID / CIE */
            .spid-login-container .ita-button {
                box-sizing: border-box;
                width: 100%;
                min-height: 58px;
                border-radius: 8px;

                transition:
                    transform 0.2s ease,
                    box-shadow 0.2s ease;
            }

            .spid-login-container .ita-button:hover {
                transform: translateY(-2px);

                box-shadow:
                    0 5px 14px rgba(0, 0, 0, 0.12);
            }

            /* Tendina IDP: ancorata sotto il pulsante, non sfonda la pagina */
            .spid-login-container .ita-menu {
                box-sizing: border-box;

                top: 100%;
                left: 0;

                width: 100%;

                max-width: 100%;

                max-height: 60vh;

                overflow-y: auto;
            }



            @media (min-width: 576px) {

                .spid-login-container {

                    display: grid;

                    grid-template-columns: 1fr 1fr;

                    gap: 15px;

                    align-items: center;
                }
            }


            /* =========================================================
               MOBILE
               ========================================================= */

            @media (max-width: 575px) {

                .spid-login-container {
                    display: block;
                }

                .spid-login-container > .ita:first-child {
                    margin-bottom: 15px;
                }
            }

            #bi-alerts .bi-alert-content {
                overflow-wrap: anywhere;
            }

        </style>



        <script src="assets/bootstrap/soop/js/jquery-3.7.1.js"></script>

        <script src="Bootstrap2024/assets/js/ita.min.js"></script>



        <style>

            .spid-login-container {
                position: relative;
                overflow: visible !important;
            }

            /* BI rende .card-wrapper un flex-row: qui va impilato */
            .card-wrapper {
                display: block;
            }

            main,
            .container,
            .row,
            .col-lg-5,
            .card-wrapper,
            .card,
            .card-body,
            .spid-login-container {
                overflow: visible;
            }

            footer {
                position: relative;
                z-index: 1;
            }

        </style>

    </head>


    <body class="d-flex flex-column min-vh-100">


        <%@include file="Bootstrap2024/index/login/menu_login.jsp" %>
        <%@include file="Bootstrap2024/index/login/Header_login.jsp" %>

        <hr style="color: white">



        <main class="flex-grow-1 d-flex align-items-center justify-content-center bg-white">

            <div class="container">

                <div class="row justify-content-center">

                    <div class="col-lg-5 col-md-8">


                        <div class="card-wrapper">

                            <div class="card shadow-sm">

                                <div id="bi-alerts"></div>

                                <div class="text-center">
                                    <div class="text-primary">
                                        <strong class="text-uppercase">Ente formazione</strong>
                                    </div>
                                </div>




                                <div class="card-body p-4">

                                    <!-- =====================================================
                                         LOGIN CLASSICO
                                         ===================================================== -->

                                    <form action="LoginServlet"
                                          method="POST"
                                          onsubmit="return ctrlForm();">

                                        <input type="hidden"
                                               name="isLogin"
                                               value="true"/>


                                        <div class="mb-3">

                                            <label for="user" class="form-label text-primary text-uppercase">
                                                Username
                                            </label>

                                            <input type="text"
                                                   class="form-control"
                                                   id="user"
                                                   name="username"
                                                   autocomplete="off">

                                        </div>


                                        <div class="mb-3">

                                            <label for="password" class="form-label text-primary text-uppercase">
                                                Password
                                            </label>

                                            <input type="password"
                                                   class="form-control"
                                                   id="password"
                                                   name="password"
                                                   autocomplete="off">

                                        </div>


                                        <div class="d-flex justify-content-end mb-3">


                                            <a href="javascript:;"
                                               class="it-link text-uppercase" style="font-size: 13px">
                                                Password dimenticata?
                                            </a>

                                        </div>

                                        <button type="submit"
                                                class="btn btn-primary w-100 text-uppercase">
                                            Effettua l'accesso
                                        </button>

                                    </form>

                                    <hr class="my-4">


                                    <!-- =====================================================
                                         SPID + CIE
                                         ===================================================== -->

                                    <div class="spid-login-container">


                                        <!-- ================= SPID ================= -->

                                        <div class="ita ita-dropdown ita-extended">

                                            <button type="button"
                                                    class="ita-button">

                                                <img src="Bootstrap2024/assets/svg/spid.svg"
                                                     alt="SPID" />

                                                <span class="ita-content">Entra con SPID</span>

                                            </button>

                                            <div class="ita-menu"
                                                 role="menu"
                                                 data-spid-remote>
                                            </div>

                                        </div>


                                        <!-- ================= CIE ================= -->

                                        <div class="ita ita-extended">

                                            <a class="ita-button" href="AuthServlet">

                                                <img src="Bootstrap2024/assets/svg/cie.svg"
                                                     alt="CIE" />

                                                <span class="ita-content">Entra con CIE</span>

                                            </a>

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </main>


        <div class="it-footer">          
            <%@include file="page/admin/footer.jsp" %>
        </div>




        <!-- =========================================================
             JAVASCRIPT
             ========================================================= -->

        <script src="assets/bootstrap/soop/js/utility.js"
        type="text/javascript"></script>


        <script>

                                              function ctrlForm() {

                                                  var err = false;

                                                  var user = $("#user");
                                                  var pass = $("#password");


                                                  if (checkValue(user, false)) {
                                                      err = true;
                                                  }


                                                  if (checkValue(pass, false)) {
                                                      err = true;
                                                  }


                                                  if (err) {

                                                      biAlert(
                                                              'danger',
                                                              'Dati di accesso incompleti',
                                                              'Inserisci username e password.'
                                                              );

                                                      return false;
                                                  }


                                                  biAlert(
                                                          'info',
                                                          'Accesso in corso',
                                                          'Attendere...'
                                                          );


                                                  return true;
                                              }

        </script>





        <script src="Bootstrap2024/assets/js/bootstrap-italia.bundle.min.js"
        type="text/javascript"></script>


        <!-- =========================================================
             LOGIN ERROR
             ========================================================= -->

        <script type="text/javascript">

            <%
                String esito = request.getParameter("esito");

                if (esito == null) {
                    esito = "";
                } else if (esito.equals("KO")) {
            %>

                                              biAlert(
                                                      'danger',
                                                      'Credenziali errate',
                                                      'Username o password non validi. Riprovare.'
                                                      );

            <%
            } else if (esito.equals("banned")) {
            %>

                                              biAlert(
                                                      'danger',
                                                      'Utenza bloccata',
                                                      'L\'account è stato bloccato. Contattare l\'amministratore.'
                                                      );

            <%
                }
            %>

        </script>


        <!-- =========================================================
             SPID - popolamento della tendina IDP
             ========================================================= -->

        <script>

            new Ita();

            /*
             * La tendina IDP viene mostrata dal CSS (focus/hover):
             * qui limitiamo la sua altezza allo spazio disponibile
             * sotto il pulsante, in modo che non esca dalla finestra.
             */
            $(function () {

                var PAD = 12;

                var $ita = $('.spid-login-container .ita-dropdown');

                if (!$ita.length) {
                    return;
                }

                var $menu = $ita.find('.ita-menu');

                function fit() {

                    var el = $menu.get(0);

                    if (!el || el.offsetParent === null) {
                        return;
                    }

                    var r = $ita.get(0).getBoundingClientRect();

                    var below = window.innerHeight - r.bottom - PAD;

                    el.style.maxHeight = Math.max(below, 120) + 'px';
                }

                $ita.on('focusin mouseenter', fit);
                $(window).on('resize scroll', fit);
            });

        </script>


    </body>

</html>
