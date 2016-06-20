

$("form[name='formSignin']").submit(function (e) {
    e.preventDefault();
    var _username = $("#username").val();
    var _pasword = $("#password").val();
    webpos.apAdminLogin(_username, _pasword,
    function (res) {
        if (res == "1") {
            location.href = "branches/";
        } else {
            alert("Invalid Username/Password");
        }
    },
    function (res) {
        console.log(res)
    });
});
