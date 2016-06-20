
var iOS = ((/iphone|ipad/gi).test(navigator.appVersion));
var clickOrtouchend = iOS ? "click" : "click";

$(".empName").text(localStorage.getItem("EmployeeName"));
$(".tableno").text(localStorage.getItem("orderNo"));
$(".guestname").text(localStorage.getItem("guestname"));
$(".guestcount").text(localStorage.getItem("guestcount"));



$(document).on("click", ".logout", function (e) {
    e.preventDefault();

    webpos.RefreshTable(window.localStorage.getItem("cBranchID"), window.localStorage.getItem("BranchID"), window.localStorage.getItem("orderNo"), function (sObj) {
        console.log(sObj);
        localStorage.clear();
        window.location = "/../"; 
    }, function (fObj) { console.log(fObj); })
    
});

function fnScroll2Bottom() {
    var wtf = $('.top');
    var height = wtf[0].scrollHeight;
    wtf.scrollTop(height);
}

/*Load Payment Types*/
var _cBranchID = localStorage.getItem("cBranchID");
$(document).ready(function () {
    webpos.GetPayTypes(_cBranchID, function (response) {
        var _data = JSON.parse(response);
        $("#ddlPayType option").remove();
        $.each(_data, function (index, payType) {
            $("#ddlPayType").append('<option>' + payType.PaymentType + '</option>');
        });

        webpos.GetPaidByType(_cBranchID, localStorage.getItem("orderId"), localStorage.getItem("cCustID"), function (response) {
            if (response == null) {
                $("#ddlPayType").val("CASH DHS");
            }else if (response.length > 0)
                $("#ddlPayType").val(response);
        }, function (response) { console.log(response) })

    }, function (response) {
        console.log(response);
    });



});


/* Load Order Items */
fnLoadOrderItems = function (_cBranchId, _branchId, _orderId) {
    $.ajax({
        url: '../webpos.asmx/GetOrderItemsList',
        cache: true,
        method: 'post',
        data: '{ "cBranchID" : ' + _cBranchId + ', "BranchID": ' + _branchId + ' , "OrderID": ' + _orderId + ' }',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function (e, d) {

        },
        complete: function (response) {
            if (response.status === 200) {
                var _data = JSON.parse(response.responseJSON.d);

                if (_data != null) {
                    $("table.items tbody tr").remove();

                    $.each(_data, function (_index, _item) {

                        var _tempTr = '';
                        _tempTr += '<tr data-itemid="' + _item.ItemID + '" class="old">';
                        _tempTr += '<td></td>';
                        _tempTr += '<td class="qty" align="right">' + _item.Quantity + '</td>';

                        if (_item.UsedPrice > 0 && (_item.Description.lastIndexOf("**") == -1 || _item.Description.lastIndexOf(">>") == -1)) {

                            if (_item.ItemRemark.length === 0) {
                                _tempTr += '<td><strong>' + _item.Description + '</strong></td>';
                            } else {
                                _tempTr += '<td><strong>' + _item.Description + '</strong><small class="item-remarks">' + _item.ItemRemark + '</small></td>';
                            }

                            _tempTr += '<td class="price" align="right" data-itemprice="' + parseFloat(_item.UsedPrice).toFixed(2) + '" >' + parseFloat(_item.Quantity * _item.UsedPrice).toFixed(2) + '</td>';

                            if (_item.Status === 'Ordered') {
                                _tempTr += '<td align="center"><a href="#" class="btn btn-warning btn-xs disabled void"><i class="fa fa-ban"></i></a></td>';
                                _tempTr += '<td><label class="label label-success">' + _item.Status + '</label></td>';
                            }
                            else {
                                _tempTr += '<td></td>';
                                _tempTr += '<td><label class="label label-default">' + _item.Status + '</label></td>';
                            }
                        }
                        else {
                            if (_item.SetMenu) {
                                _tempTr += '<td>>> ' + _item.Description + '</td>';
                            } else {
                                _tempTr += '<td>' + _item.Description + '</td>';
                            }

                            _tempTr += '<td class="price" align="right">' + parseFloat(_item.Quantity * _item.UsedPrice).toFixed(2) + '</td>';

                            if (_item.Status === 'Ordered') {
                                _tempTr += '<td></td>';
                                _tempTr += '<td><label class="label label-success">' + _item.Status + '</label></td>';
                            }
                            else {
                                _tempTr += '<td></td>';
                                _tempTr += '<td><label class="label label-default">' + _item.Status + '</label></td>';
                            }
                        }





                        _tempTr += '</tr>';

                        $(".items tbody").append(_tempTr);


                    });
                    fnScroll2Bottom();
                    CalcPrice();
                }

            } else {
                alert(response.statusText);
            }
        }
    });

}

