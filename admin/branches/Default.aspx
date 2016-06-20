<%@ Page Title="" Language="VB" MasterPageFile="~/admin/site.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="admin_branches_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <div class="row">
        <div class="col-lg-12">
            <h3>
                Branches</h3>
        </div>
    </div>
   
    
    <div class="row">
         <div class="container">
        <form name="formBdata" class="row">
            <input type="hidden" name="bID" id="bID" />
            <div class="form-group col-md-6">
                <label>Code</label>
                <input class="form-control" type="text" placeholder="Branch Code" id="bCode" name="bCode" autofocus />
            </div>

            <div class="form-group col-md-6">
                <label>Name</label>
                <input class="form-control" type="text" placeholder="Branch Name" id="bName" name="bName" />
            </div>

            <div class="form-group col-md-6">
                <label>Address</label>
                <input class="form-control" type="text" placeholder="Branch Address" id="bAddress" name="bAddress" />
            </div>

            <div class="form-group col-md-6">
                <label>IP</label>
                <input class="form-control" type="text" placeholder="Branch IP" id="bIP" name="bIP" />
            </div>

            <div class="form-group col-md-12">
                <label>DB Connection String</label>
                <input class="form-control" type="text" placeholder="DB Connection String" id="bDBConnectionString" name="bDBConnectionString" />
            </div>

            <div class="form-group col-md-12">
                <label>Service Url</label>
                <input class="form-control" type="text" placeholder="Service URL" id="bOrderingWSurl" name="bOrderingWSurl" />
            </div>

            <div class="form-group col-md-12">
                <label>Invoice Url</label>
                <input class="form-control" type="text" placeholder="Invoice URL" id="bInvoiceWSurl" name="bInvoiceWSurl" />
            </div>

            <div class="form-group col-md-12">
                <button type="submit" class="btn btn-primary" id="btnSave">Save</button>
                <button type="reset" class="btn btn-default" id="btnReset">Reset</button>
            </div>

        </form>
            
            <div class="alert">
            </div>

         </div>
        <hr />
        <div class="col-lg-12 table-responsive">
            
            <table class="table" id="branches">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Name</th>
                        <th>Customers</th>
                        <th>IP</th>
                        <th>DBConnectionString</th>
                        <th>ServiceUrl</th>
                        <th>InvoiceUrl</th>
                        <th>Sync</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>

        </div>
    </div>
</asp:Content>

