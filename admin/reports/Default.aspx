<%@ Page Title="" Language="VB" MasterPageFile="~/admin/site.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="admin_branches_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-lg-12">
            <h3>
                Reports
            </h3>
        </div>
    </div>
     <div class="row">
        <div class="col-lg-12">
            <a class="btn btn-primary" role="button" data-toggle="collapse" href="#collapseExample" aria-expanded="false" aria-controls="collapseExample"><i class="fa fa-filter"></i> | Filter</a>
        </div>
    </div>
   
    <div class="row collapse" id="collapseExample">
        <div class="col-md-4">
            
            <div class="form-group">
                <label>
                    Date:</label>
                <button class="btn btn-default" id="daterange-btn">
                    <i class="fa fa-calendar"></i>  Date range picker <i class="fa fa-caret-down"></i>
                </button>
            </div> 
            <div class="form-group">
                <label>
                    customer Phone:</label>
                <input class="form-control" type="text" placeholder="Phone Number" id="mobileno"
                    autofocus autocomplete="off" required />
            </div>
            <div class="form-group">
                <label>
                    Driver Name:</label>
                <input class="form-control" type="text" placeholder="Driver Name" id="drivername"
                    autofocus autocomplete="off" required />
            </div>
            <div class="form-group">
                <button type="button" class="btn btn-primary" id="Search">
                    Search <i class="fa fa-search"></i></button> |  <button type="button" class="btn btn-default" id="btnSave" onclick="fnLoad()">
                    View All <i class="fa fa-file"></i></button>
            </div>
           
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 table-responsive">
            <table class="table" id="branches">
                <thead>
                    <tr>
                        <th>
                            Branch Name
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
                            Driver Name
                        </th>
                        <th>
                            Delivery Status
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
    </div>
</asp:Content>
<asp:Content ID="sc1" ContentPlaceHolderID="cphCustomScripts" runat="Server">
    <script src="../../js/jquery-1.11.1.min.js" type="text/javascript"></script>
    <script src="../../js/bootstrap.min.js" type="text/javascript"></script>
    <script src="../js/jquery.dataTables.min.js" type="text/javascript"></script>
    <script src="../js/bootstrapValidator.min.js" type="text/javascript"></script>
    <script src="../../js/jquery.serialize-object.js" type="text/javascript"></script>
    <script src="../../js/bootstrap3-typeahead.min.js" type="text/javascript"></script>
    <script src="../../js/moment.min.js" type="text/javascript"></script>
    <script src="../../js/bootstrap-datetimepicker.min.js" type="text/javascript"></script>
    <script src="../../js/daterangepicker/daterangepicker.js" type="text/javascript"></script>
    <script>

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

            $("#branches tbody tr").remove();
            $.each(_tbdData, function (index, b) {

                var strHTML = '<tr>';
                strHTML += '    <td>' + b.BranchName + '</td>';
                strHTML += '    <td>' + b.OrderNumber + '<br  /><i class="fa fa-calendar"></i>: ' + moment(b.OrdDateTime).format('MM/DD/YYYY h:mm A') + '</td>';
                strHTML += '    <td>' + b.CustomerName + '<br  /><i class="fa fa-phone" title="Phone Number"></i>: ' + b.phoneno + '<br  /><i class="fa fa-home" title="Address"></i>:  ' + b.OrdAddress + '</td>';
                strHTML += '    <td>' + b.amount + '</td>';
                strHTML += '    <td>' + b.DriverName + '</td>';
                strHTML += '    <td>' + b.DeliveryStatus + '<br  /><i class="fa fa-clock-o" title="Dispatch Time" ></i>:  ' + b.DespatchTime + '<br  /><i class="fa fa-bell" title="Delivery Time"></i>:  ' + b.DeliveryTime + '</td>';
                strHTML += '    <td>' + b.paidby + '</td>';
                strHTML += '</tr>';

                $("#branches tbody").append(strHTML);
            });

        }

//-----------------------method to get Orders base on Search --------------------------------------------------------

        $(document).on("click", "#Search", function () {

            var fromDate = localStorage.getItem("fromDate1");
            var toDate = localStorage.getItem("toDate1");
            var mobile = $("#mobileno").val();
            var driverName = $("#drivername").val();

            var whereClause = "";
            if (fromDate != null) {
                whereClause += "and  OrdDateTime between '" + fromDate + " 00:00:00.000' and  '" + toDate + " 23:59:59.999' ";
            }

            if (mobile != "") {
                whereClause += "and  phoneno = '" + mobile + "' ";
            }

            if (driverName != "") {
                whereClause += "and  DriverName = '" + driverName + "' ";
            }
            if (whereClause.length > 0) {
                whereClause = " WHERE "+ whereClause.slice(3);    
            }
            
            webpos.apGetOrders(whereClause, function (res) {
                _data = JSON.parse(res);
                fnBindTableData(_data);

            }, function (res) {

            });

        });

        //------------------auto complete methods ----------------------------------------------

        $('#mobileno').typeahead({
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

        $('#drivername').typeahead({
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

    </script>
</asp:Content>
