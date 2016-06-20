<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="customers_Default" %>

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
    <link href="../css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css" />
    <link href="../js/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .modal-lg
        {
            width: 94%;
            }
            th,td
            {
                font-size: 13px;
                
                }
    </style>
    <script type="text/javascript">        window.history.forward(); function noBack() { window.history.forward(); }</script>
</head>
<body onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">
    <div style="display: none;" class="preloader">
        <i class="fa fa-spinner fa-spin"></i>
        <br>
        Please wait...
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
                    <a href="../customers"><i class="fa fa-home"></i>
                        <%= Translator.getCode("Home") %></a> |
                    <%= Translator.getCode("Welcome")%>, <i class="fa fa-user"></i><strong><span class="empName">
                    </span></strong>| <a href="#" class="logout"><i class="fa fa-sign-out"></i>
                        <%= Translator.getCode("Logout")%></a>
                </div>
            </div>
        </div>
    </div>
    <div class="container-fluid">
        <form name="formUser">
        <input type="hidden" id="hfCustID" />
        <input type="hidden" id="hfLastSelectedBranch" />
        <div class="col-md-9">
            <h4>
                Customer Information</h4>
            <div class="row">
                <div class="form-group col-md-4">
                    <label>
                        First Name</label>
                    <input class="form-control" placeholder="First name" name="firstname" id="firstname"
                        required />
                </div>
                <div class="form-group col-md-4">
                    <label>
                        Family Name</label>
                    <input class="form-control" placeholder="Family name" name="familyname" id="familyname" />
                </div>
                <div class="form-group col-md-4">
                    <label>
                        Company Name</label>
                    <input class="form-control" placeholder="Company name" name="companyname" id="companyname" />
                </div>
                <div class="form-group col-md-4">
                    <label>
                        Mobile no</label>
                    <input class="form-control" placeholder="Mobile no" name="mobileno" id="mobileno"
                        autofocus autocomplete="off" required />
                </div>
                <div class="form-group col-md-4">
                    <label>
                        Home phone</label>
                    <input class="form-control" placeholder="Home phone" name="homephone" id="homephone"
                        autocomplete="off" />
                </div>
                <div class="form-group col-md-4">
                    <label>
                        Office phone</label>
                    <input class="form-control" placeholder="Office phone" name="officephone" id="officephone"
                        autocomplete="off" />
                </div>
                <div class="form-group col-md-4">
                    <label>
                        City</label>
                    <input class="form-control" placeholder="City" name="city" id="city" />
                </div>
                <div class="form-group col-md-4">
                    <label>
                        Street</label>
                    <input class="form-control" placeholder="Street" name="street" id="street" />
                </div>
                <div class="form-group col-md-4">
                    <label>
                        Building</label>
                    <input class="form-control" placeholder="Building" name="building" id="building" />
                </div>
                <div class="form-group col-md-3">
                    <label>
                        Floor</label>
                    <input class="form-control" placeholder="Floor" name="floor" id="floor" />
                </div>
                <div class="form-group col-md-3">
                    <label>
                        Zone</label>
                    <input class="form-control" placeholder="Zone" name="zone" id="zone" />
                </div>
                <div class="form-group col-md-3">
                    <label>
                        Appartment</label>
                    <input class="form-control" placeholder="Appartment" name="appartment" id="appartment" />
                </div>
                <div class="form-group col-md-3">
                    <label>
                        Near</label>
                    <input class="form-control" placeholder="Near" name="near" id="near" />
                </div>
                <div class="col-md-6">
                    <h5>
                        Primary Address</h5>
                    <div class="form-group">
                        <label>
                            Other Phone</label>
                        <input class="form-control" placeholder="Other Phone" name="otherPhone1" id="otherPhone1" />
                    </div>
                    <div class="form-group">
                        <label>
                            Fax</label>
                        <input class="form-control" placeholder="Fax" name="fax1" id="fax1" />
                    </div>
                    <div class="form-group">
                        <label>
                            Email</label>
                        <input type="email" class="form-control" placeholder="Email" name="email1" id="email1" />
                    </div>
                    <div class="form-group">
                        <label>
                            ZipCode</label>
                        <input class="form-control" placeholder="Zip Code" name="zipCode1" id="zipCode1" />
                    </div>
                </div>
                <div class="col-md-6">
                    <h5>
                        Secondary Address</h5>
                    <div class="form-group">
                        <label>
                            Other Phone</label>
                        <input class="form-control" placeholder="Other Phone" name="otherPhone2" id="otherPhone2" />
                    </div>
                    <div class="form-group">
                        <label>
                            Fax</label>
                        <input class="form-control" placeholder="Fax" name="fax2" id="fax2" />
                    </div>
                    <div class="form-group">
                        <label>
                            Email</label>
                        <input type="email" class="form-control" placeholder="Email" name="email2" id="email2" />
                    </div>
                    <div class="form-group">
                        <label>
                            ZipCode</label>
                        <input class="form-control" placeholder="Zip Code" name="zipCode2" id="zipCode2" />
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <br />
            <div class="btn-group btn-group-justified">
                <div class="btn-group"><button type="submit" id="btnSaveCustInfo" class="btn btn-primary">Save</button></div>
                <div class="btn-group"><button type="button" id="btnTakeOrder" class="btn btn-warning">Order</button></div>
                <div class="btn-group"><button type="button" id="btnOrderHistory" class="btn btn-info" data-toggle="modal" data-target=".bs-example-modal-lg">History</button></div>
                <div class="btn-group"><button type="button" id="btnReset" class="btn btn-danger">Reset</button></div>
            </div>
            
            <h4>
                Branches</h4>
            <div id="branchList" class="list-group">
            </div>
            
            
            <div class="panel panel-info">
                <div class="panel-heading">
                    <b>Delivery Details</b>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label>
                            Delivery DateTime</label>
                        <div class="input-group">
                            <input class="form-control" id="deliveryDatetime" name="deliveryDatetime" placeholder="Delivery DateTime" />
                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span>
                            </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>
                            Select Driver</label>
                        <select class="form-control" id="ddlDriver" name="ddlDriver">
                        </select>
                    </div>
                </div>
            </div>
        </div>
        </form>
    </div>
    <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                   <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"> Order History</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-12">
                            <a data-toggle="collapse" href="#collapseExample"><i class="fa fa-filter"></i> | Filter</a>
                        </div>
                    </div>
                    <div class="row collapse well" id="collapseExample">
                      
                            <div class="form-group col-md-3">
                                <label>
                                    Date:</label>
                                <button class="btn btn-default" id="daterange-btn">
                                    <i class="fa fa-calendar"></i> Date range picker <i class="fa fa-caret-down"></i>
                                </button>
                            </div>
                            <div class="form-group col-md-3">
                               <div class="input-group">
                                    <span class="input-group-addon"><i class="fa fa-phone fa-fw"></i></span>
                                    <input class="form-control" type="text" placeholder="Phone Number" id="txtFilterPhone" autofocus autocomplete="off"  />
                               </div>
                            </div>
                            <div class="form-group col-md-3">
                               <div class="input-group">
                                    <span class="input-group-addon"><i class="fa fa-car fa-fw"></i></span>
                                    <input class="form-control" type="text" placeholder="Driver Name" id="txtFilterDriver"  />
                               </div>
                                
                            </div>
                            <div class="form-group col-md-3">
                           
                                <button type="button" class="btn btn-primary" id="Search"><i class="fa fa-search"></i> Search</button>
                                | 
                                <button type="button" class="btn btn-default" id="btnSave" onclick="fnLoad()"><i class="fa fa-file"></i> View All</button>
                            </div>
                       
                    </div>
                    <div class="row">
                        <div class="col-lg-12 table-responsive">
                            <table class="table" id="ordersList">
                                <thead>
                                    <tr>
                                        <th>
                                            Branch
                                        </th>
                                        <th>
                                            Order
                                        </th>
                                        <th>
                                            Customer
                                        </th>
                                        <th>
                                            Amount
                                        </th>
                                        <th>
                                            Driver
                                        </th>
                                        <th>
                                            DeliveryStatus
                                        </th>
                                        <th>
                                            Paid by
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                        </div>
                        <p>&nbsp;</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="../js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../js/moment.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap-datetimepicker.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap3-typeahead.min.js" type="text/javascript"></script>
    <script src="../js/bootbox.js" type="text/javascript"></script>
    <script src="../js/daterangepicker/daterangepicker.js" type="text/javascript"></script>
    <script src="../js/controllers/branches.js" type="text/javascript"></script>
    
</body>
</html>
