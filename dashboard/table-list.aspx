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
    
    <style type="text/css">
        html, body
        {
            height: 100%;
        }
        body
        {
            line-height: 1.5;
        }
        .btn-flat
        {
            border-radius: 0px;
            }
        .top-bar
        {
            background-color: rgba(24,93,135,1);
            color: #fff;
            padding: 10px 0px;
        }
        
        .top-bar a
        {
            color: #fff;
        }
        
        .tables-list
        {
            height: 86vh;
            padding: 6px 20px 20px 20px;
            overflow: auto;
            border-right: 1px solid #BBBBBB;
        }
        
        .table-box
        {
            display: block;
            background-color: #f9f9f9;
            padding: 4px;
            color: #000;
            border: 1px solid #CCCCCC;
            border-radius: 4px;
            box-shadow: 0px 4px 8px #DADADA;
            margin-bottom: 20px;
        }
        
        .table-box.open
        {
            background-color: #f9f9f9;
            color: #000;
        }
        
        .table-box.others
        {
            background-color: #D00000;
            color: #fff;
        }
       
        .table-box.lock
        {
            background-color:red;
            color: #fff;
        }
         .table-box.printed
        {
            background-color: blue;
            color: #fff;
        } 
        .table-box.self
        {
            background-color: green;
            color: #fff;
        }
        
        .table-box.busy footer a, .table-box.done footer a
        {
            color: #fff;
        }
        
        .table-no
        {
            position: absolute;
            right: 20px;
            top: 0px;
            opacity: .5;
            font-size: 2em;
            font-weight: bolder;
            font-family: 'Arial Black' , Verdana, Sans-Serif;
        }
        .table-no:after
        {
            font-family: 'FontAwesome';
            content: '\f0f5';
            display: block;
            font-size: 12px;
            text-align: center;
            opacity: .4;
        }
        dl
        {
            margin-bottom: 0px;
        }
        dl dt
        {
            float: left;
            font-weight: bold;
            width: 72px;
        }
        
        dl dd:before
        {
            content: ':';
            padding-right: 10px;
        }
        
        dl dd
        {
            margin: 2px 0;
        }
        
       
        
        .numpad-list
        {
            display: flex;
            flex-wrap: wrap;
            
             display: -webkit-flex;
            -webkit-flex-wrap: wrap;
            
            margin: 0 -4px -4px 0;
            list-style: none;
            padding: 0;
            width: 100%;
        }
        .numpad-list li
        {
            
             
            height: 100px;
            border-right: 1px solid #3e3e3e;
            border-bottom: 1px solid #6B6B6B;
            
            background: #3E3E3E; /* For browsers that do not support gradients */
            background: -webkit-linear-gradient(#3E3E3E, #080808); /* For Safari 5.1 to 6.0 */
            background: -o-linear-gradient(#3E3E3E, #080808); /* For Opera 11.1 to 12.0 */
            background: -moz-linear-gradient(#3E3E3E, #080808); /* For Firefox 3.6 to 15 */
            background: linear-gradient(#3E3E3E, #080808); /* Standard syntax */ 
            color: #fff;
            
            flex: 1 0 26%;
             -webkit-flex: 1 0 26%;
            
            display: flex;
            align-items: center;
            justify-content: center;
            
            display: -webkit-flex;
            -webkit-align-items: center;
            -webkit-justify-content: center;
            
            font-size: 2em;
            cursor: pointer;
        }
        
         .numpad-list li span
         {
            display: block;
            background-color: transparent;
            color: #fff;
         }
             
             
        
        .numpad-list li:hover
        {
             background: #3E3E3E; /* For browsers that do not support gradients */
            background: -webkit-linear-gradient(#080808, #3E3E3E); /* For Safari 5.1 to 6.0 */
            background: -o-linear-gradient(#080808, #3E3E3E); /* For Opera 11.1 to 12.0 */
            background: -moz-linear-gradient(#080808, #3E3E3E); /* For Firefox 3.6 to 15 */
            background: linear-gradient(#080808, #3E3E3E); /* Standard syntax */
            color: #fff;
            cursor: pointer;
            text-decoration: none;
            
            }
        
        .modal-backdrop.fade.in
        {
            z-index: 0;
            }
            
            .new-table, .new-no-customers
            {
                margin-right: 4px;
                }
    </style>
    <script type="text/javascript">        window.history.forward(); function noBack() { window.history.forward(); }</script>
</head>
<body onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">
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
                    | <a href="#" class="logout"><i class="fa fa-sign-out"></i> <%= Translator.getCode("Logout")%></a>
                </div>
            </div>
        </div>
    </div>
   

    <div class="container-fluid">
        <div class="row">
            
            <div class="col-xs-offset-3 col-xs-6">
                <br />
               <a href="../dashboard" class="btn btn-primary btn-flat btn-lg btn-block"><%= Translator.getCode("Back")%></a>
            </div>

        </div>
        <div class="row">
            <div class="col-sm-12 text-right">
                <small class="counter"></small>
            </div>
            <div class="col-sm-12 tables-list" dir="ltr">
            </div>
        </div>

        

    </div>

    <div class="modal fade" id="errMsgModal" tabindex="-1" role="dialog">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalLabel"><%= Translator.getCode("Message")%></h4>
          </div>
          <div class="modal-body">
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal"><%= Translator.getCode("Close")%></button>
            <button type="button" class="btn btn-primary btn-refresh"><i class="fa fa-repeat"></i> <%= Translator.getCode("RefreshTable")%></button>
          </div>
        </div>
      </div>
    </div>
    
    <script src="../js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap.min.js" type="text/javascript"></script>
    <script>
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
