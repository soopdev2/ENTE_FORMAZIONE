

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>



    <head>
        <meta charset="utf-8" />
        <title>FAD VIDEO</title>

        <meta name="description" content="Login page example">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <meta name="_csrf" content="4bfd1575-3ad1-4d21-96c7-4ef2d9f86721"/>
        <meta name="_csrf_header" content="X-CSRF-TOKEN"/>

        <link href="https://fonts.cdnfonts.com/css/titillium-web" rel="stylesheet">

        <!-- Fonts -->
        <script src="assets/resource/webfont.js"></script>

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

            WebFont.load({
                google: {
                    "families": [
                        "Poppins:300,400,500,600,700",
                        "Roboto:300,400,500,600,700",
                        "Architects Daughter:300,400,500,600,700"
                    ]
                },
                active: function () {
                    sessionStorage.fonts = true;
                }
            });
        </script>

        <style>

            /* =========================================================
               ESTETICA LOGIN SPID + CIE
               ========================================================= */

            .spid-login-container {
                padding: 30px !important;
                border-radius: 14px !important;
            }

            /* Contenitore dei due pulsanti */
            .spid-login-container > form {
                margin-bottom: 0;
            }

            /* SPID */
            .spid-login-container .button-spid {
                width: 100% !important;
                min-height: 58px;
                margin-bottom: 0 !important;

                display: flex !important;
                align-items: center;
                justify-content: center;

                border-radius: 8px !important;

                transition:
                    transform 0.2s ease,
                    box-shadow 0.2s ease;
            }

            .spid-login-container .button-spid:hover {
                transform: translateY(-2px);

                box-shadow:
                    0 5px 14px rgba(0, 0, 0, 0.12);
            }

            /* Form CIE */
            .spid-login-container > form:last-child {
                height: 58px;

                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* Pulsante CIE */
            .spid-login-container > form:last-child input[type="image"] {

                width: 100%;
                height: 58px;

                object-fit: contain;

                padding: 4px !important;

                border-radius: 8px;

                transition:
                    transform 0.2s ease,
                    box-shadow 0.2s ease;
            }

            .spid-login-container > form:last-child input[type="image"]:hover {

                transform: translateY(-2px);

                box-shadow:
                    0 5px 14px rgba(0, 0, 0, 0.12);
            }



            @media (min-width: 576px) {

                .spid-login-container {

                    display: grid;

                    grid-template-columns: 1fr 1fr;

                    gap: 15px;

                    align-items: center;
                }

                .spid-login-container > form:first-of-type {
                    grid-column: 1;
                }

                .spid-login-container > form:last-child {
                    grid-column: 2;
                }
            }


            /* =========================================================
               MOBILE
               ========================================================= */

            @media (max-width: 575px) {

                .spid-login-container {
                    display: block;
                }

                .spid-login-container > form:first-of-type {
                    margin-bottom: 15px;
                }
            }

        </style>



        <script src="assets/bootstrap/soop/js/jquery-3.7.1.js"></script>

        <link rel="stylesheet"
              href="assets/bootstrap/assets/css/bootstrap.min.css"/>





        <link rel="stylesheet" href="assets/resource/animate.css"/>

        <link href="assets/bootstrap/vendors/general/sweetalert2/dist/sweetalert2.css"
              rel="stylesheet"
              type="text/css" />

        <link href="assets/bootstrap/vendors/general/socicon/css/socicon.css"
              rel="stylesheet"
              type="text/css" />

        <link href="assets/bootstrap/vendors/custom/vendors/line-awesome/css/line-awesome.css"
              rel="stylesheet"
              type="text/css" />

        <link href="assets/bootstrap/vendors/custom/vendors/flaticon/flaticon.css"
              rel="stylesheet"
              type="text/css" />

        <link href="assets/bootstrap/vendors/custom/vendors/flaticon2/flaticon.css"
              rel="stylesheet"
              type="text/css" />

        <link href="assets/bootstrap/vendors/custom/vendors/fontawesome5/css/all.min.css"
              rel="stylesheet"
              type="text/css" />

        <link href="assets/css/global/global.css"
              rel="stylesheet"
              type="text/css" />




        <script type="text/javascript"
        src="assets/bootstrap/global/scripts/spid-sp-access-button.min.js"></script>


        <link type="text/css"
              rel="stylesheet"
              href="assets/bootstrap/global/css/spid-sp-access-button.min.css" />

        <script src="assets/bootstrap/global/scripts/spid-idps.js"></script>



        <style>

            .spid-login-container {
                position: relative;
                overflow: visible !important;
            }



            #spid-idp-button-medium-post {
                position: absolute !important;

                left: 0 !important;
                right: 0 !important;

                top: 100% !important;

                width: 100% !important;

                z-index: 99999 !important;

                margin: 0 !important;
                padding: 0 !important;

                overflow: visible !important;
            }


            #spid-idp-list-medium-root-post {
                position: absolute !important;

                left: 0 !important;
                right: 0 !important;

                width: 100% !important;

                z-index: 100000 !important;

                margin: 0 !important;

                overflow: visible !important;
            }



            main,
            .container,
            .row,
            .col-lg-5,
            .spid-login-container {
                overflow: visible;
            }



            footer {
                position: relative;
                z-index: 1;
            }


            #spid-idp-button-medium-post,
            #spid-idp-list-medium-root-post {
                z-index: 999999 !important;
            }

        </style>

    </head>


    <body class="d-flex flex-column min-vh-100">


        <%@include file="page/admin/Header.jsp" %>

        <br>



        <main class="flex-grow-1 d-flex align-items-center justify-content-center bg-white">

            <div class="container">

                <div class="row justify-content-center">

                    <div class="col-lg-5 col-md-8">

                        <!-- =====================================================
                             LOGIN CLASSICO
                             ===================================================== -->
                        <div class="it-card-wrapper">

                            <div class="it-card">

                                <div class="it-card-body">

                                    <form action="LoginServlet"
                                          method="POST"
                                          onsubmit="return ctrlForm();">

                                        <input type="hidden"
                                               name="isLogin"
                                               value="true"/>


                                        <div class="form-group mb-3">

                                            <label for="user">
                                                Username
                                            </label>

                                            <input type="text"
                                                   class="form-control"
                                                   id="user"
                                                   name="username"
                                                   autocomplete="off">

                                        </div>


                                        <br>


                                        <div class="form-group mb-3">

                                            <label for="password">
                                                Password
                                            </label>

                                            <input type="password"
                                                   class="form-control"
                                                   id="password"
                                                   name="password"
                                                   autocomplete="off">

                                        </div>


                                        <div class="d-flex justify-content-between mb-3">

                                            <a href="faq.jsp"
                                               class="it-link">
                                                FAQ
                                            </a>

                                            <a href="javascript:;"
                                               id="kt_login_forgot"
                                               class="it-link">
                                                Password dimenticata?
                                            </a>

                                        </div>


                                        <button type="submit"
                                                class="btn btn-primary it-btn w-100">
                                            Login
                                        </button>

                                    </form>

                                </div>


                                <div class="it-card-footer text-center">

                                    <a href="javascript:void(0);"
                                       onclick="document.getElementById('manform').submit();"
                                       class="it-link">

                                        <span class="icon">
                                            <i class="fa fa-file-pdf text-danger"></i>
                                        </span>

                                        Guida all'uso della piattaforma

                                    </a>

                                </div>

                            </div>

                        </div>


                        <!-- =====================================================
                             SPID + CIE
                             ===================================================== -->

                        <div class="w-lg-500px bg-body rounded shadow-sm p-10 p-lg-15 mx-auto spid-login-container">


                            <!-- ================= SPID ================= -->

                            <form class="form w-100"
                                  novalidate="novalidate"
                                  id="kt_sign_in_form"
                                  action="Spid"
                                  method="POST">

                                <input type="hidden"
                                       name="entity_id"
                                       id="entity_id"
                                       value="" />

                                <input type="hidden"
                                       name="provider"
                                       id="provider"
                                       value="" />


                                <a href="#"
                                   class="btn btn-lg w-100 mb-5 italia-it-button italia-it-button-size-m button-spid"
                                   spid-idp-button="#spid-idp-button-medium-post"
                                   aria-haspopup="true"
                                   aria-expanded="false">

                                    <span class="italia-it-button-icon">

                                        <img src="img/spid-ico-circle-bb.svg"
                                             onerror="this.src='img/spid-ico-circle-bb.png'; this.onerror=null;"
                                             alt="" />

                                    </span>

                                    <span class="italia-it-button-text">
                                        Entra con SPID
                                    </span>

                                </a>



                                <div id="spid-idp-button-medium-post"
                                     class="spid-idp-button spid-idp-button-tip spid-idp-button-relative">

                                    <ul id="spid-idp-list-medium-root-post"
                                        class="spid-idp-button-menu"
                                        data-spid-remote
                                        aria-labelledby="spid-idp">
                                    </ul>

                                </div>

                            </form>


                            <!-- ================= CIE ================= -->

                            <form action="AuthServlet"
                                  method="POST">

                                <input type="image"
                                       src="img/entra_con_cie.svg"
                                       alt="Login with CIE"
                                       style="padding: 4px;">

                                <input type="hidden"
                                       id="cie"
                                       name="cie"
                                       value="">

                            </form>

                        </div>

                    </div>

                </div>

            </div>

        </main>


        <%@include file="page/admin/footer.jsp" %>




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

                                                   $("#drop_login").trigger('click');

                                                   return false;
                                               }


                                               swal.fire({
                                                   title: 'Sto Accedendo...',
                                                   text: '',
                                                   onOpen: function () {
                                                       swal.showLoading();
                                                   }
                                               });


                                               return true;
                                           }

        </script>


        <script>

            var KTAppOptions = {

                "colors": {

                    "state": {

                        "brand": "#5d78ff",
                        "dark": "#282a3c",
                        "light": "#ffffff",
                        "primary": "#5867dd",
                        "success": "#34bfa3",
                        "info": "#36a3f7",
                        "warning": "#ffb822",
                        "danger": "#fd3995"

                    },

                    "base": {

                        "label": [
                            "#c5cbe3",
                            "#a1a8c3",
                            "#3d4465",
                            "#3e4466"
                        ],

                        "shape": [
                            "#f0f3ff",
                            "#d9dffa",
                            "#afb4d4",
                            "#646c9a"
                        ]

                    }

                }

            };

        </script>


        <script type="text/javascript"
        src="assets/bootstrap/soop/js/jquery.fancybox.min.js"></script>

        <script type="text/javascript"
        src="assets/bootstrap/soop/js/fancy.js"></script>

        <script src="assets/bootstrap/vendors/general/bootstrap/dist/js/bootstrap.min.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/vendors/general/js-cookie/src/js.cookie.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/soop/js/moment.min.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/vendors/general/tooltip.js/dist/umd/tooltip.min.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/vendors/general/jquery-form/dist/jquery.form.min.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/vendors/general/perfect-scrollbar/dist/perfect-scrollbar.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/vendors/general/sticky-js/dist/sticky.min.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/demo/default/base/scripts.bundle.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/vendors/general/sweetalert2/dist/sweetalert2.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/app/custom/login/login-general.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/app/bundle/app.bundle.js"
        type="text/javascript"></script>

        <script src="assets/bootstrap/vendors/base/vendors.bundle.js"
        type="text/javascript"></script>


        <!-- =========================================================
             PASSWORD RECOVERY
             ========================================================= -->

        <script type="text/javascript">

            function ctrlEmail() {

                var err = true;

                var email = $('#email');

                if (checkValue(email, false)) {
                    err = false;
                }

                return err;
            }


            $("#submit_pwd").on('click', function () {

                if (ctrlEmail()) {

                    showLoad();

                    $('#kt_form_pwd').ajaxSubmit({

                        error: function () {

                            closeSwal();

                            swal.fire({

                                "title": 'Errore',

                                "text": "Riprovare, se l'errore persiste contattare il servizio clienti",

                                "type": "error",

                                cancelButtonColor: "#3a2c7a",

                                cancelButtonClass: "btn btn-io-n"

                            });

                        },

                        success: function (resp) {

                            var json = JSON.parse(resp);

                            closeSwal();


                            if (json.result) {

                                swalSuccessReload(
                                        "Password cambiata con successo!",
                                        "Hai ricevuto una mail al tuo indirizzo contenente la nuova password da modificare al prossimo accesso"
                                        );

                            } else {

                                $('#email').attr(
                                        "class",
                                        "form-control is-invalid"
                                        );


                                swal.fire({

                                    "title": '<h3><b>Errore!</b></h3>',

                                    "html": "<h5>" + json.messagge + "</h5>",

                                    "type": "error",

                                    cancelButtonClass: "btn btn-io-n"

                                });

                            }

                        }

                    });

                }

            });

        </script>


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

            swal.fire({
                type: 'error',
                title: 'Credenziali errate',
                confirmButtonColor: '#363a90'
            });

            <%
            } else if (esito.equals("banned")) {
            %>

            swal.fire({
                type: 'error',
                title: 'Utenza bloccata',
                confirmButtonColor: '#363a90'
            });

            <%
                }
            %>


            function clickLink(link, target) {

                var a = document.createElement('a');

                a.href = link;
                a.target = target;

                document.body.appendChild(a);

                a.click();

                a.remove();
            }

        </script>


        <!-- =========================================================
             SPID
             ========================================================= -->

        <script>

            $(document).ready(function () {

                $('#spid-idp-list-medium-root-post').on(
                        'click',
                        '.spid-idp-button-link',
                        function () {

                            var selectedValue = $(this).data('idp');

                            $('#entity_id').val(selectedValue);

                            console.log(
                                    'Entity ID selezionato:',
                                    selectedValue
                                    );


                            var selectedValue2 =
                                    $(this)
                                    .find('.spid-idp-button-logo')
                                    .attr('alt');


                            $('#provider').val(selectedValue2);

                            console.log(
                                    'Provider selezionato:',
                                    selectedValue2
                                    );

                        }
                );

            });

        </script>


    </body>

</html>
