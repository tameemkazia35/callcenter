localStorage.removeItem("orderId");
localStorage.removeItem("orderNo");
localStorage.removeItem("newTableNo");
localStorage.removeItem("noCust");
localStorage.removeItem("guestname");
localStorage.removeItem("guestcount");

var iOS = ((/iphone|ipad/gi).test(navigator.appVersion));
var clickOrtouchend = iOS ? "touchstart" : "click";
var btnClass = { DEFAULT: "btn-default", PRIMARY: "btn-primary", INFO: "btn-info", WARNING: "btn-warning", SUCCESS: "btn-success", DANGER: "btn-danger" };

$(".empName").text(localStorage.getItem("EmployeeName"));

$(document).on("click", ".logout", function (e) {
    e.preventDefault();
    localStorage.clear();
    window.location = "/webpos/";
});

$(window).load(function () {
    setTimeout(function () {

        if (localStorage.getItem("MenuTypeID") != undefined) {

            switch (localStorage.getItem("MenuTypeID")) {
                case "1":
                    $("#DriveThru").addClass("hide");
                    $("#DineIn").removeClass("hide");
                    fnLoadTables();
                    break;
                case "5":
                    $("#DriveThru").removeClass("hide");
                    $("#DineIn").addClass("hide");
                    fnLoadTables();
                    break;
            }
        }
    
    }, 200);
    
});

/************* Load Menu Services ****************/
var fnLoadMenuServices = function () {

    webpos.LoadMenuItems(localStorage.getItem("BranchID"), localStorage.getItem("EmployeeID"), function (sResponse) {
        var _data = JSON.parse(sResponse);
        $("#DineIn,#DriveThru").addClass("hide");
        $.each(_data, function (_index, _obj) {
            var _strHTML = "";
            //if (_obj.MenuID == 1)
            _strHTML += '<a href="#" data-menuId="' + _obj.MenuID + '" class="btn btn-flat ' + btnClass.PRIMARY + '">' + _obj.KeyID + '</a>';
            /*if (_obj.MenuID == 5)
            _strHTML += '<a href="#" data-menuId="' + _obj.MenuID + '" class="btn btn-flat ' + btnClass.INFO + '"><i class="fa fa-car"></i> ' + _obj.KeyID + '</a>';
            */
            $(".menuServiceList").append(_strHTML);

            if (localStorage.getItem("MenuTypeID") == undefined) {
                if (_index == 0) {
                    localStorage.setItem("MenuTypeID", _obj.MenuID);

                    switch (localStorage.getItem("MenuTypeID")) {
                        case "1":
                            $("#DriveThru").addClass("hide");
                            $("#DineIn").removeClass("hide");
                            fnLoadTables();
                            break;
                        case "5":
                            $("#DriveThru").removeClass("hide");
                            $("#DineIn").addClass("hide");
                            fnLoadTables();
                            break;
                    }

                }
            }

        });


    }, function (eResponse) {

    });

}
fnLoadMenuServices();

/* Get Tables */
fnLoadTables = function () {
    $.ajax({
        cache: true,
        type: "POST",
        url: '/webpos/webpos.asmx/GetOpenTables',
        data: '{ "BranchID": ' + localStorage.getItem("BranchID") + ', "tableType" : ' + localStorage.getItem("MenuTypeID") + '}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function (e, d) {
            $(".tables-list").html("<h1 class='fa fa-spinner fa-spin'></h1>");
        },
        complete: function (response) {
            $(".tables-list").html("");

            if (response.status === 200) {
                var _data = JSON.parse(response.responseJSON.d);

                if (_data != null) {

                    $.each(_data, function (_index, _openTable) {

                        var _openTime = new Date(parseInt(_openTable.OpeningTime.replace(/(^.*\()|([+-].*$)/g, '')));
                        _openTime = _openTime.toLocaleTimeString();
                        _openTime = _openTime.split(' ')[0] + ' ' + _openTime.split(' ')[1];
                        var _cssClass = (localStorage.getItem("EmployeeID") == _openTable.OpenedBy) ? "self" : "others";
                        var _customerName = (_openTable.Customer == null) ? 'No Name' : _openTable.Customer;
                        var _strHTML = '';
                        if (_openTable.lock) {
                            _cssClass = "lock";
                        }
                        if (_openTable.CheckIsPrinted) {
                            _cssClass = "printed";
                        }
                        _strHTML += '<div class="col-sm-4 animated fadeIn">';
                        _strHTML += '   <a href="javascript:return false;" class="table-box ' + _cssClass + '" data-orderstatus="' + _openTable.Status + '" data-openby="' + _openTable.OpenedBy + '" data-orderid="' + _openTable.OrderID + '" data-locked="' + _openTable.lock + '" data-tableno="' + _openTable.OrderNumber + '">';
                        _strHTML += '       <div class="table-no">' + _openTable.OrderNumber + '</div>';
                        _strHTML += '       <dl>';
                        _strHTML += '           <dt><i class="fa fa-user-secret fa-fw"></i>' + _trGuest + '</dt><dd>' + _openTable.NumberOfCustomers + '</dd>';
                        _strHTML += '           <dt><i class="fa fa-tag fa-fw"></i>' + _trName + '</dt><dd>' + _customerName + '</dd>';
                        _strHTML += '           <dt><i class="fa fa-clock-o fa-fw"></i>' + _trTime + '</dt><dd>' + _openTime + '</dd>';
                        _strHTML += '           <dt><i class="fa fa-bell-o fa-fw"></i>' + _trServer + '</dt><dd>' + _openTable.Server + '</dd>';
                        _strHTML += '       </dl>';
                        _strHTML += '   </a>';
                        _strHTML += '</div>';

                        $(".tables-list").append(_strHTML);
                    });

                } else {
                    $(".tables-list").html("<p><i class='fa fa-exclamation-triangle '></i> No tables in order!</p>");
                }
            } else {
                $(".tables-list").html("<i class='fa fa-exclamation-triangle'></i> " + response.statusText);
            }
        }
    });

}




