<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="dashboard_Default" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">
    <title>Welcome G5POS | Close Order</title>
    <link href="../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/animate.css" rel="stylesheet" type="text/css" />
    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/style.css" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript">window.history.forward(); function noBack() { window.history.forward(); }</script>
</head>
<body onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">

    <div style="display: none;" class="preloader">
        <i class="fa fa-spinner fa-spin"></i> <br /> Please wait...
    </div>

    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/webpos.asmx" />
        </Services>
    </asp:ScriptManager>
    </form>
    
    <div class="top-bar">
    <div class="container-fluid">
        <div class="row">
            <div class="col-sm-12">
                <h4>Table No.: </h4>
            </div>
        </div>
    </div>
    </div>
    

    <div class="container-fluid" style="margin-top: 10px;">
        <div class="row">
            <div class="col-sm-4">
               
               <table class="table" style="font-weight: bolder; line-height: 4em;">
                    <tr><td width="50%" style="line-height:4;">Sub Total</td><th width="50%" align="right"></th></tr>
                    <tr><td width="50%" style="line-height:4;">Service</td><th width="50%" align="right"></th></tr>
                    <tr><td width="50%" style="line-height:4;">Tax 1</td><th width="50%" align="right"></th></tr>
                    <tr><td width="50%" style="line-height:4;">Tax 2</td><th width="50%" align="right"></th></tr>
                    <tr><td width="50%" style="line-height:4;">Tax 3</td><th width="50%" align="right"></th></tr>
               </table>

            </div>
            <div class="col-sm-3">
                Load Keypad
            </div>
            <div class="col-sm-5">
                
                <ul id="paymentTypeList" class="list-group">
                </ul>

            </div>
        </div>
    </div>

    
    <script src="../js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap.min.js" type="text/javascript"></script>
    <script src="../js/controllers/order-close.js" type="text/javascript"></script>
</body>
</html>