fnLoadOrderItems(localStorage.getItem("cBranchID"), localStorage.getItem("BranchID"), localStorage.getItem("orderId"));

$('#numpadModal').on('hidden.bs.modal', function () {
    $(".new-no-customers").removeClass("show").addClass("hide");
    $("#txtNewTable, #txtNoCustomers").val("");
    $(".new-table").removeClass("hide");
});

$('#moreFunctions').on('shown.bs.modal', function () {

    /*Call WebService*/
    webpos.GetMoreOptions(window.localStorage.getItem("orderId"), function (response) {
        var _data = JSON.parse(response);
        $("#tableCovers").val(_data[0].NumberOfCustomers);
        $("#txtKitchenRemarks").val(_data[0].KitchenRemark);
        $("#txtBillRemarks").val(_data[0].InvoiceRemark);
    }, function (response) {
        console.log(response)
    });

});

/** Ready **/
$(document).ready(function () {
    fnLoadGroupList(1, 3);
    fnLoadWorkstations();
});

/* Get Group List */
fnLoadGroupList = function (screenId, type) {
    $.ajax({
        url: '../webpos.asmx/GetScreenItems',
        cache: true,
        method: 'post',
        data: '{ "cBranchID" : ' + localStorage.getItem("cBranchID") + ' , "BranchID": ' + localStorage.getItem("BranchID") + ', "ScreenID": ' + screenId + ', "Type": ' + type + '}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function (e, d) {
            $("#groupList").html("<i class='fa fa-spinner fa-spin'></i>");
        },
        complete: function (response) {
            if (response.status === 200) {
                var _data = JSON.parse(response.responseJSON.d);

                if (_data != null) {
                    $("#groupList").html("");

                    $.each(_data, function (_index, _item) {

                        var _groupHTML = "";
                        _groupHTML += "<a class='animated fadeIn' href='#' data-itemtype='" + _item.ItemTypeID + "' data-groupID='" + _item.GroupID + "' data-newItemId='" + _item.ItemID + "' data-itemID='" + _item.SalesItemID + "' data-price='" + _item.PriceMode1 + "' data-modifier1='" + _item.Modifier1 + "'  data-modifier2='" + _item.Modifier2 + "'  data-modifier3='" + _item.Modifier3 + "'  data-modifier4='" + _item.Modifier4 + "' data-function-id='" + _item.FunctionID + "' >";
                        _groupHTML += "<span>" + _item.DisplayName + "</span>";
                        _groupHTML += "</a>";
                        $("#groupList").append(_groupHTML);
                    });

                } else {
                    $("#groupList").html("<p><i class='fa fa-exclamation-triangle '></i> No group found!</p>").css("display", "block");
                }
            } else {
                $("#groupList").html("<i class='fa fa-exclamation-triangle'></i> " + response.statusText).css("display", "block"); ;
            }
        }
    });

}

$("#btnMainScreen").click(function (e) {
    e.preventDefault();
    fnLoadGroupList(1, 3);
});

/* Item List */

var _itemsetid;

