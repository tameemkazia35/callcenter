<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="dashboard_Default" Culture="auto:en-US" UICulture="auto"  %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">
    <title>Welcome G5POS | Order</title>
    <link href="../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/animate.css" rel="stylesheet" type="text/css" />
    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../css/style.css" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript">window.history.forward(); function noBack() { window.history.forward(); }</script>
</head>
<body onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">

    <div style="display: none;" class="preloader">
        <i class="fa fa-spinner fa-spin"></i> <br>  <%= Translator.getCode("PleaseWait")%>
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
                <div class="col-xs-6">
                    <%= Translator.getCode("TableNo")%>. : <span class="tableno"></span>
                </div>
                <div class="col-xs-6 text-right">
                    <a href="#" class="btn-home"><i class="fa fa-home"></i> <%= Translator.getCode("Home") %></a> | <%= Translator.getCode("Welcome")%>, <i class="fa fa-user">
                    </i><strong><span class="empName"></span></strong>| <a href="#" class="logout"><i
                        class="fa fa-sign-out"></i> <%= Translator.getCode("Logout")%></a>
                </div>
            </div>
        </div>
    </div>
    <div id="orderPanel" dir="ltr">
        <!-- left panel -->
        <div id="leftPanel">
            <div class="top">
                <table class="table items">
                    <thead>
                        <tr>
                            <th width="05%">
                            </th>
                            <th width="05%">
                                <%= Translator.getCode("Qty")%>
                            </th>
                            <th width="55%">
                                <%= Translator.getCode("Name")%>
                            </th>
                            <th width="18%" class="text-center">
                                <%= Translator.getCode("Price")%>
                            </th>
                            <th width="05%" class="text-left">
                                <%= Translator.getCode("Void")%>
                            </th>
                            <th width="10%" class="text-left">
                                <%= Translator.getCode("Status")%>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div class="mid">
                <table class="table">
                    <tfoot>
                        <tr>
                            <th width="52%" class="text-right">
                                 <%= Translator.getCode("Total")%>
                            </th>
                            <th width="20%" class="text-right total-price">
                                0.00
                            </th>
                            <th width="20%">
                                 <%= Translator.getCode("AED")%>
                            </th>
                        </tr>
                         <tr>
                            <td width="50%">
                                <%= Translator.getCode("Guest")%> : <strong class="guestname"></strong>
                            </td>
                            <td width="50%">
                                <%= Translator.getCode("GuestCount")%> : <strong class="guestcount"></strong>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
            <div class="bottom">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <select id="wsList" name="wsList" class="form-control">
                                <option value="0">--<%= Translator.getCode("SelectWS")%>--</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <select id="ddlPayType" name="ddlPayType" class="form-control">
                                <option value="0">--Select PayTpe--</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                
            </div>
        </div>
        <!-- Right panel -->
        <div style="width: 55%; height: 100%; max-height: 100%; overflow: hidden; padding-left: 4px;">
            <div class="input-group hide">
                <input type="search" class="form-control" placeholder="Search" />
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
            </div>

            <div id="groupList">
            </div>

            <div id="itemsList" style="display: none;">
            </div>

            <div id="remarksList" style="display: none;">
            </div>

        </div>
    </div>
    <!-- -->
    <footer dir="ltr">
        <div class="btn-group btn-group-justified" role="group">
           <div class="btn-group hide" role="group">
                <button type="button" id="btn-more" class="btn btn-primary" data-toggle="modal" data-target="#moreFunctions">
                    <i class="fa fa-tasks fa-fw"></i> <%= Translator.getCode("More")%></button>
            </div>
            <div class="btn-group" role="group">
                <button id="btnOrder" type="button" class="btn btn-danger">
                    <i class="fa fa-cutlery fa-fw"></i> <%= Translator.getCode("Order")%></button>
            </div>
            <div class="btn-group" role="group">
                <button id="btnPrint" type="button" class="btn btn-info">
                    <i class="fa fa-print fa-fw"></i> <%= Translator.getCode("Print")%></button>
            </div>
            <div class="btn-group hide" role="group">
                <button id="btnCloseOrder" type="button" class="btn btn-success">
                    <i class="fa fa-cutlery fa-fw"></i> <%= Translator.getCode("Close")%></button>
            </div>

            <div class="btn-group" role="group">
                <button id="btnMainScreen" type="button" class="btn btn-warning">
                    <i class="fa fa-list fa-fw"></i> <%= Translator.getCode("MainScreen")%></button>
            </div>

            <div class="btn-group" role="group">
                <button class="btn btn-primary btn-home">
                    <i class="fa fa-home fa-fw"></i> <%= Translator.getCode("Home")%></button>
            </div>
        </div>
    </footer>

    <!-- More Features -->
    <div class="modal fade bs-example-modal-lg" id="moreFunctions" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">
                        <i class="fa fa-clone"></i><%= Translator.getCode("Functions")%></h4>
                </div>
                <div class="modal-body">
                    <div>
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active"><a href="#covers" aria-controls="home" role="tab"
                                data-toggle="tab"><%= Translator.getCode("Covers")%></a></li>
                            <li role="presentation" class="hide"><a href="#guest" aria-controls="profile" role="tab"
                                data-toggle="tab"><%= Translator.getCode("Guest")%></a></li>
                            <li role="presentation" class="hide"><a href="#itemTransfer" aria-controls="messages"
                                role="tab" data-toggle="tab">Item Transfer</a></li>
                            <li role="presentation"><a href="#kitchenRemarks" aria-controls="settings" role="tab"
                                data-toggle="tab"><%= Translator.getCode("KitchenRemark")%></a></li>
                            <li role="presentation"><a href="#billRemarks" aria-controls="settings" role="tab"
                                data-toggle="tab"><%= Translator.getCode("BillRemark")%></a></li>
                        </ul>
                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div role="tabpanel" class="tab-pane active" id="covers">
                                <div class="form-group">
                                    <label>
                                        <%= Translator.getCode("NoOfGuest")%></label>
                                    <div class="input-group">
                                        <div class="input-group-addon">
                                            <i class="fa fa-users fa-fw"></i>
                                        </div>
                                        <input type="number" id="tableCovers" name="tableCovers" class="form-control" placeholder='<%= Translator.getCode("EnterNoCust")%>' />
                                        <div class="input-group-addon">
                                            <a href="#" id="updateCustNo"><%= Translator.getCode("Update")%></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="guest">
                                Guest section coming soon...
                            </div>
                            <div role="tabpanel" class="tab-pane" id="itemTransfer">
                                Item Transfer section coming soon...
                            </div>
                            <div role="tabpanel" class="tab-pane" id="kitchenRemarks">
                                <div class="form-group">
                                    <label>
                                       <%= Translator.getCode("KitchenRemark")%></label>
                                    <textarea id="txtKitchenRemarks" class="form-control" placeholder></textarea>
                                </div>
                                <button id="btnKitchenRemarks" class="btn btn-primary">
                                    <%= Translator.getCode("Update")%></button>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="billRemarks">
                                <div class="form-group">
                                    <label>
                                        <%= Translator.getCode("BillRemark")%></label>
                                    <textarea id="txtBillRemarks" class="form-control" placeholder></textarea>
                                </div>
                                <button id="btnBillRemarks" class="btn btn-primary">
                                    <%= Translator.getCode("Update")%></button>
                            </div>
                            <div class="alert hide alert-success" id="divSucess" role="alert">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Item Details -->
    <div class="modal fade bs-example-modal-lg" id="itemAdd" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">
                        <i class="fa fa-clone"></i><%= Translator.getCode("Item")%></h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                       <%= Translator.getCode("ItemInfo")%></h4>
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-sm-8">
                                            <input type="hidden" id="newItemSalesID" />
                                            <h3 id="newItemTitle">
                                            </h3>
                                        </div>
                                        <div class="col-sm-4">
                                            <small><%= Translator.getCode("Price")%></small>
                                            <h3 id="newItemPrice">
                                            </h3>
                                            <small><%= Translator.getCode("AED")%></small>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <label>
                                                <%= Translator.getCode("Qty")%></label>
                                            <div class="input-group qty-controller">
                                                <span class="input-group-addon"><i class="fa fa-plus fa-fw"></i></span>
                                                <input type="text" value="1" class="form-control text-center" />
                                                <span class="input-group-addon"><i class="fa fa-minus fa-fw"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                       <%= Translator.getCode("ItemRemark")%></h4>
                                </div>
                                <div class="panel-body">
                                    <textarea id="txtItemRemarks" class="form-control" rows="3" placeholder="Enter item remarks here..."></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="btn-group btn-group-justified" role="group">
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-primary" id="btnUpdateItem">
                                <i class="fa fa-pencil fa-fw"></i><%= Translator.getCode("Update")%></button>
                        </div>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-danger" data-dismiss="modal" aria-label="Close">
                                <i class="fa fa-close fa-fw"></i><%= Translator.getCode("Close")%></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Modifier Modal -->
    <div class="modal fade" id="modifierModal4" tabindex="-1" role="dialog" aria-labelledby="modifierModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="H3">
                        <%= Translator.getCode("Mod")%></h4>
                </div>
                <div class="modal-body">
                    <table>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-done">
                        <%= Translator.getCode("Done")%></button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <%= Translator.getCode("Close")%></button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modifierModal3" tabindex="-1" role="dialog" aria-labelledby="modifierModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="H2">
                        <%= Translator.getCode("Mod")%></h4>
                </div>
                <div class="modal-body">
                    <table>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-done">
                        <%= Translator.getCode("Done")%></button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <%= Translator.getCode("Close")%></button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modifierModal2" tabindex="-1" role="dialog" aria-labelledby="modifierModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="H1">
                        <%= Translator.getCode("Mod")%></h4>
                </div>
                <div class="modal-body">
                    <table>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-done">
                        <%= Translator.getCode("Done")%></button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <%= Translator.getCode("Close")%></button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modifierModal1" tabindex="-1" role="dialog" aria-labelledby="modifierModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="modifierModal">
                        <%= Translator.getCode("Mod")%></h4>
                </div>
                <div class="modal-body">
                    <table>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-done">
                        <%= Translator.getCode("Done")%></button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <%= Translator.getCode("Close")%></button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Function to Open -->
    <div class="modal fade" id="openFunction" tabindex="-1" role="dialog" aria-labelledby="openFunction">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title"><%= Translator.getCode("OpenPrice")%></h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <input id="foPrice" type="text" class="form-control input-lg" disabled/>
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
                        <li data-value="0"><span>0</span></li>
                        <li data-value="."><span>.</span></li>
                        <li data-value="00"><span>00</span></li>
                        <li data-value="back"><span class="fa fa-backward"></span></li>
                        <li data-value="clear"><span class="fa fa-close"></span></li>
                        <li data-value="ok"><span>OK</span></li>
                    </ul>
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
    </div>


    <script src="../js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap.min.js" type="text/javascript"></script>
     <script>
       
         var _pageType = '<%= Session("lang") %>';
         $(document).ready(function () {
             if (_pageType === 'ar') {
                 $("html").attr("dir", "rtl");
             }
         });
    </script>
    <script src="../js/controllers/delivery-order.js" type="text/javascript"></script>
</body>
</html>