<asp:Content ID="sc1" ContentPlaceHolderID="cphCustomScripts" runat="Server">
    <script src="../../js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../js/bootstrap.min.js" type="text/javascript"></script>
    <script src="../js/jquery.dataTables.min.js" type="text/javascript"></script>
    <script src="../js/bootstrapValidator.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.serialize-object.js" type="text/javascript"></script>
    <script>

        

        function fnLoad() {
            webpos.apGetBranches(function (res) {
                var _data = JSON.parse(res);
                $("#branches tbody tr").remove();
                $.each(_data, function (index, b) {
                    var strHTML = '<tr>';
                    strHTML += '    <td>' + b.bCode + '</td>';
                    strHTML += '    <td>' + b.bName + '</td>';
                    strHTML += '    <td>' + b.totalCustomer + '</td>';
                    strHTML += '    <td>' + b.bIP + '</td>'; //
                    strHTML += '    <td>' + b.bDBConnectionString + '</td>';
                    strHTML += '    <td><a href="' + b.bOrderingWSurl + '" target="_blank" title="' + b.bOrderingWSurl + '">Service</a></td>';
                    strHTML += '    <td><a href="' + b.bInvoiceWSurl + '" target="_blank" title="' + b.bInvoiceWSurl + '">Service</a></td>';
                    strHTML += '    <td><button type="button" class="btn btn-info btn-sync btn-xs" data-id="' + b.bID + '" ><i class="fa fa-refresh"></i></button></td>';
                    strHTML += '    <td>';
                    strHTML += '       <div class="btn-group" role="group">';
                    strHTML += '           <button type="button" class="btn btn-danger btn-trash btn-xs" data-id="' + b.bID + '" data-bname="' + b.bName + '"><i class="fa fa-trash-o"></i></button>';
                    strHTML += '           <button type="button" class="btn btn-warning btn-edit btn-xs" data-id="' + b.bID + '" data-bname="' + b.bName + '" data-bobj=\'' + JSON.stringify(b) + '\'><i class="fa fa-edit"></i></button>';
                    strHTML += '       </div>';
                    strHTML += '    </td>';
                    strHTML += '</tr>';

                    $("#branches tbody").append(strHTML);
                });

                $("#branches").dataTable();

            }, function (res) {

            });
        }
        $(document).ready(function () {
            fnLoad();
        });


        $("form[name='formBdata']").bootstrapValidator({
            fields: {
                bCode: {
                    validators: {
                        notEmpty: {
                            message: 'Please Enter Branch Code'
                        }
                    }
                },
                bName: {
                    validators: {
                        notEmpty: {
                            message: 'Please Enter Branch Name'
                        }
                    }
                },
                bIP: {
                    validators: {
                        notEmpty: {
                            message: 'Please Enter Branch Name'
                        },
                        ip: {
                            message: 'Invalid IP Address'
                        }
                    }
                },
                bDBConnectionString: {
                    validators: {
                        notEmpty: {
                            message: 'Please Enter Branch DB String'
                        }
                    }
                },
                bOrderingWSurl: {
                    validators: {
                        notEmpty: {
                            message: 'Please Enter Ordering Service URL'
                        }
                    }
                },
                bInvoiceWSurl: {
                    validators: {
                        notEmpty: {
                            message: 'Please Enter Invoice Service URL'
                        }
                    }
                }
            },
            submitHandler: function (validator, form, submitButton) {
                var _data = form.serializeObject();
                
                if (_data.bID.length === 0) {

                    webpos.apSaveBranch(JSON.stringify(_data), function (res) {
                        if (res == "1") {
                            fnLoad();
                            $("form[name='formBdata']").bootstrapValidator('resetForm', true);
                            $("#btnReset").click();
                            $("#bID").val("");
                            SetMsg(1, "New Branch [" + _data.bName + "] is added successfully!");
                        } else {
                            SetMsg(0, "Can't add the New Branch [" + _data.bName + "]!");
                        }

                    }, function (res) {
                        console.log(res);
                    });

                } else {

                    webpos.apUpdateBranch(JSON.stringify(_data), function (res) {
                        if (res == "1") {
                            fnLoad();
                            $("form[name='formBdata']").bootstrapValidator('resetForm', true);
                            $("#btnReset").click();
                            $("#bID").val("");
                            SetMsg(1, "Branch [" + _data.bName + "] is updated successfully!");
                        } else {
                            SetMsg(0, "Can't update the Branch [" + _data.bName + "]!");
                        }

                    }, function (res) {
                        console.log(res);
                    });
                }

            }
        });

        

        $(document).on("click", ".btn-sync", function (e) {
            e.preventDefault();
            $("#bID").val("");
            var bId = $(this).data("id");
            $(".preLoad-wrap").fadeIn();
             
            webpos.apSyncBranch($(this).data("id"), function (res) {
                $(".preLoad-wrap").fadeOut();
                if (res == "1") {
                    fnLoad();
                    SetMsg(1, "Branch is Synchronised successfully!");
                } else {
                    SetMsg(0, "Failed to Synchronised the Branch !");
                }

            }, function (res) {
                console.log(res);
            });

        });

        $(document).on("click", ".btn-trash", function (e) {
            e.preventDefault();
            $("#bID").val("");
            var bname = $(this).data("bname");
            var _confirm = confirm('Are you sure you want to DELETE the Barnch - ' + bname + '?');
            if (_confirm) {
                webpos.apDeleteBranch($(this).data("id"), function (res) {
                    if (res == "1") {
                        fnLoad();
                        SetMsg(1, "Branch [" + bname + "] is deleted successfully!");
                    } else {
                        SetMsg(0, "Can't delete the Branch [" + bname + "]!");
                    }

                }, function (res) {
                    console.log(res);
                });
            }
        });


        $(document).on("click", ".btn-edit", function (e) {
            e.preventDefault();

            var _data = $(this).data("bobj");

            $("#bID").val(_data.bID);
            $("#bCode").val(_data.bCode);
            $("#bName").val(_data.bName);
            $("#bAddress").val(_data.bAddress);
            $("#bIP").val(_data.bIP);
            $("#bDBConnectionString").val(_data.bDBConnectionString);
            $("#bOrderingWSurl").val(_data.bOrderingWSurl);
            $("#bInvoiceWSurl").val(_data.bInvoiceWSurl);

            Scroll2Element("form[name='formBdata']");

        });

        function SetMsg(alertType, alertMsg) {
            switch (alertType) {
                case 0:
                    $(".alert").addClass("alert-danger");
                    $(".alert").html("<p><strong>Erorr:</strong> " + alertMsg + "</p>");
                    $(".alert").fadeIn();
                    break;
                case 1:
                    $(".alert").addClass("alert-success");
                    $(".alert").html("<p><strong>Success:</strong> " + alertMsg + "</p>");
                    $(".alert").fadeIn();
                    break;
            }

            setTimeout(function () {
                $(".alert").fadeOut(400, function () {
                    $(".alert").removeClass("alert-danger alert-success");
                });
            }, 3000);
        }

        function Scroll2Element(Obj) {
            $('html, body').animate({
                scrollTop: $(Obj).offset().top - 100
            }, 'slow');
        }

        $("#btnReset").click(function () {
            $("#bID").val("");
        });
        

    </script>
</asp:Content>