$(document).on(clickOrtouchend, "#groupList > a", function (e) {
    e.preventDefault();

    var itemType = $(this).data("itemtype");

    switch (itemType) {
        case 3:
            /*Check only Screen => Load Main Group*/
            var gId = $(this).data("newitemid");
            fnLoadGroupList(gId, itemType);
            break;
        case 2:
            /*Check only items => Load Group of Items*/
            var gId = $(this).data("newitemid");
            fnLoadGroupList(gId, itemType);
            break;
        case 1:
            /*Check for items + remark = Add to left table */
            var _curItemId = $(this).data("itemid");
            _itemsetid = fnGetItemSetId(_curItemId);
            var _orderinDateTime = (new Date()).toLocaleString().replace(",", "");

            if ($(this).text().indexOf("***") == -1 && $(this).data("price") != 0) {


                var _tempTr = '';
                _tempTr += '<tr data-itemid="' + $(this).data("itemid") + '" class="temp" data-setmenu="false" data-setid="' + _itemsetid + '" data-odt="' + _orderinDateTime + '">';
                _tempTr += '<td><a href="#" class="btn btn-danger btn-xs trash"><i class="fa fa-trash"></i></a></td>';
                _tempTr += '<td class="qty" align="right">1</td>';
                _tempTr += '<td><a href="#edit"><strong>' + $(this).text().trim() + '</strong></a></td>';
                _tempTr += '<td class="price" align="right" data-itemprice="' + parseFloat($(this).data("price")).toFixed(2) + '">' + parseFloat($(this).data("price")).toFixed(2) + '</td>';
                _tempTr += '<td></td>';
                _tempTr += '<td><label class="label label-danger">Selected</label></td>';
                _tempTr += '</tr>';

                $(".items tbody").append(_tempTr);

                /* scroll to bottom */
                fnScroll2Bottom();

                /* Check for Set Menu Items */
                webpos.GetItemsFromSetMenu( localStorage.getItem("cBranchID"), _curItemId, 1, function (_response) {
                    var _data = JSON.parse(_response);
                    if (_data != null) {
                        $.each(_data, function (_index, _subItem) {

                            var _tempSubTr = '';
                            _tempSubTr += '<tr data-itemid="' + _subItem.parentid + '" data-parentid="' + _curItemId + '" class="temp" data-setmenu="true" data-setid="' + _itemsetid + '" data-odt="' + _orderinDateTime + '">';
                            _tempSubTr += '<td></td>';
                            _tempSubTr += '<td class="qty" align="right">' + _subItem.Qty + '</td>';
                            _tempSubTr += '<td>' + _subItem.Description + '</td>';
                            _tempSubTr += '<td class="price" align="right" data-itemprice="0">0.00</td>';
                            _tempSubTr += '<td></td>';
                            _tempSubTr += '<td><label class="label label-danger">Selected</label></td>';
                            _tempSubTr += '</tr>';

                            $(".items tbody").append(_tempSubTr);
                            fnScroll2Bottom();
                        });
                    }
                }, function (_error) {

                });

                CalcPrice();

                /* Check Modifiers */
                if ($(this).data("modifier1") != null) {
                    //bring the popup
                    $.ajax({
                        url: '../webpos.asmx/GetModifierList',
                        cache: true,
                        method: 'post',
                        data: '{"cBranchID": ' + localStorage.getItem("cBranchID") + ',"ModifierID": ' + $(this).data("modifier1") + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        beforeSend: function (e, d) {
                            /* $("#itemsList").html("<i class='fa fa-spinner fa-spin'></i>");

                            $("#groupList a").fadeIn(100, function () {
                            $("input[type='search']").val("");
                            });*/

                        },
                        complete: function (response) {
                            $("#modifierModal1 .modal-body table tr").remove();
                            if (response.status === 200) {
                                var _data = JSON.parse(response.responseJSON.d);

                                if (_data != null) {

                                    if (_data.length > 0) {
                                        $.each(_data, function (_index, _item) {
                                            var _strHTML = "";
                                            _strHTML += "<tr>";
                                            _strHTML += '<td><div class="checkbox"><label><input type="checkbox" name="modifiers" data-itemId="' + _item.SalesItemID + '" value="' + _item.Description + '" > ' + _item.Description + ' </label> </div></td>';
                                            _strHTML += "</tr>";

                                            $("#modifierModal1 .modal-body table").append(_strHTML);
                                        });

                                        $("#modifierModal1").modal('show');
                                    }

                                }
                            }
                        }

                    });
                }

                if ($(this).data("modifier2") != null) {
                    //bring the popup
                    $.ajax({
                        url: '../webpos.asmx/GetModifierList',
                        cache: true,
                        method: 'post',
                        data: '{"cBranchID": ' + localStorage.getItem("cBranchID") + ',"ModifierID": ' + $(this).data("modifier2") + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        beforeSend: function (e, d) {
                            /* $("#itemsList").html("<i class='fa fa-spinner fa-spin'></i>");

                            $("#groupList a").fadeIn(100, function () {
                            $("input[type='search']").val("");
                            });*/

                        },
                        complete: function (response) {
                            $("#modifierModal2 .modal-body table tr").remove()
                            if (response.status === 200) {
                                var _data = JSON.parse(response.responseJSON.d);

                                if (_data != null) {

                                    if (_data.length > 0) {
                                        $.each(_data, function (_index, _item) {
                                            var _strHTML = "";
                                            _strHTML += "<tr>";
                                            _strHTML += '<td><div class="checkbox"><label><input type="checkbox" name="modifiers" data-itemId="' + _item.SalesItemID + '" value="' + _item.Description + '" > ' + _item.Description + ' </label> </div></td>';
                                            _strHTML += "</tr>";

                                            $("#modifierModal2 .modal-body table").append(_strHTML);
                                        });

                                        $("#modifierModal2").modal('show');
                                    }

                                }
                            }
                        }

                    });
                }

                if ($(this).data("modifier3") != null) {
                    //bring the popup
                    $.ajax({
                        url: '../webpos.asmx/GetModifierList',
                        cache: true,
                        method: 'post',
                        data: '{"cBranchID": ' + localStorage.getItem("cBranchID") + ',"ModifierID": ' + $(this).data("modifier3") + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        beforeSend: function (e, d) {


                        },
                        complete: function (response) {
                            $("#modifierModal3 .modal-body table tr").remove();
                            if (response.status === 200) {
                                var _data = JSON.parse(response.responseJSON.d);

                                if (_data != null) {

                                    if (_data.length > 0) {
                                        $.each(_data, function (_index, _item) {
                                            var _strHTML = "<tr>";
                                            _strHTML += '<td><div class="checkbox"><label><input type="checkbox" name="modifiers" data-itemId="' + _item.SalesItemID + '" value="' + _item.Description + '" > ' + _item.Description + ' </label> </div></td>';
                                            _strHTML += "</tr>";

                                            $("#modifierModal3 .modal-body table").append(_strHTML);
                                        });

                                        $("#modifierModal3").modal('show');
                                    }

                                }
                            }
                        }

                    });
                }

                if ($(this).data("modifier4") != null) {
                    //bring the popup
                    $.ajax({
                        url: '../webpos.asmx/GetModifierList',
                        cache: true,
                        method: 'post',
                        data: '{"cBranchID": ' + localStorage.getItem("cBranchID") + ',"ModifierID": ' + $(this).data("modifier4") + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        beforeSend: function (e, d) {
                        },
                        complete: function (response) {
                            $("#modifierModal4 .modal-body table tr").remove();
                            if (response.status === 200) {
                                var _data = JSON.parse(response.responseJSON.d);

                                if (_data != null) {

                                    if (_data.length > 0) {
                                        $.each(_data, function (_index, _item) {
                                            var _strHTML = "<tr>";
                                            _strHTML += '<td><div class="checkbox"><label><input type="checkbox" name="modifiers" data-itemId="' + _item.SalesItemID + '" value="' + _item.Description + '" > ' + _item.Description + ' </label> </div></td>';
                                            _strHTML += "</tr>";

                                            $("#modifierModal4 .modal-body table").append(_strHTML);
                                        });

                                        $("#modifierModal4").modal('show');
                                    }

                                }
                            }
                        }

                    });
                }

                /* lock printing */
                $("#btnPrint").addClass("disabled");

            } else {

                /* Check for remarks */
                var _parentId;
                if ($("table.items tbody tr:last-child").data("setmenu")) {
                    _parentId = $("table.items tbody tr:last-child").data("parentid");
                } else {
                    _parentId = $("table.items tbody tr:last-child").data("itemid");
                }

                var _strHTML = '';
                _strHTML += '<tr class="temp" data-itemid="' + $(this).data("itemid") + '" data-parentid="' + _parentId + '" data-setid="' + _itemsetid + '" data-odt="' + _orderinDateTime + '">';
                _strHTML += '    <td><a href="#" class="btn btn-danger btn-xs trash"><i class="fa fa-trash"></i></a></td>';
                _strHTML += '    <td class="qty" align="right">1</td>'

                if ($(this).data("function-id") === 3) {
                    _strHTML += '<td><a href="#edit"><strong>' + $(this).text().trim() + '</strong></a></td>';
                    _strHTML += '<td class="price" align="right" data-itemprice="' + parseFloat($(this).data("price")).toFixed(2) + '">' + parseFloat($(this).data("price")).toFixed(2) + '</td>';
                    _floatPoint = true;
                    $("#openFunction").modal("show");
                    $("#openFunction #foPrice").val("");
                } else {
                    _strHTML += '    <td>' + $(this).text() + '</td>';
                    _strHTML += '    <td class="price" align="right">0.00</td>';
                }


                _strHTML += '    <td></td>';
                _strHTML += '    <td><label class="label label-danger">Selected</label></td>';
                _strHTML += '</tr>';


                $("table.items tbody").append(_strHTML);


                fnScroll2Bottom();
            }
    }




});

