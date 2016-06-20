$(".empName").text(localStorage.getItem("EmployeeName"));

$(document).ready(function () {
    $('#deliveryDatetime').datetimepicker({
       minDate: (new Date()),
       useCurrent: true,
       showTodayButton: true,
       showClear: true,
       showClose: true,
       widgetPositioning: { horizontal: 'left', vertical: 'bottom' }
    });
});

localStorage.setItem("deliveryTime", "");
localStorage.setItem("deliveryStatus", "Ordered");
localStorage.setItem("cCustID", $("#hfCustID").val());

$(document).on("click", ".logout", function (e) {
    e.preventDefault();
    window.location = "/callcenter/";
});

webpos.GetAllBranches(function (response) {
    var _data = JSON.parse(response);
    $.each(_data, function (i, b) {
        var _strHTML = "";
        _strHTML += "<div class='row branch list-group-item' data-ip='" + b.bIP + "' data-bcode='" + b.bCode + "' data-bid='" + b.bID + "'>";
        _strHTML += "<div class='col-md-8'><label><input type='radio' name='rdBranch' class='text-uppercase' />" + b.bName + "</label></div>";
       // _strHTML += "<div class='col-md-7 text-uppercase'>" + b.bName + "</div>";
        _strHTML += "<div class='col-md-3'>";
        _strHTML += "<span class='branch-status alert-danger fa fa-circle-o-notch fa-spin'></span> <a href='#' class='btn-ping' title='PING - " + b.bIP + "'><i class='fa fa-rotate-left'></i></a>";
        _strHTML += "</div>";
        _strHTML += "</div>";

        $("#branchList").append(_strHTML);

        fnAutoPing();
    });

    setInterval(function () { fnAutoPing(); }, 5000);

}, function (response) {
    console.log(response);
});

$(document).on("click", ".btn-ping", function (e) {
    e.preventDefault();
    var _obj = $(this);
    var _ip = $(_obj).parents("div.branch").data("ip");

    webpos.PingBranch(_ip, function (response) {
        var _statusObj = $(_obj).parents("div.branch").find(".branch-status");
        if (response) {
            $(_statusObj).addClass("alert-success fa-spin").removeClass("alert-danger");
        }
        else {
            $(_statusObj).addClass("alert-danger").removeClass("alert-success fa-spin");
        }
    }, function (response) {

    });
});

function fnAutoPing() {

    $("#branchList .branch").each(function (i, b) {
        var _ip = $(b).data("ip");

        webpos.PingBranch(_ip, function (response) {
            var _statusObj = $(b).find(".branch-status");
            if (response) {
                $(_statusObj).addClass("alert-success fa-spin").removeClass("alert-danger");
            }
            else {
                $(_statusObj).addClass("alert-danger").removeClass("alert-success fa-spin");
            }
        }, function (response) {

        });

    });
}

$(document).on("change", ".branch input[name='rdBranch']", function () {
    if ($(this).prop("checked")) {
        var _ip = $(this).parents("div.branch").data("ip");
        var _bid = $(this).parents("div.branch").data("bid");
        var _bCode = $(this).parents("div.branch").data("bcode");
        localStorage.setItem("BranchID", _bCode);
        localStorage.setItem("cBranchID", _bid);
        $("#hfLastSelectedBranch").val(_bid);
        webpos.GetEmpID(_bid, localStorage.getItem("EmployeeCode"), function (response) {

            if (!isNaN(parseInt(response)))
                localStorage.setItem("EmployeeID", response);

        }, function (response) {
            console.log(response);
        });

        /*Get Driver List*/
        webpos.GetDriverList(_bid, function (response) {
            $("#ddlDriver option").remove();
            $("#ddlDriver").append('<option value="0">--Select Driver--</option>');
            var _data = JSON.parse(response);
            
            $.each(_data, function (index, driver) {
                $("#ddlDriver").append('<option value="' + driver.EmployeeID + '">' + driver.EmployeeName + '</option>');
            });

        }, function (response) {
            console.log(response);
        });
    }

});

$(document).on("click", "#btnTakeOrder", function (e) {
    e.preventDefault();

    /* First Check Branch */
    if ($("[name='rdBranch']:checked").length > 0) {
        var _flag = true;
        var _custID = $("#hfCustID").val();
        if ($("#mobileno").val().replace("|", "").trim().length === 0) {
            _flag = false;
            bootbox.alert("Please enter mobile number", function () { setTimeout(function () { $("#mobileno").focus(); }, 800); });
        } else if (_custID.length === 0) {
            _flag = false;
            bootbox.alert("Please enter customer name", function () { setTimeout(function () { $("#firstname").focus(); }, 800); });
        }

        if (_flag) {
            $("#mobileno").val($("#mobileno").val().replace("|", "").trim());
            fnSaveCustInfo();
            $(".preloader").fadeIn();
            webpos.SaveCustomerInfo(customerInfo, function (res) {

                $("#hfCustID").val(res.split(":")[0]);
                localStorage.setItem("CustID", res.split(":")[1]);
                localStorage.setItem("cCustID", res.split(":")[0]);

                fnCreateNewOrder();

            }, function (res) {
                bootbox.alert(res);
                $(".preloader").fadeOut();
            });
        }


    } else {
        bootbox.alert("Please select Branch!");
    }


});

