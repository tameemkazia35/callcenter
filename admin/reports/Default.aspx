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
            <button type="button" id="btnExport" class="btn btn-primary pull-right" >Export to Excel <i class="fa fa-download"></i></button>
        </div>
    </div>
   
    <div class="row well collapse" id="collapseExample">
        
            
            <div class="form-group col-md-3">
                <label>
                    Date:</label><br />
                <button class="btn btn-default" id="daterange-btn">
                    <i class="fa fa-calendar"></i>  Date range picker <i class="fa fa-caret-down"></i>
                </button>
            </div> 
            <div class="form-group col-md-3">
                <label>
                    Customer Phone:</label>
                <input class="form-control" type="text" placeholder="Phone Number" id="mobileno"
                    autofocus autocomplete="off" required />
            </div>
            <div class="form-group col-md-3">
                <label>
                    Driver Name:</label>
                <input class="form-control" type="text" placeholder="Driver Name" id="drivername"
                    autofocus autocomplete="off" required />
            </div>
            <div class="form-group col-md-3">
                <label>
                    Branch Name:</label>
                <input class="form-control" type="text" placeholder="Branch Name" id="branchname"
                    autofocus autocomplete="off" required />
            </div>
            <div class="form-group col-md-12">
                <button type="button" class="btn btn-primary" id="Search">
                    Search <i class="fa fa-search"></i></button> |  <button type="button" class="btn btn-default" id="btnSave" onclick="fnLoad()">
                    View All <i class="fa fa-file"></i></button>
            </div>
           
       
    </div>
    <div class="row">
        
        <div class="col-lg-12 table-responsive" id="ExportId">
            <table class="table" id="branches">                
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

        var dataToGetExcel;
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
                dataToGetExcel = _data;
                fnBindTableData(_data);

            }, function (res) {

            });
        }

        $(document).ready(function () {
            fnLoad();
        });

        //---------------------- method to render data on to the table -------------------------------------------------------

        function fnBindTableData(_tbdData) {

            $("#branches tr").remove();
            var tableHeader = '<tr><th>Branch Name</th><th>Order</th><th>Customer</th><th class="text-right"></th><th>Driver Name</th><th>Delivery Status</th><th>Paid by</th></tr>';
            $("#branches").append(tableHeader);
            var counter = 0;
            var sum = 0;
            $.each(_tbdData, function (index, b) {
                counter++;
                sum += b.amount;
                var strHTML = '<tr>';
                strHTML += '    <td>' + b.BranchName + '</td>';
                strHTML += '    <td>' + b.OrderNumber + '<br  /><i class="fa fa-calendar"></i>: ' + moment(b.OrdDateTime).format('MM/DD/YYYY h:mm A') + '</td>';
                strHTML += '    <td>' + b.CustomerName + '<br  /><i class="fa fa-phone" title="Phone Number"></i>: ' + b.phoneno + '<br  /><i class="fa fa-home" title="Address"></i>:  ' + b.OrdAddress + '</td>';
                strHTML += '    <td class="text-right">' + b.amount.toFixed(2) + '</td>';
                strHTML += '    <td>' + b.DriverName + '</td>';
                strHTML += '    <td>' + b.DeliveryStatus + '<br  /><i class="fa fa-clock-o" title="Dispatch Time" ></i>:  ' + b.DespatchTime + '<br  /><i class="fa fa-bell" title="Delivery Time"></i>:  ' + b.DeliveryTime + '</td>';
                strHTML += '    <td>' + b.paidby + '</td>';
                strHTML += '</tr>';

                $("#branches").append(strHTML);
            });

                     var tFooter = '<tr><td colspan="3" class="text-right"><strong>Total Amount: </strong></td><td class="text-right"><strong>' + sum.toFixed(2) + '</td><td colspan="3"></td></tr>';
                     tFooter += '<tr><td colspan="3" class="text-right"><strong>Total Orders: </strong></td><td class="text-right"><strong>' + counter + '</strong></td><td colspan="3"></td></tr>';
                     $("#branches").append(tFooter);

        }

        //-----------------------method to get Orders base on Search --------------------------------------------------------

        $(document).on("click", "#Search", function () {

            var fromDate = localStorage.getItem("fromDate1");
            var toDate = localStorage.getItem("toDate1");
            var mobile = $("#mobileno").val();
            var driverName = $("#drivername").val();
            var branchname = $('#branchname').val();

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
            if (branchname != "") {
                whereClause += "and  BranchName = '" + branchname + "' ";
            }
            if (whereClause.length > 0) {
                whereClause = " WHERE " + whereClause.slice(3);
            }

            webpos.apGetOrders(whereClause, function (res) {
                _data = JSON.parse(res);
                dataToGetExcel = _data;
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
                $("#mobileno").val(item.split('|')[0].trim());
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


        $('#branchname').typeahead({
            hint: true,
            highlight: true,
            minLength: 1,
            source: function (request, response) {
                webpos.GetBranchInfoByName(request, function (data) {
                    response(data);
                }, function () {

                });
            },
            afterSelect: function (item) {
                $("#Search").click();
            }
        });

        $("#btnExport").click(function (e) {

            var _now = new Date();
            var str = "_" + _now.getDate() + "_" + _now.getMonth() + "_" + _now.getYear();

            $.each(dataToGetExcel, function (indx, obj) { //orderDateTime deliverytime
                var dd1 = new Date(parseInt(obj.OrdDateTime.substr(6)));
                dataToGetExcel[indx].OrdDateTime = dd1.toLocaleDateString() + " " + dd1.toLocaleTimeString();
                delete dataToGetExcel[indx].CusOrdNo;
                delete dataToGetExcel[indx].bID;
                delete dataToGetExcel[indx].BranchID;
                delete dataToGetExcel[indx].WorkStationID;
                delete dataToGetExcel[indx].OrderID;
                delete dataToGetExcel[indx].OrderMenuID;
                delete dataToGetExcel[indx].DriverId;
                delete dataToGetExcel[indx].DeliverystatusID;
                delete dataToGetExcel[indx].CustomerID;

            });
            JSONToCSVConvertor(dataToGetExcel, "Order_Report" + str, true);
        });


        function JSONToCSVConvertor(JSONData, ReportTitle, ShowLabel) {
            //If JSONData is not an object then JSON.parse will parse the JSON string in an Object
            var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;

            var CSV = '';
            //Set Report title in first row or line

            CSV += ReportTitle + '\r\n\n';

            //This condition will generate the Label/Header
            if (ShowLabel) {
                var row = "";

                //This loop will extract the label from 1st index of on array
                for (var index in arrData[0]) {

                    //Now convert each value to string and comma-seprated
                    row += index + ',';
                }

                row = row.slice(0, -1);

                //append Label row with line break
                CSV += row + '\r\n';
            }

            //1st loop is to extract each row
            for (var i = 0; i < arrData.length; i++) {
                var row = "";

                //2nd loop will extract each column and convert it in string comma-seprated
                for (var index in arrData[i]) {
                    row += '"' + arrData[i][index] + '",';
                }

                row.slice(0, row.length - 1);

                //add a line break after each row
                CSV += row + '\r\n';
            }

            if (CSV == '') {
                alert("Invalid data");
                return;
            }

            //Generate a file name
            var fileName = "";
            //this will remove the blank-spaces from the title and replace it with an underscore
            fileName += ReportTitle.replace(/ /g, "_");

            //Initialize file format you want csv or xls
            var uri = 'data:text/csv;charset=utf-8,' + escape(CSV);

            // Now the little tricky part.
            // you can use either>> window.open(uri);
            // but this will not work in some browsers
            // or you will not get the correct file extension    

            //this trick will generate a temp <a /> tag
            var link = document.createElement("a");
            link.href = uri;

            //set the visibility hidden so it will not effect on your web-layout
            link.style = "visibility:hidden";
            link.download = fileName + ".csv";

            //this part will append the anchor tag and remove it after automatic click
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

    </script>
</asp:Content>