function fnGetItemSetId(itemid) {
    return itemid + "-" + ($("table.items tbody tr[data-itemid='" + itemid + "'] ").length + 1);
}



$(document).on("click touchstart", "table.items a.trash", function (e) {
    e.preventDefault();

    var _tempTr = $(this).parents("tr");
    var _tempItemID = $(_tempTr).data("setid");

    if ($(_tempTr).find("td:eq(2)").text().trim().lastIndexOf("**") != -1) {
        $(_tempTr).remove();
    } else {
        $("table.items tbody tr[data-setid='" + _tempItemID + "']").remove();
    }

    CalcPrice();

    /* Free to print */
    if ($("table.items a.trash").length === 0) {
        $("#btnPrint").removeClass("disabled");
    }
});

$(document).on(clickOrtouchend, "table.items a[href='#edit']", function (e) {
    e.preventDefault();

    var _itemID = $(this).parents("tr").data("itemid");
    var _itemTitle = $(this).text().trim();
    var _itemPrice = $(this).parent("td").next().data("itemprice").trim();
    var _itemQty = $(this).parent("td").prev().text().trim();
    var _itemRemark = $(this).next().text();

    $("#newItemSalesID").val($(this).parents("tr").index());

    $("#newItemTitle").text(_itemTitle);
    $("#newItemPrice").text(_itemPrice);
    $(".qty-controller input").val(_itemQty);
    $("#txtItemRemarks").val(_itemRemark);
    $("#itemAdd").modal("show");
});