$(document).on("click", ".menuServiceList a", function (e) {
    e.preventDefault();
    localStorage.setItem("MenuTypeID", $(this).data("menuid"));
   
    if (localStorage.getItem("RoleID") === "1") {
        /*Managing Server*/
        switch ($(this).data("menuid")) {
            case 1:
                /* Dine In */
                if ($("#DineIn").css("display") === "block") {
                    location.href = "table-list.aspx";
                } else {
                    $("#DriveThru").addClass("hide");
                    $("#DineIn").removeClass("hide");
                    $("#DineIn h2").html($(this).html());
                    fnLoadTables();
                }
                break;
            case 5:
                /* Drive Thru */
                if ($("#DriveThru").css("display") === "block") {
                    location.href = "table-list.aspx";
                } else {
                    $("#DriveThru").removeClass("hide");
                    $("#DineIn").addClass("hide");
                    $("#DriveThru h2").html($(this).html());
                    fnLoadTables();
                }
                break;
            case 2:
                location.href = "table-list.aspx";
                break;
            case 3:
                location.href = "table-list.aspx";
                break;
            case 7:
                location.href = "table-list.aspx";
                break;
        }

    } else {
        switch ($(this).data("menuid")) {
            case 1:
                /* Dine In */
                if ($("#DineIn").css("display") === "block") {
                    location.href = "table-list.aspx";
                } else {
                    $("#DriveThru").addClass("hide");
                    $("#DineIn").removeClass("hide");
                    $("#DineIn h2").html($(this).html());
                    fnLoadTables();
                }
                break;
            case 5:
                /* Drive Thru */
                if ($("#DriveThru").css("display") === "block") {
                    location.href = "table-list.aspx";
                } else {
                    $("#DriveThru").removeClass("hide");
                    $("#DineIn").addClass("hide");
                    $("#DriveThru h2").html($(this).html());
                    fnLoadTables();
                }
                break;
        }
    }

});


