localStorage.clear();

document.ontouchmove = function (event) { event.preventDefault(); }

var iOS = ((/iphone|ipad/gi).test(navigator.appVersion));
var clickOrtouchend = iOS ? "touchstart" : "click";

var _tempResponse;
$(document).on(clickOrtouchend, ".numpad-list li", function () {
    var _numKey = $(this).data("value");
    var _userid = $("#Username").val();
    var _password = $("#Password").val();
    switch (_numKey) {
        case "clear":

            if ($(".userid").css("display") != "none") {
                $("#Username").val("");

            }

            if ($(".password").css("display") != "none") {
                if ($("#Password").val().trim().length === 0) {
                    $(".userid").css("display", "block"); $("#Username").val("")
                    $(".password, #errMsg").css("display", "none");
                } else {
                    $("#Password").val("");
                }
            }

            break;
        case "ok":

            if ($(".userid").css("display") != "none") {

                var _branchId = $("#BranchID").val();
                var _userName = $("#Username").val();

                var _params = '{ "Username": "' + _userName + '"}';

                $.ajax({
                    type: "POST",
                    url: 'webpos.asmx/EmpLogin',
                    data: _params,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    beforeSend: function (e, d) {

                    },
                    complete: function (response) {

                        if (response.status === 200) {
                            var _data = JSON.parse(response.responseJSON.d)[0];

                            if (_data != null) {

                                if (_data.ePassword.length === 0) {
                                    window.localStorage.setItem("EmployeeID", _data.eID);
                                    window.localStorage.setItem("EmployeeName", _data.eFullName);
                                    window.localStorage.setItem("EmployeeCode", _data.eEmployeeCode);
                                    window.location = "customers";
                                } else {

                                    $(".userid").hide();
                                    $(".password").show();

                                    _tempResponse = _data;
                                }


                            } else {
                                $("#errMsg").html("<p><i class='fa fa-exclamation-triangle '></i> " + _userError + "</p>").css("display", "block");
                            }
                        } else {
                            $("#errMsg").html("<i class='fa fa-exclamation-triangle'></i> " + response.statusText).css("display", "block"); ;
                        }
                    }
                });

            }

            if ($(".password").css("display") != "none") {

                var _password = $("#Password").val();

                if (_password === _tempResponse.ePassword) {

                    window.localStorage.setItem("EmployeeID", _tempResponse.eID);
                    window.localStorage.setItem("EmployeeName", _tempResponse.eFullName);
                    window.localStorage.setItem("EmployeeCode", _tempResponse.eEmployeeCode);
                    window.location = "customers";

                } else {
                    $("#errMsg").html("<p><i class='fa fa-exclamation-triangle '></i> " + _passwordError + "</p>").css("display", "block");
                }

            }

            break;
        default:

            if ($(".userid").css("display") != "none") {
                _userid = _userid + _numKey;
                $("#Username").val(_userid);
            }

            if ($(".password").css("display") != "none") {
                _password = _password + _numKey;
                $("#Password").val(_password);
            }

    }

});