$("#itemAdd").on('shown.bs.modal', function () {
    $('#txtItemRemarks').focus();
});

/* Workstation List */
fnLoadWorkstations = function () {
    $.ajax({
        url: '../webpos.asmx/WorkstationList',
        method: 'post',
        data: '{"cBranchID": '+ localStorage.getItem("cBranchID") +'}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        beforeSend: function (e, d) {

        },
        complete: function (response) {
            if (response.status === 200) {
                var _data = JSON.parse(response.responseJSON.d);

                if (_data != null) {
                    $("#wsList option").remove();

                    $.each(_data, function (_index, _ws) {
                        $("#wsList").append("<option value='" + _ws.WorkstationID + "'>" + _ws.Description + "</option>");
                    });

                    $("#wsList").prepend("<option value='0'>--Select Workstation--</option>");
                    $("#wsList").val("1");
                }

            } else {
                alert("Workstation Not Loaded!");
            }
        }
    });
}


/** Quantity **/

$(document).on(clickOrtouchend, ".qty-controller .input-group-addon", function (e) {
   
    
    switch ($(this).index()) {
        case 0:
            /*++*/

            var _preQty = $(this).next().val();
            if (_preQty.indexOf(".") != -1)
                _preQty = (parseFloat(_preQty) + 1).toFixed(3);
            else
                _preQty = parseInt(_preQty) + 1;

            $(this).next().val(_preQty);

            /* Cal Price */
            CalcUnitPrice(this, _preQty);

            break;
        case 2:
            /*--*/
            var _preQty = $(this).prev().val();

            if (_preQty.lastIndexOf(".") != -1) {

                if (parseFloat(_preQty) > 1)
                    _preQty = (parseFloat(_preQty) - 1).toFixed(3);
                else
                    _preQty = 1.00;

                $(this).prev().val(_preQty);

                /* Cal Price */
                CalcUnitPrice(this, _preQty);
            }
            else {

                if (parseInt(_preQty) > 1)
                    _preQty = parseInt(_preQty) - 1;
                else
                    _preQty = 1;

                $(this).prev().val(_preQty);

                /* Cal Price */
                CalcUnitPrice(this, _preQty);

            }
            break;
    }
});

