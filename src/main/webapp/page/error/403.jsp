
<%@page import="Utility.Utils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%

    String src2 = Utils.checkAttribute(session, "src");
    String src = src2 == null ? "" : src2 + "/";
%>
<html>
    <!-- begin::Head -->
 
    <head>
        <meta charset="utf-8" />
        <title>YES I START UP - TOSCANA</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />
        <!-- BOOTSTRAP COMUNI E FONT TITILLIUM WEB -->
        <link rel="stylesheet" href="../../assets/bootstrap/assets/css/bootstrap.css"/>
        <link rel="stylesheet" href="../../assets/css/global/global.css"/>
        <link href='https://fonts.googleapis.com/css?family=Titillium Web' rel='stylesheet'>
        <!-- FINE BOOTSTRAP COMUNI E FONT TILLIUM WEB -->

        <!-- BEGIN GLOBAL MANDATORY STYLES -->
        <link href="../../assets/bootstrap/soop/fontg/fontsgoogle1.css" rel="stylesheet" type="text/css" />
        <link href="../../assets/bootstrap/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="../../assets/bootstrap/global/plugins/simple-line-icons/simple-line-icons.min.css" rel="stylesheet" type="text/css" />
        <link href="../../assets/bootstrap/global/plugins/bootstrap-switch/css/bootstrap-switch.min.css" rel="stylesheet" type="text/css" />
        <!-- END GLOBAL MANDATORY STYLES -->
        <!-- BEGIN THEME GLOBAL STYLES -->
        <link href="../../assets/bootstrap/global/css/components.min.css" rel="stylesheet" id="style_components" type="text/css" />
        <link href="../../assets/bootstrap/global/css/plugins.min.css" rel="stylesheet" type="text/css" />
        <!-- END THEME GLOBAL STYLES -->
        <!-- BEGIN PAGE LEVEL STYLES -->
        <!--link href="assets/pages/css/error.min.css" rel="stylesheet" type="text/css" /-->      
        <link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
        <link href="resource/custom.css" rel="stylesheet" type="text/css" />
    </head>
    <body class="text-center">
        <br>
        <div class="container" style="min-height: 50%">
            <div class="col">
                <div class="row">
                    <div class="container">
                        <center>
                            <img src="assets/media/logos/enmc.png" alt="logo" style="max-width: 100%; height: 150px;"/>
                        </center>
                    </div>
                </div>
                <hr>
                <hr>
                <div class="row">
                    <div class="container">
                        <h1 class="text" style="font-size: 120px"><b> 404 </b></h1>
                        <hr>
                        <hr>
                        <h3 class="text"><b class="text-danger">Attenzione.</b> Non si dispone dei permessi necessari per accedere alla pagina.</h3>
                    </div>
                </div>
                <hr>
                <div class="row">
                    <p class="pull-right">
                        <button onclick="return history.back();" class="btn btn-primary"><i class="fa fa-arrow-left"></i> Indietro </button>
                        <button onclick="self.close();" class="btn btn-danger" id="clbtn"><i class="fa fa-times"></i> Chiudi </button>
                    </p>
                </div>
            </div>
        </div>

        <!--[if lt IE 9]>
    <script src="assets/global/plugins/respond.min.js"></script>
    <script src="assets/global/plugins/excanvas.min.js"></script> 
    <![endif]-->
        <!-- BEGIN CORE PLUGINS -->
        <script src="../../css/theme/bootstrap/global/plugins/jquery.min.js" type="text/javascript"></script>
        <script src="../../css/theme/bootstrap/assets/js/bootstrap-italia.bundle.min.js" type="text/javascript"></script>
        <script src="../../css/theme/bootstrap/global/plugins/js.cookie.min.js" type="text/javascript"></script>
        <script src="../../css/theme/bootstrap/global/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js" type="text/javascript"></script>
        <script src="../../css/theme/bootstrap/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
        <script src="../../css/theme/bootstrap/global/plugins/jquery.blockui.min.js" type="text/javascript"></script>
        <script src="../../css/theme/bootstrap/global/plugins/bootstrap-switch/js/bootstrap-switch.min.js" type="text/javascript"></script>
        <!-- END CORE PLUGINS -->
        <!-- BEGIN THEME GLOBAL SCRIPTS -->
        <script src="../../css/theme/bootstrap/global/scripts/app.min.js" type="text/javascript"></script>
        <!-- END THEME GLOBAL SCRIPTS -->
        <!-- BEGIN THEME LAYOUT SCRIPTS -->
        <!-- END THEME LAYOUT SCRIPTS -->
    </body>
</html>