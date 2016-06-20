<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="dashboard_Default" Culture="auto:en-US" UICulture="auto" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">
    <title>Welcome G5POS | Dashboard</title>
    <link href="../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/animate.css" rel="stylesheet" type="text/css" />
    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/style.css" rel="stylesheet" type="text/css" />
  
    <script type="text/javascript">window.history.forward(); function noBack() { window.history.forward(); }</script>
</head>
<body onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">
<div style="display: none;" class="preloader">
    <i class="fa fa-spinner fa-spin"></i> <br> Please wait...
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
                <div class="col-xs-12 text-right">
                    <a href="../dashboard"><i class="fa fa-home"></i> <%= Translator.getCode("Home") %></a> | <%= Translator.getCode("Welcome")%>, <i class="fa fa-user"></i> <strong><span class="empName"></span></strong>
                    | <a href="#" class="logout"><i class="fa fa-sign-out"></i>  <%= Translator.getCode("Logout")%></a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container-fluid">
        <div class="row">

            <div class="col-xs-offset-1 col-xs-10">
                 <br />
                 <div class="btn-group btn-group-lg btn-group-justified menuServiceList" role="group">
                </div>
            </div>

        </div>
    </div>

    <div class="container-fluid">
        
        <div class="row">
            <div class="col-sm-7 tables-list hide">
            </div>
            
            <div class="col-sm-offset-3 col-sm-6">

                <div id="DineIn" class="hide">

                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-6 text-center">
                            <h2>
                                <small><i class="fa fa-cutlery"></i></small>  <%= Translator.getCode("Table")%>
                            </h2>
                        </div>
                    </div>

                    <div class="form-group new-table">
                         <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-cutlery fa-fw"></i>
                            </div>
                            <input type="number" id="txtNewTable" name="txtNewTable" class="form-control input-lg" placeholder='<%= Translator.getCode("EnterTableNo")%>' readonly />
                        </div>  
                    </div>
               
                    <div class="form-group new-no-customers hide">
                       <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-users fa-fw"></i>
                            </div>
                            <input type="number" id="txtNoCustomers" name="txtNoCustomers" class="form-control input-lg" placeholder='<%= Translator.getCode("EnterNoCust")%>' readonly />
                        </div>
                   </div>
                
                    <ul class="numpad-list" dir="ltr">
                        <li data-value="1"><span>1</span></li>
                        <li data-value="2"><span>2</span></li>
                        <li data-value="3"><span>3</span></li>
                        <li data-value="4"><span>4</span></li>
                        <li data-value="5"><span>5</span></li>
                        <li data-value="6"><span>6</span></li>
                        <li data-value="7"><span>7</span></li>
                        <li data-value="8"><span>8</span></li>
                        <li data-value="9"><span>9</span></li>
                        <li data-value="clear"><span>X</span></li>
                        <li data-value="0"><span>0</span></li>
                        <li data-value="ok"><span>OK</span></li>
                    </ul>

                </div>

                <div id="DriveThru" class="hide">

                    <div class="row">
                        <div class="col-sm-offset-3 col-sm-6 text-center">
                            <h2>
                                <small><i class="fa fa-cutlery"></i></small>  <%= Translator.getCode("DriveThru")%>
                            </h2>
                        </div>
                    </div>

                    <div class="form-group">
                       <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-users fa-fw"></i>
                            </div>
                            <input type="number" id="txtDT_NoCustomers" name="txtDT_NoCustomers" class="form-control input-lg" placeholder='<%= Translator.getCode("EnterNoCust")%>' readonly />
                        </div>
                   </div>
                
                    <ul class="numpad-list" dir="ltr">
                    <li data-value="1"><span>1</span></li>
                    <li data-value="2"><span>2</span></li>
                    <li data-value="3"><span>3</span></li>
                    <li data-value="4"><span>4</span></li>
                    <li data-value="5"><span>5</span></li>
                    <li data-value="6"><span>6</span></li>
                    <li data-value="7"><span>7</span></li>
                    <li data-value="8"><span>8</span></li>
                    <li data-value="9"><span>9</span></li>
                    <li data-value="clear"><span>X</span></li>
                    <li data-value="0"><span>0</span></li>
                    <li data-value="ok"><span>OK</span></li>
                </ul>
                </div>

               
               <br />
               <button class="btn btn-primary btn-flat btn-block btn-lg btn-refresh-table"><i class="fa fa-refresh"></i> <%= Translator.getCode("Refresh")%></button>

            </div>
        </div>
        

       
    </div>

   

    <script src="../js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap.min.js" type="text/javascript"></script>
     <script type="text/javascript">
        var _trGuest = '<%= Translator.getCode("Guest")%>';
        var _trName = '<%= Translator.getCode("Name")%>';
        var _trTime = '<%= Translator.getCode("Time")%>';
        var _trServer = '<%= Translator.getCode("Server")%>';
        var _trDineIn = '<%= Translator.getCode("DineIn")%>';
        var _trDriveThru = '<%= Translator.getCode("DriveThru")%>';
        var _trRefreshMsg = '<%= Translator.getCode("RefreshMsg")%>';
        var _trRefreshSuccessMsg = '<%= Translator.getCode("RefreshSuccessMsg")%>';
        var _trRefreshErrMsg = '<%= Translator.getCode("RefreshErrMsg")%>'; 
        var _pageType = '<%= Session("lang") %>';
        
        $(document).ready(function () {
             if (_pageType === 'ar') {
                 $("html").attr("dir", "rtl");
             }
        });
    </script>
    <script src="../js/controllers/dashboard.js" type="text/javascript"></script>
</body>
</html>