$(document).on("change", ".qty-controller input[type='text']", function () {
    CalcUnitPrice(this, this.value);
});

CalcUnitPrice = function (_obj, qty) {
    var _priceCol = $(_obj).parents("td").next();
    var _unitPrice = $(_priceCol).data("unitprice");
    $(_priceCol).text((parseFloat(_unitPrice) * qty).toFixed(2));

    /* Calculate Total Price */
    CalcPrice();
}

CalcPrice = function () {
    var _totalPrice = 0.0;
    $("table.items tbody tr").each(function (_index, _tr) {
        _totalPrice = _totalPrice + parseFloat($(_tr).find("td.price").text().trim());
    });
    $(".total-price").text(_totalPrice.toFixed(2));
}

/* Search */

$(document).on("keyup change", "input[type='search']", function () {
    var _value = $(this).val();
    if ($("#groupList").css("display") != "none") {
        /*Search in Group*/
        fnSearchItems('groupList', _value);
    } else {
        /*Search in Items*/
        fnSearchItems('itemsList', _value);
    }
});

fnSearchItems = function (_locTarget, _value) {
    $("#" + _locTarget + " a").each(function (_index, _a) {
        if ($(_a).find("span").text().toLowerCase().lastIndexOf(_value.toLowerCase()) != -1) {
            $(_a).fadeIn('fast');
        } else {
            $(_a).fadeOut('fast');
        }
    });
}






var SelectedItems = new Array();

function newItem(itemId, qty, desc, price, custId, status, unknow1, unknow2, assigned, incTax, orderGUID, orderBy, setMenu, orderingDT) {
    this.itemId = itemId;
    this.qty = qty;
    this.desc = desc;
    this.price = price;
    this.custId = custId;
    this.status = status;
    this.unknow1 = unknow1;
    this.unknow2 = unknow2; // ItemRemarks
    this.assigned = assigned;
    this.incTax = incTax;
    this.orderGUID = orderGUID;
    this.orderBy = orderBy;
    this.setMenu = setMenu;
    this.orderingDT = orderingDT;
}

$("#btnOrder").click(function () {
    $("#btnOrder").attr("disabled");
    $(".preloader").fadeIn();
    SelectedItems.length = 0;

    $("table.items tbody tr.temp").each(function (_index, _tr) {

        var _itemDesc = "";
        var _itemRemark = "";
        if ($(_tr).find("td:eq(2) a").length == 1) {
            _itemDesc = $(_tr).find("td:eq(2) a").text().trim();
            _itemRemark = $(_tr).find("td:eq(2) a").next().text();
        } else {
            _itemDesc = $(_tr).find("td:eq(2)").text().trim();
        }
        var _setMenu = $(_tr).data("setmenu");
        var _oDT = $(_tr).data("odt");
        SelectedItems[SelectedItems.length++] = new newItem(
           $(_tr).data("itemid"),
           $(_tr).find("td.qty").text().trim(),
           _itemDesc,
           $(_tr).find("td.price").text().trim(),
           0,
           "Selected",
           0,
           _itemRemark,
           0,
           0,
           "",
           window.localStorage.getItem("EmployeeID"),
           _setMenu,
           _oDT
        );
    });

    var _cbId = window.localStorage.getItem("cBranchID");
    var _bId = window.localStorage.getItem("BranchID");
    var _wsId = $("#wsList").val();
    var _empNo = window.localStorage.getItem("EmployeeID");
    var _orderId = window.localStorage.getItem("orderId");
    var _orderNo = window.localStorage.getItem("orderNo");
    var _noGuest = window.localStorage.getItem("guestcount");

    var _custID = localStorage.getItem("cCustID");
    var _deliveryTime = localStorage.getItem("deliveryTime");
    var _deliveryStatus = localStorage.getItem("deliveryStatus");
    var _paidBy = $("#ddlPayType").val();
    var _totalAmount = $(".total-price").text();
    $(".preloader").fadeIn();

    webpos.PrintKitchenOrder(_cbId, _bId, _wsId, _empNo, _orderId, _orderNo, _noGuest, SelectedItems, _custID, _deliveryTime, _deliveryStatus, _paidBy, _totalAmount, function (sObj) {
        $(".preloader").fadeIn();
        if (sObj) {
            window.location = "../customers";
        }
    }, function (eObj) {
        $(".preloader").fadeOut();
        console.log(eObj);
    });

});