function fnCreateNewOrder() {
    var _cBID = localStorage.getItem("cBranchID");
    var _bID = localStorage.getItem("BranchID");
    var _eID = localStorage.getItem("EmployeeID");

    var _cID = localStorage.getItem("CustID");
    var _dDT = $("#deliveryDatetime").val();
    var _dID = $("#ddlDriver").val();
    var _dName = ($("#ddlDriver").val() == "0") ? "" : $("#ddlDriver option:selected").text();

    var _custID = $("#hfCustID").val();

    localStorage.setItem("MenuTypeID", 2);
    localStorage.setItem("guestcount", 1);
    localStorage.setItem("guestname", $("#firstname").val());
    localStorage.setItem("cCustID", _custID);

    //Check for existing orders
    webpos.CheckExistingOrder(_cBID, _bID, _cID, function (response) {
        var _data = JSON.parse(response);


        if (_data.length > 0) {
            $(".preloader").fadeOut();
            /* Order Found */
            bootbox.confirm("You want to open EXISTING Order?", function (result) {
                $(".preloader").fadeIn();
                if (result) {
                    localStorage.setItem("orderId", _data[0].OrderID);
                    localStorage.setItem("orderNo", _data[0].OrderNumber);
                    localStorage.setItem("deliveryTime", _dDT);
                    localStorage.setItem("deliveryStatus", "Modified");
                    window.location = "../delivery";
                } else {
                    //Create new order - 20001 - Series
                    webpos.NewDeliveryOrder(_cBID, _bID, _eID, _custID, _cID, _dDT, _dID, _dName, function (response) {
                        localStorage.setItem("orderId", response.split(":")[0]);
                        localStorage.setItem("orderNo", response.split(":")[1]);
                        localStorage.setItem("deliveryTime", _dDT);
                        localStorage.setItem("deliveryStatus", "Ordered");
                        window.location = "../delivery";
                    }, function (res) {
                        console.log(res);
                    });
                }
            }); 
           

            
        } else {
            //Create new order - 20001 - Series
            webpos.NewDeliveryOrder(_cBID, _bID, _eID, _custID, _cID, _dDT, _dID, _dName, function (response) {
                localStorage.setItem("orderId", response.split(":")[0]);
                localStorage.setItem("orderNo", response.split(":")[1]);
                localStorage.setItem("deliveryTime", _dDT);
                localStorage.setItem("deliveryStatus", "Ordered");
                window.location = "../delivery";
            }, function (res) {
                console.log(res);
            });
        }

    }, function (response) {
        console.log(response);
    });
}

$(document).on('keypress paste','[id*=mobileno], [id*=homephone], [id*=officephone]',function (e) {
    
    if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57))
        return false;
});

$('[id*=mobileno]').typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
    source: function (request, response) {
        webpos.GetCustomerInfoByMobileNo(request, function (data) {
            response(data);
        }, function () {

        });
    },
    afterSelect: function (item) {
        fnLoadCustomerInfo(item.split('|')[0].trim(), $(this.$element).attr("name"), item.split('|')[1].trim());
    }
});

$('[id*=homephone]').typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
    source: function (request, response) {
        webpos.GetCustomerInfoByHomeNo(request, function (data) {
            response(data);
        }, function () {

        });
    },
    afterSelect: function (item) {
        fnLoadCustomerInfo(item.split('|')[0].trim(), $(this.$element).attr("name"), item.split('|')[1].trim());
    }
});

$('[id*=officephone]').typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
    source: function (request, response) {
        webpos.GetCustomerInfoByOfficeNo(request, function (data) {
            response(data);
        }, function () {

        });
    },
    afterSelect: function (item) {
        fnLoadCustomerInfo(item.split('|')[0].trim(), $(this.$element).attr("name"), item.split('|')[1].trim());
    }
});

$('[id*=mobileno]').keyup(function (e) {
    e.preventDefault();
    if (e.which === 13)
        $("#firstname").focus();
});

