<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" Culture="auto:en-US" UICulture="auto" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Welcome G5POS</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link rel="shortcut icon" type="image/x-icon" href="images/favicon-32x32.png" />
    <link href="css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="css/animate.css" rel="stylesheet" type="text/css" />
    <style>
        html, body
        {
            height: 100%;
        }
        body
        {
            background-image: url('images/login-bg.jpg');
            background-repeat: no-repeat;
            background-position: 40% 54%;
            background-size: cover;
            font-family: Arial, Verdana, Sans-Serif;
        }
        
        .wrapper
        {
            display: flex;
            justify-content: center;
            align-items: center;
            
            display: -webkit-flex;
            -webkit-justify-content: center;
            -webkit-align-items: center;
            height: 100%;
        }
        .wrapper .panel.login
        {
            margin-top: 10px;
            box-shadow: 0px 0px 10px #848484;
        }
        
        .wrapper .panel.login, .wrapper .panel .panel-footer
        {
            background-color: rgba(255, 255, 255, 0.8);
        }
        
        .wrapper .panel .panel-footer
        {
            font-size: 11px;
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
        
    </style>
    
    <script type="text/javascript">window.history.forward(); function noBack() { window.history.forward(); }</script>

</head>
<body onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">

    <form name="form1" runat="server">

         <div style="position: fixed; right: 10px; top: 10px; z-index: 100; ">
             <asp:DropDownList ID="ddlLang" runat="server" CssClass="form-control" AutoPostBack="true">
                 <asp:ListItem Value="en-US" Text="English"></asp:ListItem>
                 <asp:ListItem Value="ar" Text="عربي"></asp:ListItem>
             </asp:DropDownList>
         </div>
        
    </form>
    
    <div class="wrapper animated fadeIn">
        <div class="col-md-6 col-sm-8 col-xs-10">
            <center class="animated fadeInDown">
                <img class="img-responsive" src="images/G5-Logo.png" alt="" />
            </center>

            <div style="background-color: rgba(255, 255, 255, 0.8); padding: 4px; ">
               
                    <input type="hidden" name="BranchID" id="BranchID" value="1" />
                    
                    <div class="form-group form-group-lg userid">
                        <label class="text-uppercase"><%= Translator.getCode("UserID")%></label>
                        <input type="text" id="Username" name="Username" class="form-control"  placeholder='<%= Translator.getCode("UsernamePH")%>' readonly />
                    </div>

                    <div class="form-group form-group-lg password" style="display: none;">
                        <label class="text-uppercase"><%= Translator.getCode("Password")%></label>
                        <input type="password" id="Password" name="Password" class="form-control disabled" placeholder="<%= Translator.getCode("PasswordPH")%>" readonly />
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

           
            <div id="errMsg" runat="server" class="alert alert-danger" style="display: none" role="alert">
            </div>
        </div>
    </div>
    <script src="js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        var _userError = '<%= Translator.getCode("ErrMsgUser")%>';
        var _passwordError = '<%= Translator.getCode("ErrMsgPassword")%>';
        var _pageType = '<%= Session("lang") %>';
        $(document).ready(function () {
            if (_pageType === 'ar') {
                $("html").attr("dir", "rtl");
            }
        });
        
    </script>
    <script src="js/controllers/login.js" type="text/javascript"></script>
</body>
</html>