$("#btnPrint").click(function () {
    $(".preloader").fadeIn();
    if ($("table.items tbody tr").length === 0) {
        alert("No items to print the Invoice!");
        return false;
    }

    SelectedItems.length = 0;

    $("table.items tbody tr.temp").each(function (_index, _tr) {

        var _itemDesc = "";
        var _itemRemark = "";
        if ($(_tr).find("td:eq(2) a").length == 1) {
            _itemDesc = $(_tr).find("td:eq(2) a").text().trim();
            _itemRemark = $(_tr).find("td:eq(2) a").next().text();
        } else {
            _itemDesc = $(_tr).find("td:eq(2)").text().trim();
        }
        var _setMenu = $(_tr).data("setmenu");
        var _oDT = $(_tr).data("odt");
        SelectedItems[SelectedItems.length++] = new newItem(
           $(_tr).data("itemid"),
           $(_tr).find("td.qty").text().trim(),
           _itemDesc,
           $(_tr).find("td.price").text().trim(),
           0,
           "Selected",
           0,
           _itemRemark,
           0,
           0,
           "",
           window.localStorage.getItem("EmployeeID"),
           _setMenu,
           _oDT
        );
    });

    var _cbId = window.localStorage.getItem("cBranchID");
    var _bId = window.localStorage.getItem("BranchID");
    var _wsId = $("#wsList").val();
    var _orderId = window.localStorage.getItem("orderId");
    var _closedBy = window.localStorage.getItem("EmployeeID");
    var _totalPrice = $(".total-price").text();
    var _orderNo = window.localStorage.getItem("orderNo");
    var _noGuest = window.localStorage.getItem("guestcount");
    var _orderType = localStorage.getItem("MenuTypeID");

    var _custID = localStorage.getItem("cCustID");
    var _deliveryTime = localStorage.getItem("deliveryTime");
    var _deliveryStatus = localStorage.getItem("deliveryStatus");
    var _paidBy = $("#ddlPayType").val();
    var _totalAmount = $(".total-price").text();

    webpos.PrintInvoice(_cbId, _bId, _wsId, _orderType, _orderId, _closedBy, _orderNo, _noGuest, _totalPrice, SelectedItems, _custID, _deliveryTime, _deliveryStatus, _paidBy, _totalAmount, function (sObj) {
        $(".preloader").fadeIn();
        if (sObj) {
            window.location = "../customers"
        }
    }, function (eObj) {
        $(".preloader").fadeOut();
        console.log(eObj);
    });


});

function fnGetItemsNextRowNo() {
    return $("table.items tobidy tr").length + 1;
}

$(document).on("click", ".btn-done", function () {
    
    var _selectedModifier = $(this).parents("div.modal").find("input[name='modifiers']:checked");
    if (_selectedModifier.length != 0) {

        var _parentId;
        if ($("table.items tbody tr:last-child").data("setmenu")) {
            _parentId = $("table.items tbody tr:last-child").data("parentid");
        } else {
            _parentId = $("table.items tbody tr:last-child").data("itemid");
        }

        $(_selectedModifier).each(function (_index, _ele) {
            var _strHTML = '';
            _strHTML += '<tr class="temp" data-itemid="' + $(_ele).data("itemid") + '" data-parentid="' + _parentId + '" data-setid="' + _itemsetid + '" data-odt="' + (new Date()).toLocaleString().replace(",", "") + '">';
            _strHTML += '    <td><a href="#" class="btn btn-danger btn-xs trash"><i class="fa fa-trash"></i></a></td>';
            _strHTML += '    <td class="qty" align="right">1</td><td>' + $(_ele).val() + '</td>';
            _strHTML += '    <td class="price" align="right">0.00</td>';
            _strHTML += '    <td></td>';
            _strHTML += '    <td><label class="label label-danger">Selected</label></td>';
            _strHTML += '</tr>';

            $("table.items tbody").append(_strHTML);
        });

    }
    fnScroll2Bottom();

    $("input[name='modifiers']:checked").parents("div.modal").modal("hide");

});