function fnLoadCustomerInfo(item, type, bName) {

    webpos.GetUserInfoByNumber(type, item, bName, function (response) {

        var _data = JSON.parse(response);
        console.log(_data);
        if (_data.length > 0) {
            var cust = _data[0];
            $("#hfCustID").val(cust.custID);
            $("#firstname").val(cust.cFirstname);
            $("#familyname").val(cust.cFamilyname);
            $("#companyname").val(cust.cCompany);
            $("#mobileno").val(cust.cMobileNo);
            $("#homephone").val(cust.cHomeNo);
            $("#officephone").val(cust.cOfficeNo);
            $("#city").val(cust.cCity);
            $("#street").val(cust.cStreet);
            $("#building").val(cust.cBuilding);
            $("#floor").val(cust.cFloor);
            $("#zone").val(cust.cZone);
            $("#appartment").val(cust.cAppartment);
            $("#near").val(cust.cNear);
            $("#otherPhone1").val(cust.cPAOtherNo);
            $("#otherPhone2").val(cust.cSAOtherNo);
            $("#fax1").val(cust.cPAFax);
            $("#fax2").val(cust.cSAFax);
            $("#email1").val(cust.cPAEmail);
            $("#email2").val(cust.cSAEmail);
            $("#zipCode1").val(cust.cPAZipCode);
            $("#zipCode2").val(cust.cSAZipCode);
            $("#hfLastSelectedBranch").val(cust.cLastSelectedBranch);

            $("div[data-bid='" + cust.cLastSelectedBranch + "'] [name='rdBranch']").click();
            localStorage.setItem("cCustID", cust.custID);
            localStorage.setItem("CustID", cust.custBID);
        }

        $("form[name='formUser']").submit();

    }, function (res) {
        fnResetCustomer();
        console.log(res)
    });

}


var customerInfo = new Array();

function custInfo(custID, custBID, cFirstname, cFamilyname, cCompany, cMobileNo, cHomeNo, cOfficeNo, cCity, cStreet, cBuilding, cFloor, cZone, cAppartment, cNear, cPAOtherNo, cPAFax, cPAEmail, cPAZipCode, cSAOtherNo, cSAFax, cSAEmail, cSAZipCode, cLastSelectedBranch) {
    this.custID = custID,
    this.custBID = custBID,
    this.cFirstname = cFirstname,
    this.cFamilyname = cFamilyname,
    this.cCompany = cCompany,
    this.cMobileNo = cMobileNo,
    this.cHomeNo = cHomeNo,
    this.cOfficeNo = cOfficeNo,
    this.cCity = cCity,
    this.cStreet = cStreet,
    this.cBuilding = cBuilding,
    this.cFloor = cFloor,
    this.cZone = cZone,
    this.cAppartment = cAppartment,
    this.cNear = cNear,
    this.cPAOtherNo = cPAOtherNo,
    this.cPAFax = cPAFax,
    this.cPAEmail = cPAEmail,
    this.cPAZipCode = cPAZipCode,
    this.cSAOtherNo = cSAOtherNo,
    this.cSAFax = cSAFax,
    this.cSAEmail = cSAEmail,
    this.cSAZipCode = cSAZipCode,
    this.cLastSelectedBranch = cLastSelectedBranch
}

$("form[name='formUser']").submit(function (e) {
    e.preventDefault();
   
    fnSaveCustInfo();

    if ($("#hfLastSelectedBranch").val().trim().length > 0) {
        $(".preloader").fadeIn();
        webpos.SaveCustomerInfo(customerInfo, function (res) {
            $("#hfCustID").val(res.split(":")[0]);
            localStorage.setItem("CustID", res.split(":")[1]); // Branch CustBID
            localStorage.setItem("cCustID", res.split(":")[0]); // Call Center CustID
            $(".preloader").fadeOut();
        }, function (res) {
            $(".preloader").fadeOut();
            bootbox.alert(res);
        });
    } else {
        $(".preloader").fadeOut();
        bootbox.alert("Please select Branch!");
    }

});

function fnSaveCustInfo() {
    customerInfo[0] = new custInfo(
        $("#hfCustID").val(),
        (localStorage.getItem("CustID") == undefined) ? 0 : localStorage.getItem("CustID"),
        $("#firstname").val(),
        $("#familyname").val(),
        $("#companyname").val(),
        $("#mobileno").val(),
        $("#homephone").val(),
        $("#officephone").val(),
        $("#city").val(),
        $("#street").val(),
        $("#building").val(),
        $("#floor").val(),
        $("#zone").val(),
        $("#appartment").val(),
        $("#near").val(),
        $("#otherPhone1").val(),
        $("#fax1").val(),
        $("#email1").val(),
        $("#zipCode1").val(),
        $("#otherPhone2").val(),
        $("#fax2").val(),
        $("#email2").val(),
        $("#zipCode2").val(),
        $("#hfLastSelectedBranch").val()
    );
}

$("#btnReset").click(function (e) {
    e.preventDefault();
    fnResetCustomer();
});

