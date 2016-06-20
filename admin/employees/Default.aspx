<%@ Page Title="" Language="VB" MasterPageFile="~/admin/site.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="admin_branches_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <div class="row">
        <div class="col-lg-12">
            <h3>
                Employees</h3>
        </div>
    </div>
   
    
    <div class="row">
         <div class="container">
        <form name="formBdata" class="row">
            <input type="hidden" name="eID" id="eID" />
            <div class="form-group col-md-6">
                <label>Employee Code</label>
                <input class="form-control" type="text" placeholder="Employee Code" id="eEmployeeCode" name="eEmployeeCode" autofocus />
            </div>

            <div class="form-group col-md-6">
                <label>Password</label>
                <input class="form-control" type="text" placeholder="Employee Password" id="ePassword" name="ePassword" />
            </div>

            <div class="form-group col-md-6">
                <label>Type</label>
                <select class="form-control" name="eType" id="eType">
                    <option>Employee</option>
                    <option>Admin</option>
                </select>
            </div>

            <div class="form-group col-md-6">
                <label>FullName</label>
                <input class="form-control" type="text" placeholder="Full Name" id="eFullName" name="eFullName" />
            </div>

            <div class="form-group col-md-6">
                <label>Mobile</label>
                <input class="form-control" type="text" placeholder="Mobile" id="eMobile" name="eMobile" />
            </div>

            <div class="form-group col-md-6">
                <label>Address</label>
                <input class="form-control" type="text" placeholder="Address" id="eAddress" name="eAddress" />
            </div>

            <div class="form-group col-md-6">
                <label>DOB</label>
                <input class="form-control" type="text" placeholder="Date of Birth" id="eDOB" name="eDOB" />
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
            
            <table class="table" id="employee">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Password</th>
                        <th>Type</th>
                        <th>FullName</th>
                        <th>Mobile</th>
                        <th>Address</th>
                        <th>DOB</th>
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
            webpos.apGetEmployees(function (res) {
                var _data = JSON.parse(res);
                $("#employee tbody tr").remove();
                $.each(_data, function (index, e) {
                    var _dob;
                    if (e.eDOB.length > 0) {
                        var dd = new Date(parseInt(e.eDOB.substr(6)));
                        _dob = dd.toLocaleDateString();
                    } else {
                        _dob = e.eDOB;
                    }
                    var strHTML = '<tr>';
                    strHTML += '    <td>' + e.eEmployeeCode + '</td>';
                    strHTML += '    <td>' + e.ePassword + '</td>';
                    strHTML += '    <td>' + e.eType + '</td>';
                    strHTML += '    <td>' + e.eFullName + '</td>';
                    strHTML += '    <td>' + e.eMobile + '</td>';
                    strHTML += '    <td>' + e.eAddress + '</td>';
                    strHTML += '    <td>' + _dob + '</td>';
                    strHTML += '    <td>';
                    strHTML += '       <div class="btn-group" role="group">';
                    strHTML += '           <button type="button" class="btn btn-danger btn-trash btn-xs" data-id="' + e.eID + '" data-ename="' + e.eFullName + '"><i class="fa fa-trash-o"></i></button>';
                    strHTML += '           <button type="button" class="btn btn-warning btn-edit btn-xs" data-id="' + e.eID + '" data-ename="' + e.eFullName + '" data-eobj=\'' + JSON.stringify(e) + '\'><i class="fa fa-edit"></i></button>';
                    strHTML += '       </div>';
                    strHTML += '    </td>';
                    strHTML += '</tr>';

                    $("#employee tbody").append(strHTML);
                });

                $("#employee").dataTable();

            }, function (res) {

            });
        }
        $(document).ready(function () {
            fnLoad();
        });


        $("form[name='formBdata']").bootstrapValidator({
            fields: {
                eEmployeeCode: {
                    validators: {
                        notEmpty: {
                            message: 'Please Enter Employee Code'
                        }
                    }
                },
                eFullName: {
                    validators: {
                        notEmpty: {
                            message: 'Please Enter Employee Name'
                        }
                    }
                }
            },
            submitHandler: function (validator, form, submitButton) {
                var _data = form.serializeObject();
                
                if (_data.eID.length === 0) {

                    webpos.apSaveEmployee(JSON.stringify(_data), function (res) {
                        if (res == "1") {
                            fnLoad();
                            $("form[name='formBdata']").bootstrapValidator('resetForm', true);
                            $("#btnReset").click();
                            $("#eID").val("");
                            SetMsg(1, "New Employee [" + _data.eFullName + "] is added successfully!");
                        } else {
                            SetMsg(0, "Can't add the New Employee [" + _data.eFullName + "]!");
                        }

                    }, function (res) {
                        console.log(res);
                    });

                } else {

                    webpos.apUpdateEmployee(JSON.stringify(_data), function (res) {
                        if (res == "1") {
                            fnLoad();
                            $("form[name='formBdata']").bootstrapValidator('resetForm', true);
                            $("#btnReset").click();
                            $("#eID").val("");
                            SetMsg(1, "Employee [" + _data.eFullName + "] is updated successfully!");
                        } else {
                            SetMsg(0, "Can't update the Employee [" + _data.eFullName + "]!");
                        }

                    }, function (res) {
                        console.log(res);
                    });
                }

            }
        });

        $(document).on("click", ".btn-trash", function (e) {
            e.preventDefault();
            $("#eID").val("");
            var ename = $(this).data("ename");
            var _confirm = confirm('Are you sure you want to DELETE the Employee - ' + ename + '?');
            if (_confirm) {
                webpos.apDeleteEmployee($(this).data("id"), function (res) {
                    if (res == "1") {
                        fnLoad();
                        SetMsg(1, "Employee [" + ename + "] is deleted successfully!");
                    } else {
                        SetMsg(0, "Can't delete the Employee [" + ename + "]!");
                    }

                }, function (res) {
                    console.log(res);
                });
            }
        });


        $(document).on("click", ".btn-edit", function (e) {
            e.preventDefault();

            var _data = $(this).data("eobj");
            var _dob;
            if (_data.eDOB.length > 0) {
                var dd = new Date(parseInt(_data.eDOB.substr(6)));
                _dob = dd.toLocaleDateString();
            } else {
                _dob = e.eDOB;
            }

            $("#eID").val(_data.eID);
            $("#eEmployeeCode").val(_data.eEmployeeCode);
            $("#ePassword").val(_data.ePassword);
            $("#eType").val(_data.eType);
            $("#eFullName").val(_data.eFullName);
            $("#eMobile").val(_data.eMobile);
            $("#eAddress").val(_data.eAddress);
            $("#eDOB").val(_dob);

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
            $("#eID").val("");
        });
        

    </script>
</asp:Content>