$("#btnUpdateItem").click(function () {

    var _qty = $(".qty-controller input").val();
    var _itemRemarks = $("#txtItemRemarks").val().trim();
    var _rwNo = $("#newItemSalesID").val();
    var _price = $("#newItemPrice").text();
    var rw = $("table.items tbody tr:eq(" + _rwNo + ")");

    $(rw).find("td.qty").text(_qty);

    if ($(rw).find("td:eq(2) .item-remarks").length === 0) {
        $(rw).find("td:eq(2)").append("<small class='item-remarks'>" + _itemRemarks + "</small>");
    } else {
        $(rw).find("td:eq(2) .item-remarks").text(_itemRemarks);
    }

    $(rw).find("td.price").text((_qty * _price).toFixed(2));

    CalcPrice();

    $("#itemAdd").modal("hide");
});


$(".btn-home").click(function () {

    if ($("table.items tbody tr.old").length == 0) {
        /*delete order*/
        webpos.DeleteOrder(window.localStorage.getItem("cBranchID"), window.localStorage.getItem("orderId"), window.localStorage.getItem("cCustID"), function (sObj) { window.location = "../customers"; }, function (fObj) { conosle.log(fObj) });
    }
    /*Unlock*/
    webpos.RefreshTable(window.localStorage.getItem("cBranchID"), window.localStorage.getItem("BranchID"), window.localStorage.getItem("orderNo"), function (sObj) { console.log(sObj); }, function (fObj) { console.log(fObj); })
    window.location = "../customers";
    return false;
});

$("#updateCustNo").click(function () {

    webpos.UpdateNumberOfCustomers(window.localStorage.getItem("orderId"), $("#tableCovers").val(), function (sObj) {
        if (sObj) {
            localStorage.setItem("guestcount", $("#tableCovers").val());
            $(".guestcount").text($("#tableCovers").val());
            $("#divSucess").html("Successfully updated!").removeClass("hide");

        }
    }, function (fObj) { console.log(fObj) });

    return false;
});

$("#btnKitchenRemarks").click(function () {

    webpos.UpdateKitchenRemarks(window.localStorage.getItem("orderId"), $("#txtKitchenRemarks").val(), function (sObj) {
        if (sObj) {
            
            $("#divSucess").html("Successfully updated!").removeClass("hide");
        }
    }, function (fObj) { console.log(fObj) })

});

$("#btnBillRemarks").click(function () {

    webpos.UpdateInvoiceRemarks(window.localStorage.getItem("orderId"), $("#txtBillRemarks").val(), function (sObj) {
        if (sObj) {
            $("#divSucess").html("Successfully updated!").removeClass("hide");
        } 
      }, function (fObj) { console.log(fObj) })

});

$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $("#divSucess").addClass("hide").html("");
});

/******* Open Function ********/
var _floatPoint = true;
$(document).on(clickOrtouchend, "#openFunction .numpad-list li", function () {
    var _numKey = $(this).data("value");
    var _foPrice = $("#foPrice").val();
    switch (_numKey) {
        case "back":
            _foPrice = _foPrice.substr(0, _foPrice.length - 1)
            $("#foPrice").val(_foPrice);
            break;
        case "clear":
            $("#foPrice").val("");
            break;
        case "ok":

            var _tdPrice = $("table.items tbody tr:last-child td.price");
            $(_tdPrice).data("itemprice", parseFloat($("#foPrice").val()).toFixed(2));
            $(_tdPrice).text(parseFloat($("#foPrice").val()).toFixed(2));

            $("#openFunction").modal("hide");

            CalcPrice();

            $("table.items tbody tr:last-child td:eq(2) a").click();

            break;
        default:
            if (_floatPoint) {
                _foPrice += _numKey;
            } else {
                if (_numKey === ".")
                    _numKey = "";

                _foPrice += _numKey;
            }
            if (_numKey === ".") { _floatPoint = false; }
            $("#foPrice").val(_foPrice);
    }

});