function fnResetCustomer() {
    localStorage.removeItem("CustID");
    localStorage.removeItem("cBranchID");
    $("form[name='formUser'] input").val("");
    $("[name='rdBranch']:checked").prop("checked", false);
    $('[id*=mobileno]').focus();
}

//--------------------------- method to build range picker -------------------------------------------------------------------       

$('#daterange-btn').daterangepicker(
{
    ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
    },
    startDate: moment().subtract(29, 'days'),
    endDate: moment()
    },
    function (start, end) {
        $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    }
);

//
//$('#daterange-btn').
$('#daterange-btn').on('apply.daterangepicker', function (ev, picker) {

    localStorage.setItem("fromDate1", picker.startDate.format('YYYY-MM-DD'));
    localStorage.setItem("toDate1", picker.endDate.format('YYYY-MM-DD'));

    var fromDate1 = picker.startDate.format('YYYY-MM-DD');
    var toDate1 = picker.endDate.format('YYYY-MM-DD');

});

//-------------------- method to get All Orders on Page load-----------------------------------------------------

var _data = null;
function fnLoad() {
    var fromDate = localStorage.getItem("fromDate1");
    var toDate = localStorage.getItem("toDate1");
    var whereClause = "";
    if (fromDate != null) {
        whereClause += " where OrdDateTime between '" + fromDate + " 00:00:00.000' and  '" + toDate + " 23:59:59.999' ";
    }
    webpos.apGetOrders(whereClause, function (res) {
        _data = JSON.parse(res);
        fnBindTableData(_data);

    }, function (res) {

    });
}

$(document).ready(function () {
    fnLoad();
});

//---------------------- method to render data on to the table -------------------------------------------------------

function fnBindTableData(_tbdData) {

    $("#ordersList tbody tr").remove();
    if (_tbdData.length == 0) {

        var strHTML = '<tr>';
        strHTML += '    <td colspan="7" align="center">No Data Found</td>';
        strHTML += '</tr>';

        $("#ordersList tbody").append(strHTML);

    } else {
        $.each(_tbdData, function (index, b) {

            var strHTML = '<tr>';
            strHTML += '    <td>' + b.BranchName + '</td>';
            strHTML += '    <td>' + b.OrderNumber + '<br  /><i class="fa fa-calendar"></i>: ' + moment(b.OrdDateTime).format('MM/DD/YYYY h:mm A'); +'</td>';
            strHTML += '    <td>' + b.CustomerName + '<br  /><i class="fa fa-phone" title="Phone Number"></i>: ' + b.phoneno + '<br  /><i class="fa fa-home" title="Address"></i>:  ' + b.OrdAddress + '</td>';
            strHTML += '    <td>' + b.amount + '</td>';
            strHTML += '    <td>' + b.DriverName + '</td>';
            strHTML += '    <td>' + b.DeliveryStatus + '<br  /><i class="fa fa-clock-o" title="Dispatch Time" ></i>:  ' + b.DespatchTime + '<br  /><i class="fa fa-bell" title="Delivery Time"></i>:  ' + b.DeliveryTime + '</td>';
            strHTML += '    <td>' + b.paidby + '</td>';
            strHTML += '</tr>';

            $("#ordersList tbody").append(strHTML);
        });
    }
}

//-----------------------method to get Orders base on Search --------------------------------------------------------

$(document).on("click", "#Search", function () {

    var fromDate = localStorage.getItem("fromDate1");
    var toDate = localStorage.getItem("toDate1");
    var mobile = $("#txtFilterPhone").val();
    var driverName = $("#txtFilterDriver").val();

    var whereClause = "";
    if (fromDate != null) {
        whereClause += "and  OrdDateTime between '" + fromDate + " 00:00:00.000' and  '" + toDate + " 23:59:59.999' ";
    }

    if (mobile != "") {
        whereClause += "and phoneno = '" + mobile + "' ";
    }

    if (driverName != "") {
        whereClause += "and  DriverName like '%" + driverName + "%' ";
    }
    if (whereClause.length > 0) {
        whereClause = " WHERE " + whereClause.slice(3);
    }

    webpos.apGetOrders(whereClause, function (res) {
        _data = JSON.parse(res);
        fnBindTableData(_data);

    }, function (res) {

    });

});

$('#txtFilterPhone').typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
    source: function (request, response) {
        webpos.GetCustomerInfoByMobileNo(request, function (data) {
            response(data);
        }, function () {

        });
    },
    afterSelect: function (item) {
        $("#Search").click();
    }
});

$('#txtFilterDriver').typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
    source: function (request, response) {
        webpos.GetDriverInfoByName(request, function (data) {
            response(data);
        }, function () {

        });
    },
    afterSelect: function (item) {
        $("#Search").click();
    }
});