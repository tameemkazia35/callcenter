webpos.GetPaymentTypes(function (response) {
    var _data = JSON.parse(response);
    $.each(_data, function (_index, _pay) {
        var _strHTML = "";
        _strHTML += '<li class="list-group-item">';
        _strHTML += '<div class="row">';
        _strHTML += '   <div class="col-xs-8"><button type="button" id="' + _pay["PaymentTypeID"] + '" class="btn-block btn-lg"  data-paytypeid="' + _pay["PayTypeID"] + '">' + _pay["Payment Type"] + '</button></div>';
        _strHTML += '   <div class="col-xs-4"><input class="form-control input-lg" disabled /></div>';
        _strHTML += '</div>';
        _strHTML += '</li>';
        
        $("#paymentTypeList").append(_strHTML);
    });

}, function (response) {
    console.log(response);
});