/** DineIn Keyboard **/
$(document).on(clickOrtouchend, "#DineIn .numpad-list li", function () {
    var _numKey = $(this).data("value");
    var _newTableVal = $("#txtNewTable").val();
    var _noCustVal = $("#txtNoCustomers").val();
    var _custName = "";
    switch (_numKey) {
        case "clear":
            $(".new-table").removeClass("hide");
            $(".new-no-customers").removeClass("show").addClass("hide");
            $("#txtNewTable, #txtNoCustomers").val("");
            break;
        case "ok":

            if (_newTableVal.length > 0 && $(".tables-list").find("a[data-tableno='" + _newTableVal + "']").length === 0) {
                $(".new-table").addClass("hide");
                $(".new-no-customers").removeClass("hide").addClass("show");
            } else {

                var orderid = $(".tables-list").find("a[data-tableno='" + _newTableVal + "']").data("orderid");
                var _tableLocked = $(".tables-list").find("a[data-tableno='" + _newTableVal + "']").data("locked");
                _noCustVal = $(".tables-list").find("a[data-tableno='" + _newTableVal + "']").find("dd:eq(0)").text();
                _custName = $(".tables-list").find("a[data-tableno='" + _newTableVal + "']").find("dd:eq(1)").text();

                if (_tableLocked || !localStorage.getItem("OpenTablesAccess")) {
                    alert('Table [' + _newTableVal + '] is open by another user and you have no access to it ..!');
                } else {
                    localStorage.setItem("orderId", orderid);
                    localStorage.setItem("orderNo", _newTableVal);
                    localStorage.setItem("guestname", _custName);
                    localStorage.setItem("guestcount", _noCustVal);

                    fnLockTable(orderid);
                }

            }

            if ($(".new-no-customers").css("display") != "none" && $("#txtNoCustomers").val().length > 0) {
                localStorage.setItem("newTableNo", _newTableVal);
                localStorage.setItem("noCust", _noCustVal);
                $(".preloader").fadeIn();
                /* call webservice to create the order */
                webpos.NewOrder(window.localStorage.getItem("BranchID"), 1, localStorage.getItem("MenuTypeID"), _newTableVal, _noCustVal, window.localStorage.getItem("EmployeeID"), function (sObj) {
                    $(".preloader").fadeOut();
                    localStorage.setItem("orderId", sObj);
                    localStorage.setItem("orderNo", _newTableVal);
                    localStorage.setItem("guestname", "No Name");
                    localStorage.setItem("guestcount", _noCustVal);
                    fnLockTable(sObj);
                    
                    window.location = "../table/";

                }, function (fObj) {
                    alert(fObj.fObj._stackTrace);
                });


            }

            break;
        default:

            if ($(".new-table").css("display") != "none") {
                _newTableVal += _numKey;
                $("#txtNewTable").val(_newTableVal);
            } else if ($(".new-no-customers").css("display") != "none") {
                _noCustVal += _numKey;
                $("#txtNoCustomers").val(_noCustVal);
            }

            break;
    }

});

/** Drive Thru Keyboard **/
$(document).on(clickOrtouchend, "#DriveThru .numpad-list li", function () {
    var _numKey = $(this).data("value");
    var _noCustVal = $("#txtDT_NoCustomers").val();
    var _custName = "";
    switch (_numKey) {
        case "clear":
            $("#txtDT_NoCustomers").val("");
            break;
        case "ok":

            webpos.GetDriveThruOrderNo(function (sObj) {

                var _newTableVal = sObj;
                var _noCustVal = $("#txtDT_NoCustomers").val();

                $(".preloader").fadeIn();
                /* call webservice to create the order */
                webpos.NewOrder(window.localStorage.getItem("BranchID"), 1, localStorage.getItem("MenuTypeID"), _newTableVal, _noCustVal, localStorage.getItem("EmployeeID"), function (sObj) {
                    $(".preloader").fadeOut();
                    localStorage.setItem("orderId", sObj);
                    localStorage.setItem("orderNo", _newTableVal);
                    localStorage.setItem("guestname", "No Name");
                    localStorage.setItem("guestcount", _noCustVal);

                    fnLockTable(sObj);

                    window.location = "../table/";

                }, function (fObj) {
                    alert(fObj._stackTrace);
                });

            },
            function (eObj) {
                console.log(eObj); 
            });

            

            break;
        default:
            _noCustVal += _numKey;
            $("#txtDT_NoCustomers").val(_noCustVal);
    }

});

$(document).on("click", ".tables-list .table-box", function () {
    var _orderId = $(this).data("orderid");
    var _orderNo = $(this).data("tableno");
    var _guestname = $(this).find("dd:eq(1)").text().trim();
    var _guestcount = $(this).find("dd:eq(0)").text().trim();

    var _tableLocked = $(this).data("locked");
    if (_tableLocked || !localStorage.getItem("OpenTablesAccess")) {
        
        var _strHTML = "<h4 style='font-weight: normal;'>";
        _strHTML += _trRefreshMsg.replace("_", "<b>" + _orderNo + "</b>");
        _strHTML += "</<h4>";
        $("#errMsgModal .modal-body").html(_strHTML);
        $("#errMsgModal .btn-refresh").attr("data-tableno", _orderNo);
        $("#errMsgModal .btn-refresh").removeAttr("disabled");
        $("#errMsgModal").modal("show");

    } else {
        localStorage.setItem("orderId", _orderId);
        localStorage.setItem("orderNo", _orderNo);
        localStorage.setItem("guestname", _guestname);
        localStorage.setItem("guestcount", _guestcount);
        fnLockTable(_orderId);
    }
});

/* Current Time */
setInterval(function () {
    var _time = (new Date()).toLocaleTimeString().split(' ');
    _time = _time[0] + ' ' + _time[1];
    $("#tableTime").val(_time);
}, 1000);


fnRefreshtable = function (_obj, _tableNo) {
    $.ajax({
        type: "POST",
        url: '/webpos/webpos.asmx/RefreshTable',
        data: '{ "BranchID" : ' + localStorage.getItem("BranchID") + ' , "TableNo": ' + _tableNo + '}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function (e, d) {
            $(_obj).find("i").addClass("fa-spin");
        },
        complete: function (response) {
            $(_obj).find("i").removeClass("fa-spin");

            if (response.status === 200) {
                if (response.responseJSON.d) {
                    alert(_trRefreshSuccessMsg.replace("_", _tableNo));
                    $(".tables-list").find("a[data-tableno='" + _tableNo + "']").attr("data-locked", "true");
                    fnLoadTables();
                } else {
                    alert(_trRefreshErrMsg.replace('_', _tableNo));
                }
            } else {
                alert(response.statusText);
            }
        }
    });
}


$(document).on("click", ".btn-refresh", function (e) {
    e.preventDefault();
    var _tableNo = $(this).data("tableno");

    $.ajax({
        type: "POST",
        url: '/webpos/webpos.asmx/RefreshTable',
        data: '{ "BranchID" : ' + localStorage.getItem("BranchID") + ' , "TableNo": ' + _tableNo + '}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function (e, d) {
            $(this).find("i").addClass("fa-spin");
        },
        complete: function (response) {
            $(this).find("i").removeClass("fa-spin");

            if (response.status === 200) {
                if (response.responseJSON.d) {
                    
                    $("#errMsgModal .modal-body").html('<h4 style="font-weight: normal;">'+ _trRefreshSuccessMsg.replace("_",  "<strong>" + _tableNo + "</strong>") + '</h4>');

                    $(".tables-list").find("a[data-tableno='" + _tableNo + "']").attr("data-locked", "true");
                    $("#txtNewTable").val("");
                    fnLoadTables();

                    $("#errMsgModal .btn-refresh").attr("disabled", "disabled");

                } else {
                    alert( _trRefreshErrMsg.replace('_', _tableNo) );
                }
            } else {
                alert(response.statusText);
            }
        }
    });

});


$(document).on(clickOrtouchend, ".btn-refresh-table", function (e) {
    if (localStorage.getItem("MenuTypeID") === "1") {
        if ($("#txtNewTable").val().trim().length != 0) {
            fnRefreshtable(this, $("#txtNewTable").val());
            $("#txtNewTable").val("");
        } else {
            alert('Enter table number!');
        }
    } else if (localStorage.getItem("MenuTypeID") === "5") {
        if ($("#txtDT_NoCustomers").val().trim().length != 0) {
            fnRefreshtable(this, $("#txtDT_NoCustomers").val());
            $("#txtDT_NoCustomers").val("");
        } else {
            alert('Enter table number!');
        }
    }

});



/***** SOC: Reloading in every 30 Seconds *****/
var counter = 1000 * 15;
var _timer = setInterval(function () {
    var sec = (counter / 1000);
    $('.counter').html("Update in "+ sec +" Second(s)");
    counter = counter - 1000;
    if (sec < 1) {
        fnLoadTables();
        counter = 1000 * 15;
    }
}, 1000);
/***** EOC: Reloading in every 30 Seconds *****/

/** Emp Previlliages **/
$.ajax({
    type: "POST",
    url: '/webpos/webpos.asmx/GetEmpRights',
    data: '{ "BranchID" : ' + localStorage.getItem("BranchID") + '}',
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    beforeSend: function (e, d) {

    },
    complete: function (response) {
        if (response.status === 200) {
            localStorage.setItem("OpenTablesAccess", JSON.parse(response.responseJSON.d)[0].OpenTablesAccess);
        } else {
            $("#errMsg").html("<i class='fa fa-exclamation-triangle'></i> " + response.statusText).css("display", "block"); ;
        }
    }
});

fnLockTable = function (_orderId) {
    $.ajax({
        type: "POST",
        url: '/webpos/webpos.asmx/LockTable',
        data: '{ "OrderId" : ' + _orderId + '}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function (e, d) {

        },
        complete: function (response) {
            if (response.status === 200) {
                if (response.responseJSON.d) {
                    clearInterval(_timer);
                    window.location = "../table/";
                }
            } else {
                console.log(response.statusText);
            }
        }
    });
}
