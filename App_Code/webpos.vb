Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

Imports System.Configuration


<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class webpos
    Inherits System.Web.Services.WebService

    Dim strcon As String = ConfigurationManager.ConnectionStrings("Dataconnection").ConnectionString
    Dim con As SqlConnection = New SqlConnection(strcon)
    Dim itemfacade As New G5BOCL.ItemFacade
    Dim ResOps As Resturant.Operations

    Dim sqlConSB As New SqlConnection()


    <WebMethod()> _
    Public Function HelloWorld() As String
        Return "Hello World"
    End Function

    Public Sub opencn()
        If con.State = ConnectionState.Closed Then
            con.Open()
        End If
    End Sub



    <WebMethod()> _
    Public Function LoadMenuItems(ByVal BranchId As String, ByVal EmployeeId As String) As String
        Dim dsConfig = SqlHelper.ExecuteDataset(con, "POS_SEL_EmployeeConfigurationSettings", New SqlParameter("@BranchID", BranchId), New SqlParameter("@EmployeeID", EmployeeId))
        Return ConvertData2Json(dsConfig.Tables(0))
    End Function

#Region "ConvertData2Json"
    Function ConvertData2Json(ByVal dt As DataTable) As String
        Dim serializer As JavaScriptSerializer = New JavaScriptSerializer()
        Dim rows As New List(Of Dictionary(Of String, Object))
        Dim row As Dictionary(Of String, Object)

        For Each dr As DataRow In dt.Rows
            row = New Dictionary(Of String, Object)
            For Each col As DataColumn In dt.Columns
                row.Add(col.ColumnName, dr(col))
            Next
            rows.Add(row)
        Next
        Return serializer.Serialize(rows)
    End Function
#End Region

    <WebMethod(EnableSession:=True)> _
    Public Function EmpLogin(ByVal Username As String) As String
        Dim _sql As String = String.Format("select eID, eEmployeeCode, ePassword, eType, eFullName, eStatus from dbo.tbl_Employee where eEmployeeCode='{0}';", Username)
        Dim _sqlCmd As SqlCommand = New SqlCommand()
        _sqlCmd.CommandText = _sql
        Dim _dtTemp = (New DataAccessLayer()).GetData(_sqlCmd, CommandType.Text)
        HttpContext.Current.Session("EmployeeCode") = _dtTemp.Rows(0)("eEmployeeCode")
        Return ConvertData2Json(_dtTemp)
    End Function

    ' SalesItem = 1
    ' Group = 2
    ' Screen = 3
    <WebMethod()> _
    Public Function GetScreenItems(ByVal cBranchID As Integer, ByVal BranchID As Integer, ByVal ScreenID As Integer, ByVal Type As Integer) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Dim _dtTemp = SqlHelper.ExecuteDataset(sqlConSB, CommandType.StoredProcedure, "POS_SEL_Screens",
                                               New SqlParameter("@BranchID", BranchID), New SqlParameter("@ParentID", ScreenID), New SqlParameter("@ItemTypeID", Type)).Tables(0)
        Return ConvertData2Json(_dtTemp)
    End Function


    <WebMethod()> _
    Public Function GroupList() As String
        Dim _sql As String = String.Format("select distinct groupname, groupid, isnull(screenno,0)screenno from dbo.View_Web_Itemdisplay where division <> 'Modifiers' order by screenno asc;")
        Dim _sqlCmd As SqlCommand = New SqlCommand()
        _sqlCmd.CommandText = _sql
        Dim _dtTemp = (New DataAccessLayer()).GetData(_sqlCmd, CommandType.Text)
        Return ConvertData2Json(_dtTemp)
    End Function

    <WebMethod()> _
    Public Function WorkstationList(ByVal cBranchID As Integer) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Dim _dtTemp = SqlHelper.ExecuteDataset(sqlConSB, CommandType.Text, "Select WorkstationID, Description from BOF_S_Workstations where len(Description) <> 0;").Tables(0)
        Return ConvertData2Json(_dtTemp)
    End Function

    <WebMethod()> _
    Public Function GetItemList(ByVal GroupID As String) As String
        Dim _sqlCmd As SqlCommand = New SqlCommand()
        _sqlCmd.CommandText = "Pro_Web_Itemdisplay"
        _sqlCmd.Parameters.AddWithValue("@groupid", GroupID)
        Dim _dtTemp = (New DataAccessLayer()).GetData(_sqlCmd)
        Return ConvertData2Json(_dtTemp)
    End Function

    <WebMethod()> _
    Public Function GetModifierList(ByVal cBranchID As Integer, ByVal ModifierID As String) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Dim _dtTemp = SqlHelper.ExecuteDataset(sqlConSB, "POS_SEL_ItemModifiers", New SqlClient.SqlParameter("@ModifierID", ModifierID)).Tables(0)
        Return ConvertData2Json(_dtTemp)
    End Function

    <WebMethod(EnableSession:=True)> _
    Public Function GetOpenTables(ByVal BranchID As Integer, ByVal tableType As Integer) As String
        Dim empid = HttpContext.Current.Session("EmployeeId")

        Dim emppermission As DataSet = SqlHelper.ExecuteDataset(strcon,
                                                                CommandType.StoredProcedure, _
                                                                "POS_SEL_EmployeeConfigurationSettings",
                                                                New SqlClient.SqlParameter("@BranchID", 1),
                                                                New SqlClient.SqlParameter("@EmployeeID", empid))
        Dim OpenTablesAccess As Boolean = False
        If emppermission.Tables(0).Rows.Count > 0 Then
            OpenTablesAccess = emppermission.Tables(0).Rows(0).Item("OpenTablesAccess")
        End If


        Dim currentuser As New G5BOCL.Employee(BranchID, empid)

        Dim myopenorder As New G5BOCL.Operations(strcon)
        Dim dsopenorder As New DataSet
        dsopenorder = myopenorder.LoadOpenOrders(currentuser.UserID, BranchID, tableType, currentuser.UserID, OpenTablesAccess)

        Return ConvertData2Json(dsopenorder.Tables(0))
    End Function

    <WebMethod(EnableSession:=True)> _
    Public Function RefreshTable(ByVal cBranchID As Integer, ByVal BranchID As Integer, ByVal TableNo As String) As Boolean
        Dim tablerefresh As New G5BOCL.Operations(GetSelectedBranchDBStr(cBranchID))
        If tablerefresh.OrderExist(1, TableNo, G5BOCL.OrderType.Table) = True Or tablerefresh.OrderExist(1, TableNo, G5BOCL.OrderType.Table1) = True Or tablerefresh.OrderExist(1, TableNo, G5BOCL.OrderType.Delivery) = True Then

            Dim con As New SqlConnection
            con.ConnectionString = GetSelectedBranchDBStr(cBranchID)
            Dim cm1 As New SqlCommand("Update Pos_M_Orders set lock=0 where branchid=" & BranchID & "and orderid =" & tablerefresh.GetOrderID(BranchID, TableNo), con)
            con.Open()
            cm1.ExecuteNonQuery()
            con.Close()

            Return True
        End If

        Return False
    End Function

    <WebMethod(EnableSession:=True)> _
    Public Function GetEmpRights(ByVal BranchID As Integer) As String
        Dim empid = HttpContext.Current.Session("EmployeeId")

        Dim emppermission As DataSet = SqlHelper.ExecuteDataset(strcon,
                                                                CommandType.StoredProcedure, _
                                                                "POS_SEL_EmployeeConfigurationSettings",
                                                                New SqlClient.SqlParameter("@BranchID", 1),
                                                                New SqlClient.SqlParameter("@EmployeeID", empid))

        Return ConvertData2Json(emppermission.Tables(0))
    End Function

    <WebMethod(EnableSession:=True)> _
    Public Function OpenOrCreateOrder(ByVal BranchID As Integer, ByVal TableNo As String, ByVal NoOfCust As Integer) As Boolean

        Dim empid = HttpContext.Current.Session("EmployeeId")
        Dim cworkstationid = 1
        Dim orderid As Integer
        Dim mystatus As Integer
        Dim ordopenedby As Integer
        Dim Order As G5BOCL.Order

        Dim Str = "select orderid,openedby,ordernumber,status,openingtime from POS_M_Orders where ordernumber = '" & TableNo & "' and totalpaid is null and status <> 2"
        Dim com As SqlCommand = New SqlCommand(Str, con)
        Dim da As SqlDataAdapter = New SqlDataAdapter(com)
        Dim dt As New DataTable
        da.Fill(dt)
        If dt.Rows.Count <> 0 Then
            mystatus = dt.Rows(0).Item("status")
            orderid = dt.Rows(0).Item("orderid")
            ordopenedby = dt.Rows(0).Item("openedby")
        Else
            mystatus = 2
        End If

        Select Case mystatus
            Case 0

                Dim resops As New G5BOCL.Operations(strcon)

                If resops.OrderExist(1, Val(TableNo), 1) Then
                    Order = New G5BOCL.Order(1, 1, Val(TableNo))

                    Dim cm As New SqlCommand("select lock from Pos_M_Orders where branchid=1 and orderid =" & Order.OrderID, con)
                    Dim lock As Boolean
                    con.Open()
                    lock = cm.ExecuteScalar
                    con.Close()

                    Dim emppermission1 As DataSet = SqlHelper.ExecuteDataset(strcon,
                                                                             CommandType.StoredProcedure,
                                                                             "POS_SEL_EmployeeConfigurationSettings",
                                                                             New SqlClient.SqlParameter("@BranchID", 1),
                                                                             New SqlClient.SqlParameter("@EmployeeID", empid))

                    Dim OpenTablesAccess2 As Boolean = emppermission1.Tables(0).Rows(0).Item("OpenTablesAccess")

                    If lock = False Then
                        If Order.OpenedBy = empid Or OpenTablesAccess2 = True Then
                            Dim cm3 As New SqlCommand("Update Pos_M_Orders set lock=1 where branchid=" & 1 & " and orderid =" & orderid, con)
                            con.Open()
                            cm3.ExecuteNonQuery()
                            con.Close()
                            Return True
                        End If
                    End If
                End If

                Exit Select
            Case 1

                Dim emppermission1 As DataSet = SqlHelper.ExecuteDataset(strcon,
                                                                     CommandType.StoredProcedure,
                                                                     "POS_SEL_EmployeeConfigurationSettings",
                                                                     New SqlClient.SqlParameter("@BranchID", 1),
                                                                     New SqlClient.SqlParameter("@EmployeeID", empid))

                Dim OpenTablesAccess1 As Boolean = emppermission1.Tables(0).Rows(0).Item("OpenTablesAccess")

                If ordopenedby = empid Or OpenTablesAccess1 = True Then
                    Dim resops As New G5BOCL.Operations(strcon)
                    If resops.OrderExist(1, Val(TableNo), 1) Then
                        Order = New G5BOCL.Order(1, 1, Val(TableNo))
                    End If
                    Return True
                End If

                Exit Select
            Case 2

                Order = New G5BOCL.Order(1, 1, G5BOCL.OrderType.Table, empid, Val(TableNo), NoOfCust)
                Dim com2 = New SqlCommand("Update Pos_M_Orders set lock=1 where branchid=1 and orderid =" & Order.OrderID, con)
                con.Open()
                com2.ExecuteNonQuery()
                con.Close()

                Return True

                Exit Select
        End Select

        Return False
    End Function

    <WebMethod()> _
    Public Function LockTable(ByVal OrderId As Integer) As Boolean
        Dim com2 = New SqlCommand("Update Pos_M_Orders set lock=1 where branchid=1 and orderid =" & OrderId, con)
        con.Open()
        com2.ExecuteNonQuery()
        con.Close()
        Return True
    End Function

    'Gettign the Orders
    <WebMethod()> _
    Public Function GetOrderItemsList(ByVal cBranchID As Integer, ByVal BranchID As Integer, ByVal OrderID As Integer) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Dim _tempDt As DataTable = SqlHelper.ExecuteDataset(sqlConSB, "POS_SEL_OrderDetails",
                                                            New SqlClient.SqlParameter("@BranchID", BranchID),
                                                            New SqlClient.SqlParameter("@OrderID", OrderID)).Tables(0)
        Return ConvertData2Json(_tempDt)
    End Function

    Sub UnlockTable(ByVal cBranchID As Integer, ByVal BranchID As Integer, ByVal OrderID As Integer)
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        'Unlock table
        SqlHelper.ExecuteNonQuery(sqlConSB, CommandType.Text, "Update Pos_M_Orders set lock=0 where branchid=" & BranchID & " and orderid =" & OrderID)
    End Sub


#Region "MakeOrder"

    Private Sub AssignOrderToEmployee(ByVal EmpId As Integer, ByVal ItemId As String, ByVal Orderid As Integer)
        Dim sql As String = String.Format("UPDATE POS_M_OrderDetails SET OrderbyEmployeeId ={0} WHERE (ItemID = {1}) AND (OrderID = {2})", EmpId, ItemId, Orderid)
        Dim comm As New SqlCommand
        comm.CommandText = sql
        comm.Connection = con
        comm.CommandType = CommandType.Text
        con.Open()
        comm.ExecuteNonQuery()
        con.Close()
    End Sub

    <WebMethod()> _
    Public Function NewOrder(ByVal BranchID As Integer, ByVal WorkstationID As Integer, ByVal OrderType As Integer, ByVal OrderNumber As Integer,
                         ByVal NumberOfCustomers As Integer, ByVal UserID As Integer) As Integer

        Dim resops As New G5BOCL.Operations(strcon)
        System.Threading.Thread.Sleep(200)

        If Not resops.OrderExist(BranchID, OrderNumber, OrderType) Then
            Dim cmd As New SqlClient.SqlCommand("POS_INS_Order", con)
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@BranchID", BranchID)
            cmd.Parameters.AddWithValue("@WorkstationID", WorkstationID)
            cmd.Parameters.AddWithValue("@OrderNumber", OrderNumber)
            cmd.Parameters.AddWithValue("@OrderMenuID", OrderType)
            cmd.Parameters.AddWithValue("@NumberOfCustomers", NumberOfCustomers)
            cmd.Parameters.AddWithValue("@OpenedBy", UserID)
            cmd.Parameters.AddWithValue("@RevMenuID", OrderType)


            Dim p9 As New SqlClient.SqlParameter("@OrderID", SqlDbType.Int, 4, _
                ParameterDirection.Output, False, CType(0, Byte), _
                CType(0, Byte), "", DataRowVersion.Current, Nothing)
            cmd.Parameters.Add(p9)

            con.Open()
            cmd.ExecuteNonQuery()
            con.Close()

            Return Integer.Parse(p9.Value)
        Else

            Return (New G5BOCL.Operations(strcon)).GetOrderID(BranchID, OrderNumber)
        End If


    End Function

    <WebMethod()> _
    Public Function DeleteOrder(ByVal cBranchID As Integer, ByVal OrderId As Integer, ByVal cCustID As Integer) As Integer
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Dim sql = ""
        Dim _rst = 0
        sql = String.Format("select Count(*)isFound from POS_M_OrderDetails where OrderID={0}", OrderId)
        If SqlHelper.ExecuteScalar(sqlConSB, CommandType.Text, sql).Equals(0) Then
            sql = String.Format("Delete from POS_M_Orders where OrderId={0}", OrderId)
            _rst = SqlHelper.ExecuteNonQuery(sqlConSB, CommandType.Text, sql)
            SqlHelper.ExecuteNonQuery(con, CommandType.Text, String.Format("DELETE FROM POS_Delivery_CusOrdList WHERE bID={0} and OrderID={1} and CustomerID={2};", cBranchID, OrderId, cCustID))
        End If

        Return _rst
    End Function

#End Region


#Region "Order Printing"

    Sub webMakeOrder(ByVal cBranchID As Integer, ByVal BranchId As Integer, ByVal WsId As Integer, ByVal OrderId As Integer, ByVal selectedItems As Object())
        Dim Status As String = "", AffectedItem As Integer, VoidReasonID, VoidMethodID As Int16
        Dim Quantity As Double, Price As Double
        Dim OrderFound As Boolean
        Dim VoidExist As Boolean = False
        Dim _empID = 0



        For Each item As Object In selectedItems
            Dim newGUID = Guid.NewGuid.ToString()

            Dim dicItems As New Dictionary(Of String, Object)()
            dicItems = DirectCast(item, Dictionary(Of String, Object))

            _empID = dicItems("orderBy")



            If dicItems("status").ToString() = "Selected" Then
                OrderFound = True
                If dicItems("qty") > 0 Then
                    Quantity = dicItems("qty")
                    Price = (dicItems("price") / dicItems("qty")) - dicItems("incTax")
                    AffectedItem = 0
                    VoidReasonID = 0
                    If dicItems("status").ToString() = "Hold" Then
                        Status = "Hold"
                    Else
                        Status = "Ordered"
                    End If
                    VoidMethodID = 0
                ElseIf dicItems("qty") < 0 Then
                    Quantity = dicItems("qty")
                    Price = (dicItems("price") / dicItems("qty")) - dicItems("incTax")
                    AffectedItem = 0
                    VoidReasonID = 0
                    'AffectedItem = CType(lstOrderedItems.Items(i).Tag, DataRow).Item("AffectedItem")
                    'VoidReasonID = CType(lstOrderedItems.Items(i).Tag, DataRow).Item("VoidReasonID")
                    If AffectedItem = 0 And VoidReasonID = 0 Then
                        Status = "Ordered"
                        VoidMethodID = 0
                    Else
                        Status = "Void"
                        VoidMethodID = 1
                        VoidExist = True
                    End If

                ElseIf dicItems("qty") = 0 Then
                    Quantity = 0
                    Price = 0
                    AffectedItem = 0
                    VoidReasonID = 0
                    Status = "Modifier"
                    VoidMethodID = 0
                End If
                ''TODO here i have to change the substring (-) into the one entered in BOF
                If dicItems("desc").ToString().Substring(0, 3) = "(-)" And dicItems("qty") > 0 Then
                    Quantity = dicItems("qty")
                    Price = 0
                    Status = "Extra Remark"
                    'If dicItems("assigned").ToString() = "" Then
                    '    lstOrderedItems.Items(i).SubItems(8).Text = 0
                    'End If
                    SaveItem(BranchId, WsId,
                   OrderId, dicItems("itemId"), Quantity, _
                    Price, dicItems("custId"), AffectedItem, VoidReasonID, _
                    VoidMethodID, Status, dicItems("orderBy"), 1, 1, dicItems("unknow2"), _
                    0, 0, dicItems("assigned"), newGUID)

                Else ''
                    If dicItems("desc").ToString().Substring(0, 3) = "(+)" And dicItems("qty") > 0 Then
                        Status = "Extra Remark"
                        If dicItems("incTax") = "" Then
                            dicItems("incTax") = 0
                        End If
                        SaveItem(BranchId, WsId, _
                        OrderId, dicItems("itemId"), Quantity, _
                        Price, dicItems("custId"), AffectedItem, VoidReasonID, _
                        VoidMethodID, Status, dicItems("orderBy"), 1, 2, dicItems("unknow2"), _
                        0, 0, dicItems("incTax"), newGUID)
                    Else
                        If dicItems("desc").LastIndexOf("**") <> -1 And Price = 0 Then

                            SaveItem(cBranchID, BranchId, WsId, OrderId,
                                              dicItems("itemId"), Quantity, Price,
                                              dicItems("custId"), AffectedItem, VoidReasonID,
                                              VoidMethodID, Status, dicItems("orderBy"),
                                              1, 0, dicItems("unknow2"),
                                              0, 0, dicItems("incTax"), newGUID)

                        ElseIf (Price = 0) Then

                            SaveItem(cBranchID, BranchId, WsId, OrderId,
                                              dicItems("itemId"), Quantity, Price,
                                              dicItems("custId"), AffectedItem, VoidReasonID,
                                              VoidMethodID, Status, dicItems("orderBy"),
                                              1, 0, dicItems("unknow2"),
                                              0, 0, dicItems("incTax"), newGUID, True)

                        Else

                            SaveItem(cBranchID, BranchId, WsId, OrderId,
                                              dicItems("itemId"), Quantity, Price,
                                              dicItems("custId"), AffectedItem, VoidReasonID,
                                              VoidMethodID, Status, dicItems("orderBy"),
                                              1, 0, dicItems("unknow2"),
                                              0, 0, dicItems("incTax"), newGUID)


                        End If


                        If dicItems("status") = "Selected" Then
                            sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)

                            SqlHelper.ExecuteNonQuery(sqlConSB, CommandType.StoredProcedure, "POS_UPD_H_OrderDetails",
                            New SqlClient.SqlParameter("@BranchID", BranchId),
                            New SqlClient.SqlParameter("@OrderID", OrderId),
                            New SqlClient.SqlParameter("@ItemID", dicItems("itemId")),
                            New SqlClient.SqlParameter("@Status", Status),
                            New SqlClient.SqlParameter("@OrderGuid", newGUID))

                        End If

                    End If
                End If
            End If

        Next

    End Sub


    Function SaveItem(ByVal cBranchID As Integer, ByVal BranchID As Integer, ByVal WorkstationID As Integer, _
        ByVal OrderID As Integer, ByVal ItemID As Integer, ByVal Quantity As Double, _
    ByVal Price As Double, ByVal CustomerNumber As Integer, ByVal AffectedItem As Integer, _
        ByVal VoidReasonID As Integer, ByVal VoidMethodID As Integer, ByVal Status As String, _
        ByVal OrderedBy As Integer, ByVal PriceModeID As Integer, Optional ByVal Without As Integer = 0, _
        Optional ByVal ItemRemark As String = "", Optional ByVal FormulaID As Integer = 0, _
        Optional ByVal assigned As String = "", Optional ByVal inctax As Decimal = 0, _
        Optional ByVal OrderGuid As String = "", Optional ByVal SetMenu As Boolean = False) As String

        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)



        Try
            Dim rst = SqlHelper.ExecuteNonQuery(sqlConSB, CommandType.StoredProcedure, "POS_INS_OrderDetails",
                New SqlClient.SqlParameter("@BranchID", BranchID),
                New SqlClient.SqlParameter("@WorkstationID", WorkstationID),
                New SqlClient.SqlParameter("@OrderID", OrderID),
                New SqlClient.SqlParameter("@ItemID", ItemID),
                New SqlClient.SqlParameter("@Quantity", Quantity),
                New SqlClient.SqlParameter("@UsedPrice", Price),
                New SqlClient.SqlParameter("@CustomerNumber", CustomerNumber),
                New SqlClient.SqlParameter("@AffectedItem", AffectedItem),
                New SqlClient.SqlParameter("@VoidReasonID", VoidReasonID),
                New SqlClient.SqlParameter("@VoidMethodID", VoidMethodID),
                New SqlClient.SqlParameter("@Status", Status),
                New SqlClient.SqlParameter("@OrderedBy", OrderedBy),
                New SqlClient.SqlParameter("@PriceModeID", PriceModeID),
                New SqlClient.SqlParameter("@ItemRemark", ItemRemark),
                New SqlClient.SqlParameter("@Without", Without),
                New SqlClient.SqlParameter("@Assigned", assigned),
                New SqlClient.SqlParameter("@inctax", inctax),
                New SqlClient.SqlParameter("@OrderGuid", OrderGuid),
                New SqlClient.SqlParameter("@SetMenu", SetMenu),
                New SqlClient.SqlParameter("@OrderingTime", DateTime.Now))
            Return rst.ToString()
        Catch ex As Exception
            Return ex.Message
        Finally
            con.Close()
        End Try

    End Function

    <WebMethod()> _
    Public Function PrintKitchenOrder(ByVal cBranchID As Integer,
                                      ByVal BranchId As Integer,
                                      ByVal WsId As Integer,
                                      ByVal EmpNo As Integer,
                                      ByVal OrderId As Integer,
                                      ByVal TableNo As String,
                                      ByVal NoGuest As Integer,
                                      ByVal selectedItems As Object(),
                                      ByVal custID As String,
                                      ByVal deliveryTime As String,
                                      ByVal deliveryStatus As String,
                                      ByVal paidBy As String,
                                      ByVal totalAmount As String) As Boolean
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Dim resops As New G5BOCL.Operations(GetSelectedBranchDBStr(cBranchID))


        If Not resops.OrderExist(BranchId, TableNo, Resturant.OrderType.Delivery) Then
            Dim NewOrder = New G5BOCL.Order(BranchId, WsId, Resturant.OrderType.Delivery, EmpNo, TableNo, NoGuest)
            OrderId = NewOrder.OrderID
        End If

        webMakeOrder(cBranchID, BranchId, WsId, OrderId, selectedItems)

        UnlockTable(cBranchID, BranchId, OrderId)

        Dim drSysSettings = SqlHelper.ExecuteDataset(sqlConSB, CommandType.Text, "SELECT * FROM BOF_S_SystemSettings;").Tables(0).Rows(0)
        Dim prtResult = True

        Dim _serviceInvoice As New WebReference_GWServiceInvoice.InvoiceService()
        _serviceInvoice.Url = GetSelectedBranchGWServiceInvoice(cBranchID)
        If drSysSettings("UsePDAService") Then
            prtResult = _serviceInvoice.PrintKitchenOrder(BranchId, OrderId)
        End If


        'Cleaning the Temp values
        SqlHelper.ExecuteNonQuery(sqlConSB, CommandType.StoredProcedure, "POS_DEL_T_OrderDetails", New SqlClient.SqlParameter("@BranchID", BranchId), New SqlClient.SqlParameter("@OrderID", OrderId))

        Dim dcustObj As New Class_POS_Delivery_CusOrdList

        dcustObj.amount = totalAmount
        dcustObj.DeliveryTime = deliveryTime
        dcustObj.DeliveryStatus = deliveryStatus
        dcustObj.paidby = paidBy

        dcustObj.OrderID = OrderId
        dcustObj.BranchID = BranchId
        dcustObj.bID = cBranchID
        dcustObj.CustomerID = custID

        UpdateReport2CallCenter(dcustObj)
        UpdateReport2SelectedBranch(cBranchID, dcustObj)

        Return prtResult

    End Function

#End Region

    <WebMethod()> _
    Public Function GetItemsFromSetMenu(ByVal cBranchID As Integer, ByVal ItemId As Integer, ByVal Qty As Integer) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Dim _tempDs = SqlHelper.ExecuteDataset(sqlConSB, CommandType.StoredProcedure, _
                            "[POS_SEL_SETMENU]", New SqlClient.SqlParameter("@ItemId", ItemId), New SqlClient.SqlParameter("@Qty", Qty))
        If _tempDs.Tables.Count > 0 Then
            Return ConvertData2Json(_tempDs.Tables(0))
        Else
            Return ""
        End If


    End Function

    <WebMethod()> _
    Public Function UpdateKitchenRemarks(ByVal OrderId As Integer, ByVal KitchenRemarks As String) As Boolean
        Dim _sql = String.Format("UPDATE POS_M_Orders set KitchenRemark='{1}' WHERE OrderId={0};", OrderId, KitchenRemarks)
        Dim rst = SqlHelper.ExecuteNonQuery(con, CommandType.Text, _sql)
        If rst > 0 Then
            Return True
        Else
            Return False
        End If
    End Function

    <WebMethod()> _
    Public Function UpdateInvoiceRemarks(ByVal OrderId As Integer, ByVal invoiceRemark As String) As Boolean
        Dim _sql = String.Format("UPDATE POS_M_Orders set InvoiceRemark='{1}' WHERE OrderId={0};", OrderId, invoiceRemark)
        Dim rst = SqlHelper.ExecuteNonQuery(con, CommandType.Text, _sql)
        If rst > 0 Then
            Return True
        Else
            Return False
        End If
    End Function

    <WebMethod()> _
    Public Function UpdateNumberOfCustomers(ByVal OrderId As Integer, ByVal NumberOfCustomers As Integer) As Boolean
        Dim _sql = String.Format("UPDATE POS_M_Orders set NumberOfCustomers='{1}' WHERE OrderId={0};", OrderId, NumberOfCustomers)
        Dim rst = SqlHelper.ExecuteNonQuery(con, CommandType.Text, _sql)
        If rst > 0 Then
            Return True
        Else
            Return False
        End If
    End Function

    <WebMethod()> _
    Public Function GetMoreOptions(ByVal OrderId As Integer) As String
        Dim _sql = String.Format("SELECT NumberOfCustomers, InvoiceRemark, KitchenRemark FROM   POS_M_Orders  WHERE OrderId={0};", OrderId)
        Dim cmdSelect = New SqlCommand(_sql, con)
        Dim adp = New SqlDataAdapter(cmdSelect)
        Dim _tempDataTable As New DataTable()
        _tempDataTable.Clear()

        adp.Fill(_tempDataTable)

        Return ConvertData2Json(_tempDataTable)
    End Function

    <WebMethod()> _
    Public Function GetDriveThruOrderNo() As String
        Return SqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT (isnull(max(OrderNumber), 30000)+1)OrderNumber from POS_M_Orders where OrderMenuID=5 and isnull(EODDate, 0)=0")
    End Function

#Region "Branches"

    Function GetSelectedBranchDBStr(ByVal BranchID As String) As String
        Return SqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT bDBConnectionString FROM tbl_Branch WHERE bID=" + BranchID + ";").Tables(0).Rows(0)(0)
    End Function

    Function GetSelectedBranchGWService(ByVal BranchID As String) As String
        Return SqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT bOrderingWSurl FROM tbl_Branch WHERE bID=" + BranchID + ";").Tables(0).Rows(0)(0)
    End Function

    Function GetSelectedBranchGWServiceInvoice(ByVal BranchID As String) As String
        Return SqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT bInvoiceWSurl FROM tbl_Branch WHERE bID=" + BranchID + ";").Tables(0).Rows(0)(0)
    End Function

    <WebMethod()> _
    Public Function GetAllBranches() As String
        Dim _sql As String = String.Format("select * from tbl_Branch;")
        Dim _sqlCmd As SqlCommand = New SqlCommand()
        _sqlCmd.CommandText = _sql
        Dim _dtTemp = (New DataAccessLayer()).GetData(_sqlCmd, CommandType.Text)

        Return ConvertData2Json(_dtTemp)
    End Function

    <WebMethod()> _
    Public Function PingBranch(ByVal ip As String) As Boolean
        Return My.Computer.Network.Ping(ip)
    End Function

    <WebMethod()> _
    Public Function GetEmpID(ByVal ccBranchID As String, ByVal EmployeeCode As String) As String
        sqlConSB.ConnectionString = SqlHelper.ExecuteDataset(con, CommandType.Text, String.Format("SELECT bDBConnectionString FROM tbl_Branch WHERE bID={0};", ccBranchID)).Tables(0).Rows(0)(0)
        Return SqlHelper.ExecuteDataset(sqlConSB, CommandType.Text, "SELECT EmployeeID FROM BOF_M_Employees WHERE EmployeeCode='" + EmployeeCode + "';").Tables(0).Rows(0)("EmployeeID")
    End Function

    <WebMethod()> _
    Public Function GetDriverList(ByVal cBranchID As Integer) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Dim dtTemp = SqlHelper.ExecuteDataset(sqlConSB, CommandType.Text, "SELECT e.EmployeeID, e.EmployeeName FROM BOF_M_Employees e, BOF_M_EmplyeeTimePriceModes f WHERE e.EmployeeID = f.EmployeeID and MenuID=2 and FunctionID=4 and e.Status='IN'").Tables(0)
        Return ConvertData2Json(dtTemp)
    End Function

    'Check Existing Order
    <WebMethod()> _
    Public Function CheckExistingOrder(ByVal cBranchID As Integer, ByVal BranchID As Integer, ByVal CustID As Integer) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)

        Dim CustOrder = SqlHelper.ExecuteDataset(sqlConSB, CommandType.StoredProcedure, "POS_SEL_OpenOrdersByCustomer",
                                                New SqlClient.SqlParameter("@BranchID", BranchID),
                                                New SqlClient.SqlParameter("@OrderType", Resturant.OrderType.Delivery),
                                                New SqlClient.SqlParameter("@CustomerID", CustID)).Tables(0)
        Return ConvertData2Json(CustOrder)
    End Function

    <WebMethod()> _
    Public Function GetCustomerInfoByMobileNo(ByVal prefix As String) As String()
        Dim customers As New List(Of String)()
        con.Open()
        Using sdr As SqlDataReader = SqlHelper.ExecuteReader(con, CommandType.Text, "SELECT top 10 cMobileNo, (select bName from tbl_Branch where bID=cBranchId)bName  FROM tbl_Customers WHERE cMobileNo like '" + prefix + "%';")
            While sdr.Read()
                customers.Add(sdr("cMobileNo") & " | " & sdr("bName"))
            End While
        End Using
        con.Close()
        Return customers.ToArray()
    End Function

    <WebMethod()> _
    Public Function GetCustomerInfoByHomeNo(ByVal prefix As String) As String()
        Dim customers As New List(Of String)()
        con.Open()
        Using sdr As SqlDataReader = SqlHelper.ExecuteReader(con, CommandType.Text, "SELECT top 10 cHomeNo, (select bName from tbl_Branch where bID=cBranchId)bName FROM tbl_Customers WHERE cHomeNo like '" + prefix + "%';")
            While sdr.Read()
                customers.Add(sdr("cHomeNo") & " | " & sdr("bName"))
            End While
        End Using
        con.Close()
        Return customers.ToArray()
    End Function

    <WebMethod()> _
    Public Function GetCustomerInfoByOfficeNo(ByVal prefix As String) As String()
        Dim customers As New List(Of String)()
        con.Open()
        Using sdr As SqlDataReader = SqlHelper.ExecuteReader(con, CommandType.Text, "SELECT top 10 cOfficeNo, (select bName from tbl_Branch where bID=cBranchId)bName FROM tbl_Customers WHERE cOfficeNo like '" + prefix + "%';")
            While sdr.Read()
                customers.Add(sdr("cOfficeNo") & " | " & sdr("bName"))
            End While
        End Using
        con.Close()
        Return customers.ToArray()
    End Function

    <WebMethod()> _
    Public Function GetDriverInfoByName(ByVal prefix As String) As String()
        Dim driver As New List(Of String)()
        con.Open()
        Using sdr As SqlDataReader = SqlHelper.ExecuteReader(con, CommandType.Text, "SELECT distinct DriverName FROM POS_Delivery_CusOrdList WHERE DriverName like '" + prefix + "%';")
            While sdr.Read()
                driver.Add(sdr("DriverName"))
            End While
        End Using
        con.Close()
        Return driver.ToArray()
    End Function

   

    <WebMethod()> _
    Public Function GetUserInfoByNumber(ByVal Type As String, ByVal Number As String, ByVal BranchName As String) As String
        Dim dtTemp As New DataTable()

        If Type.Equals("mobileno") Then
            dtTemp = SqlHelper.ExecuteDataset(con, "usp_GetUserInfoByMobile", New SqlClient.SqlParameter("@cMobileNo", Number), New SqlClient.SqlParameter("@BranchName", BranchName)).Tables(0)
        ElseIf Type.Equals("homephone") Then
            dtTemp = SqlHelper.ExecuteDataset(con, "usp_GetUserInfoByHomeNo", New SqlClient.SqlParameter("@cHomeNo", Number), New SqlClient.SqlParameter("@BranchName", BranchName)).Tables(0)
        ElseIf Type.Equals("officephone") Then
            dtTemp = SqlHelper.ExecuteDataset(con, "usp_GetUserInfoByOfficeNo", New SqlClient.SqlParameter("@cOfficeNo", Number), New SqlClient.SqlParameter("@BranchName", BranchName)).Tables(0)
        End If

        Return ConvertData2Json(dtTemp)
    End Function

    <WebMethod()>
    Public Function SaveCustomerInfo(ByVal custInfo As Object()) As String

        Dim dicCust As New Dictionary(Of String, Object)()
        dicCust = DirectCast(custInfo(0), Dictionary(Of String, Object))

        Dim rstSQL = SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_SaveCustomer",
                        New SqlClient.SqlParameter("@custID", dicCust("custID")),
                        New SqlClient.SqlParameter("@custBID", dicCust("custBID")),
                        New SqlClient.SqlParameter("@cFirstname", dicCust("cFirstname")),
                        New SqlClient.SqlParameter("@cFamilyname", dicCust("cFamilyname")),
                        New SqlClient.SqlParameter("@cCompany", dicCust("cCompany")),
                        New SqlClient.SqlParameter("@cMobileNo", dicCust("cMobileNo")),
                        New SqlClient.SqlParameter("@cHomeNo", dicCust("cHomeNo")),
                        New SqlClient.SqlParameter("@cOfficeNo", dicCust("cOfficeNo")),
                        New SqlClient.SqlParameter("@cCity", dicCust("cCity")),
                        New SqlClient.SqlParameter("@cStreet", dicCust("cStreet")),
                        New SqlClient.SqlParameter("@cBuilding", dicCust("cBuilding")),
                        New SqlClient.SqlParameter("@cFloor", dicCust("cFloor")),
                        New SqlClient.SqlParameter("@cZone", dicCust("cZone")),
                        New SqlClient.SqlParameter("@cAppartment", dicCust("cAppartment")),
                        New SqlClient.SqlParameter("@cNear", dicCust("cNear")),
                        New SqlClient.SqlParameter("@cPAOtherNo", dicCust("cPAOtherNo")),
                        New SqlClient.SqlParameter("@cPAFax", dicCust("cPAFax")),
                        New SqlClient.SqlParameter("@cPAEmail", dicCust("cPAEmail")),
                        New SqlClient.SqlParameter("@cPAZipCode", dicCust("cPAZipCode")),
                        New SqlClient.SqlParameter("@cSAOtherNo", dicCust("cSAOtherNo")),
                        New SqlClient.SqlParameter("@cSAFax", dicCust("cSAFax")),
                        New SqlClient.SqlParameter("@cSAEmail", dicCust("cSAEmail")),
                        New SqlClient.SqlParameter("@cSAZipCode", dicCust("cSAZipCode")),
                        New SqlClient.SqlParameter("@cLastSelectedBranch", dicCust("cLastSelectedBranch")))

        'Synch with Branch
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(dicCust("cLastSelectedBranch"))
        Dim resOperation = New Resturant.Operations(sqlConSB.ConnectionString)

        'Check for Existing Users
        Dim custBID As Double = 0
        Dim dtTempCust = resOperation.FindCustomer(1, dicCust("cFamilyname"), dicCust("cFirstname"), dicCust("cCompany"), dicCust("cMobileNo"), "").Tables(0)
        If dtTempCust.Rows.Count.Equals(0) Then
            custBID = resOperation.AddCustomer(1, dicCust("cFirstname"), dicCust("cFamilyname"), dicCust("cCompany"), dicCust("cHomeNo"),
                           dicCust("cMobileNo"), dicCust("cOfficeNo"), dicCust("cPAOtherNo"), dicCust("cPAFax"),
                           dicCust("cPAEmail"), "", "", dicCust("cStreet"), dicCust("cNear"), "",
                           dicCust("cBuilding"), dicCust("cCity"), dicCust("cPAZipCode"), dicCust("cFloor"), dicCust("cZone"), "",
                           dicCust("cAppartment"))
        Else
            resOperation.UpdateCustomer(1, dtTempCust.Rows(0)("CustomerID"), dicCust("cFirstname"), dicCust("cFamilyname"), dicCust("cCompany"), dicCust("cHomeNo"),
                           dicCust("cMobileNo"), dicCust("cOfficeNo"), dicCust("cPAOtherNo"), dicCust("cPAFax"),
                           dicCust("cPAEmail"), "", "", dicCust("cStreet"), dicCust("cNear"), "",
                           dicCust("cBuilding"), dicCust("cCity"), dicCust("cPAZipCode"), dicCust("cFloor"), dicCust("cZone"), "",
                           dicCust("cAppartment"))
            custBID = dtTempCust.Rows(0)("CustomerID")
        End If

        SqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE tbl_Customers SET custBID='" + custBID.ToString() + "' WHERE cMobileNo='" + dicCust("cMobileNo") + "'")

        If dicCust("custID").ToString().Length.Equals(0) Then
            dicCust("custID") = SqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT custID FROM tbl_Customers WHERE custBID='" + custBID.ToString() + "' AND cMobileNo='" + dicCust("cMobileNo") + "'")
        End If

        Return dicCust("custID") & ":" & custBID
    End Function

    <WebMethod()> _
    Public Function PrintInvoice(ByVal cBranchID As Integer,
                                 ByVal BranchID As Integer,
                                 ByVal ws As Integer,
                                 ByVal orderType As Integer,
                                 ByVal OrderID As Integer,
                                 ByVal ClosedBy As Integer,
                                 ByVal TableNo As String,
                                 ByVal NoGuest As Integer,
                                 ByVal TotalPrice As Double,
                                 ByVal selectedItems As Object(),
                                 ByVal custID As String,
                                 ByVal deliveryTime As String,
                                 ByVal deliveryStatus As String,
                                 ByVal paidBy As String,
                                 ByVal totalAmount As String) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Try
            Dim resops As New G5BOCL.Operations(GetSelectedBranchDBStr(cBranchID))

            If Not resops.OrderExist(BranchID, TableNo, orderType) Then
                Dim NewOrder = New G5BOCL.Order(BranchID, ws, orderType, ClosedBy, TableNo, NoGuest)
                OrderID = NewOrder.OrderID
            End If

            webMakeOrder(cBranchID, BranchID, ws, OrderID, selectedItems)

            'Order Closing
            SqlHelper.ExecuteScalar(sqlConSB, CommandType.StoredProcedure, "POS_UPD_CloseOrder", _
            New SqlClient.SqlParameter("@BranchID", BranchID), _
            New SqlClient.SqlParameter("@OrderID", OrderID), _
            New SqlClient.SqlParameter("@ClosedBy", ClosedBy), _
            New SqlClient.SqlParameter("@TotalPrice", TotalPrice))

            'Print KitchenOrder
            Dim drSysSettings = SqlHelper.ExecuteDataset(sqlConSB, CommandType.Text, "SELECT * FROM BOF_S_SystemSettings;").Tables(0).Rows(0)
            Dim prtResult = True

            Dim _serviceInvoice As New WebReference_GWServiceInvoice.InvoiceService()
            _serviceInvoice.Url = GetSelectedBranchGWServiceInvoice(cBranchID)
            If drSysSettings("UsePDAService") Then
                prtResult = _serviceInvoice.PrintKitchenOrder(BranchID, OrderID)
            End If


            'Cleaning the Temp values
            SqlHelper.ExecuteNonQuery(sqlConSB, CommandType.StoredProcedure, "POS_DEL_T_OrderDetails",
                                      New SqlClient.SqlParameter("@BranchID", BranchID),
                                      New SqlClient.SqlParameter("@OrderID", OrderID))

            'Print Invoice
            _serviceInvoice.PrintInvoice(BranchID, OrderID, ws)

            UnlockTable(cBranchID, BranchID, OrderID)

            Dim dcustObj As New Class_POS_Delivery_CusOrdList

            dcustObj.amount = totalAmount
            dcustObj.DeliveryTime = deliveryTime
            dcustObj.DeliveryStatus = deliveryStatus
            dcustObj.paidby = paidBy

            dcustObj.OrderID = OrderID
            dcustObj.BranchID = BranchID
            dcustObj.bID = cBranchID
            dcustObj.CustomerID = custID

            UpdateReport2CallCenter(dcustObj)
            UpdateReport2SelectedBranch(cBranchID, dcustObj)

            Return True
        Catch ex As Exception
            Return ex.Message
        End Try

        'Return "This option is coming soon"
    End Function

    <WebMethod()> _
    Public Function NewDeliveryOrder(ByVal cBrachID As String, ByVal BranchID As String, ByVal EmployeeID As String, ByVal CustID As String, ByVal CustBID As String, ByVal dDatetime As String, ByVal DriverID As Integer, ByVal DriverName As String) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBrachID)
        Dim resOperation = New Resturant.Operations(sqlConSB.ConnectionString)

        If Convert.ToDateTime(dDatetime) < resOperation.GetServerTime() Then
            dDatetime = resOperation.GetServerTime()
        End If

        Dim Order As New Resturant.Order(BranchID, 1, EmployeeID, _
                resOperation.GetLastOrderNumber(BranchID, Resturant.OrderType.Delivery) + 1, CustBID, 0, dDatetime, DriverID, False)

        Dim dtBranch = SqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT * FROM tbl_Branch WHERE bID = " + cBrachID).Tables(0)
        Dim dtCust = SqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT * FROM tbl_Customers WHERE custID = " + CustID).Tables(0)

        Dim dcusObj As New Class_POS_Delivery_CusOrdList
        dcusObj.bID = cBrachID
        dcusObj.BranchName = dtBranch.Rows(0)("bName")
        dcusObj.BranchID = BranchID
        dcusObj.WorkStationID = 1
        dcusObj.OrderID = Order.OrderID
        dcusObj.OrderMenuID = Resturant.OrderType.Delivery
        dcusObj.OrderNumber = Order.OrderNumber
        dcusObj.CustomerID = CustID
        dcusObj.CustomerName = dtCust.Rows(0)("cFirstname") + " " + dtCust.Rows(0)("cFamilyname")
        dcusObj.phoneno = dtCust.Rows(0)("cMobileNo")
        dcusObj.OrdAddress = dtCust.Rows(0)("cStreet").ToString() + ", " + dtCust.Rows(0)("cBuilding").ToString() + ", " + dtCust.Rows(0)("cFloor").ToString() + ", " + dtCust.Rows(0)("cZone").ToString() + ", " + dtCust.Rows(0)("cAppartment").ToString() + ", " + dtCust.Rows(0)("cNear").ToString()
        dcusObj.OrdDateTime = DateTime.Now

        dcusObj.DriverId = DriverID
        dcusObj.DriverName = DriverName
        dcusObj.DeliveryTime = dDatetime
        dcusObj.DeliverystatusID = 0
        dcusObj.DeliveryStatus = "Ordered"
        dcusObj.DespatchTime = ""
        dcusObj.amount = 0
        dcusObj.paidby = ""

        SaveReport2CallCenter(dcusObj)
        SaveReport2SelectedBranch(cBrachID, dcusObj)

        Return Order.OrderID.ToString() + ":" + Order.OrderNumber.ToString()
    End Function

    <WebMethod()> _
    Public Function GetPayTypes(ByVal cBranchID As String) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)
        Return ConvertData2Json(SqlHelper.ExecuteDataset(sqlConSB, CommandType.Text, "SELECT PaymentType FROM BOF_L_PaymentTypes").Tables(0))
    End Function

    Class Class_POS_Delivery_CusOrdList


        Public Property bID() As Integer
            Get
                Return m_bID
            End Get
            Set(ByVal value As Integer)
                m_bID = value
            End Set
        End Property
        Private m_bID As Integer
        Public Property BranchID() As Integer
            Get
                Return m_BranchID
            End Get
            Set(ByVal value As Integer)
                m_BranchID = value
            End Set
        End Property
        Private m_BranchID As Integer
        Public Property WorkStationID() As Integer
            Get
                Return m_WorkStationID
            End Get
            Set(ByVal value As Integer)
                m_WorkStationID = value
            End Set
        End Property
        Private m_WorkStationID As Integer
        Public Property OrderID() As Double
            Get
                Return m_OrderID
            End Get
            Set(ByVal value As Double)
                m_OrderID = value
            End Set
        End Property
        Private m_OrderID As Double
        Public Property OrderMenuID() As Integer
            Get
                Return m_OrderMenuID
            End Get
            Set(ByVal value As Integer)
                m_OrderMenuID = value
            End Set
        End Property
        Private m_OrderMenuID As Integer
        Public Property OrderNumber() As Integer
            Get
                Return m_OrderNumber
            End Get
            Set(ByVal value As Integer)
                m_OrderNumber = value
            End Set
        End Property
        Private m_OrderNumber As Integer
        Public Property CustomerID() As Integer
            Get
                Return m_CustomerID
            End Get
            Set(ByVal value As Integer)
                m_CustomerID = value
            End Set
        End Property
        Private m_CustomerID As Integer
        Public Property BranchName() As String
            Get
                Return m_BranchName
            End Get
            Set(ByVal value As String)
                m_BranchName = value
            End Set
        End Property
        Private m_BranchName As String
        Public Property CustomerName() As String
            Get
                Return m_CustomerName
            End Get
            Set(ByVal value As String)
                m_CustomerName = value
            End Set
        End Property
        Private m_CustomerName As String
        Public Property phoneno() As String
            Get
                Return m_phoneno
            End Get
            Set(ByVal value As String)
                m_phoneno = value
            End Set
        End Property
        Private m_phoneno As String
        Public Property amount() As Single
            Get
                Return m_amount
            End Get
            Set(ByVal value As Single)
                m_amount = value
            End Set
        End Property
        Private m_amount As Single
        Public Property OrdDateTime() As String
            Get
                Return m_OrdDateTime
            End Get
            Set(ByVal value As String)
                m_OrdDateTime = value
            End Set
        End Property
        Private m_OrdDateTime As String
        Public Property OrdAddress() As String
            Get
                Return m_OrdAddress
            End Get
            Set(ByVal value As String)
                m_OrdAddress = value
            End Set
        End Property
        Private m_OrdAddress As String
        Public Property DriverId() As Integer
            Get
                Return m_DriverId
            End Get
            Set(ByVal value As Integer)
                m_DriverId = value
            End Set
        End Property
        Private m_DriverId As Integer
        Public Property DriverName() As String
            Get
                Return m_DriverName
            End Get
            Set(ByVal value As String)
                m_DriverName = value
            End Set
        End Property
        Private m_DriverName As String
        Public Property DeliverystatusID() As Integer
            Get
                Return m_DeliverystatusID
            End Get
            Set(ByVal value As Integer)
                m_DeliverystatusID = value
            End Set
        End Property
        Private m_DeliverystatusID As Integer
        Public Property DeliveryStatus() As String
            Get
                Return m_DeliveryStatus
            End Get
            Set(ByVal value As String)
                m_DeliveryStatus = value
            End Set
        End Property
        Private m_DeliveryStatus As String
        Public Property DeliveryTime() As String
            Get
                Return m_DeliveryTime
            End Get
            Set(ByVal value As String)
                m_DeliveryTime = value
            End Set
        End Property
        Private m_DeliveryTime As String
        Public Property DespatchTime() As String
            Get
                Return m_DespatchTime
            End Get
            Set(ByVal value As String)
                m_DespatchTime = value
            End Set
        End Property
        Private m_DespatchTime As String
        Public Property paidby() As String
            Get
                Return m_paidby
            End Get
            Set(ByVal value As String)
                m_paidby = value
            End Set
        End Property
        Private m_paidby As String



    End Class

    Function SaveReport2CallCenter(ByVal dcusList As Class_POS_Delivery_CusOrdList) As String
        Dim _strSQL As String = ""
        _strSQL += "INSERT INTO POS_Delivery_CusOrdList "
        _strSQL += "  ([OrderID]"
        _strSQL += "  ,[bID]"
        _strSQL += "  ,[BranchID]"
        _strSQL += "  ,[WorkStationID]"
        _strSQL += "  ,[OrderMenuID]"
        _strSQL += "  ,[OrderNumber]"
        _strSQL += "  ,[CustomerID]"
        _strSQL += "  ,[BranchName]"
        _strSQL += "  ,[CustomerName]"
        _strSQL += "  ,[phoneno]"
        _strSQL += "  ,[amount]"
        _strSQL += "  ,[OrdDateTime]"
        _strSQL += "  ,[OrdAddress]"
        _strSQL += "  ,[DriverId]"
        _strSQL += "  ,[DriverName]"
        _strSQL += "  ,[DeliverystatusID]"
        _strSQL += "  ,[DeliveryStatus]"
        _strSQL += "  ,[DeliveryTime]"
        _strSQL += "  ,[DespatchTime]"
        _strSQL += "  ,[paidby])"
        _strSQL += "VALUES"
        _strSQL += "   ('" & dcusList.OrderID & "'"
        _strSQL += "   ,'" & dcusList.bID & "'"
        _strSQL += "   ,'" & dcusList.BranchID & "'"
        _strSQL += "   ,'" & dcusList.WorkStationID & "'"
        _strSQL += "   ,'" & dcusList.OrderMenuID & "'"
        _strSQL += "   ,'" & dcusList.OrderNumber & "'"
        _strSQL += "   ,'" & dcusList.CustomerID & "'"
        _strSQL += "   ,'" & dcusList.BranchName & "'"
        _strSQL += "   ,'" & dcusList.CustomerName & "'"
        _strSQL += "   ,'" & dcusList.phoneno & "'"
        _strSQL += "   ,'" & dcusList.amount & "'"
        _strSQL += "   ,'" & dcusList.OrdDateTime & "'"
        _strSQL += "   ,'" & dcusList.OrdAddress & "'"
        _strSQL += "   ,'" & dcusList.DriverId & "'"
        _strSQL += "   ,'" & dcusList.DriverName & "'"
        _strSQL += "   ,'" & dcusList.DeliverystatusID & "'"
        _strSQL += "   ,'" & dcusList.DeliveryStatus & "'"
        _strSQL += "   ,'" & dcusList.DeliveryTime & "'"
        _strSQL += "   ,'" & dcusList.DespatchTime & "'"
        _strSQL += "   ,'" & dcusList.paidby & "');"

        Return SqlHelper.ExecuteNonQuery(con, CommandType.Text, _strSQL)
    End Function

    Function SaveReport2SelectedBranch(ByVal cBranchID As Integer, ByVal dcusList As Class_POS_Delivery_CusOrdList) As String

        Dim _strSQL As String = ""
        _strSQL += "INSERT INTO POS_Delivery_CusOrdList "
        _strSQL += "  ([OrderID]"
        _strSQL += "  ,[BranchID]"
        _strSQL += "  ,[WorkStationID]"
        _strSQL += "  ,[OrderMenuID]"
        _strSQL += "  ,[OrderNumber]"
        _strSQL += "  ,[CustomerID]"
        _strSQL += "  ,[BranchName]"
        _strSQL += "  ,[CustomerName]"
        _strSQL += "  ,[phoneno]"
        _strSQL += "  ,[amount]"
        _strSQL += "  ,[OrdDateTime]"
        _strSQL += "  ,[OrdAddress]"
        _strSQL += "  ,[DriverId]"
        _strSQL += "  ,[DriverName]"
        _strSQL += "  ,[DeliverystatusID]"
        _strSQL += "  ,[DeliveryStatus]"
        _strSQL += "  ,[DeliveryTime]"
        _strSQL += "  ,[DespatchTime]"
        _strSQL += "  ,[paidby])"
        _strSQL += "VALUES"
        _strSQL += "   ('" & dcusList.OrderID & "'"
        _strSQL += "   ,'" & dcusList.BranchID & "'"
        _strSQL += "   ,'" & dcusList.WorkStationID & "'"
        _strSQL += "   ,'" & dcusList.OrderMenuID & "'"
        _strSQL += "   ,'" & dcusList.OrderNumber & "'"
        _strSQL += "   ,'" & dcusList.CustomerID & "'"
        _strSQL += "   ,'" & dcusList.BranchName & "'"
        _strSQL += "   ,'" & dcusList.CustomerName & "'"
        _strSQL += "   ,'" & dcusList.phoneno & "'"
        _strSQL += "   ,'" & dcusList.amount & "'"
        _strSQL += "   ,'" & dcusList.OrdDateTime & "'"
        _strSQL += "   ,'" & dcusList.OrdAddress & "'"
        _strSQL += "   ,'" & dcusList.DriverId & "'"
        _strSQL += "   ,'" & dcusList.DriverName & "'"
        _strSQL += "   ,'" & dcusList.DeliverystatusID & "'"
        _strSQL += "   ,'" & dcusList.DeliveryStatus & "'"
        _strSQL += "   ,'" & dcusList.DeliveryTime & "'"
        _strSQL += "   ,'" & dcusList.DespatchTime & "'"
        _strSQL += "   ,'" & dcusList.paidby & "');"

        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)

        Return SqlHelper.ExecuteNonQuery(sqlConSB, CommandType.Text, _strSQL)
    End Function

    Function UpdateReport2CallCenter(ByVal dcusList As Class_POS_Delivery_CusOrdList) As String
        Dim _strSQL As String = ""
        _strSQL += "  UPDATE POS_Delivery_CusOrdList SET "
        _strSQL += "  amount = " & dcusList.amount
        _strSQL += "  ,DeliveryStatus = '" & dcusList.DeliveryStatus & "'"
        If dcusList.DeliveryStatus.Equals("Modified") Then
            _strSQL += "  ,DeliveryTime = '" & dcusList.DeliveryTime & "'"
        End If
        _strSQL += "  ,paidby = '" & dcusList.paidby & "'"
        _strSQL += "  WHERE "
        _strSQL += "  OrderID=" & dcusList.OrderID & " and bID=" & dcusList.bID & " and BranchID=" & dcusList.BranchID & " and CustomerID=" & dcusList.CustomerID & ";"

        Return SqlHelper.ExecuteNonQuery(con, CommandType.Text, _strSQL)
    End Function

    Function UpdateReport2SelectedBranch(ByVal cBranchID As Integer, ByVal dcusList As Class_POS_Delivery_CusOrdList) As String
        Dim _strSQL As String = ""
        _strSQL += "  UPDATE POS_Delivery_CusOrdList SET "
        _strSQL += "  amount = " & dcusList.amount
        _strSQL += "  ,DeliveryStatus = '" & dcusList.DeliveryStatus & "'"
        If dcusList.DeliveryStatus.Equals("Modified") Then
            _strSQL += "  ,DeliveryTime = '" & dcusList.DeliveryTime & "'"
        End If
        _strSQL += "  ,paidby = '" & dcusList.paidby & "'"
        _strSQL += "  WHERE "
        _strSQL += "  OrderID=" & dcusList.OrderID & " and BranchID=" & dcusList.BranchID & " and CustomerID=" & dcusList.CustomerID & ";"

        sqlConSB.ConnectionString = GetSelectedBranchDBStr(cBranchID)

        Return SqlHelper.ExecuteNonQuery(sqlConSB, CommandType.Text, _strSQL)
    End Function

    <WebMethod()> _
    Function GetPaidByType(ByVal cBranchID As String, ByVal OrderId As String, ByVal CustID As String) As String
        Return SqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT paidby FROM POS_Delivery_CusOrdList WHERE bID=" + cBranchID + " and OrderID=" + OrderId + " and CustomerID=" + CustID + ";")
    End Function

#End Region

#Region "Admin Panel"

    <WebMethod(EnableSession:=True)> _
    Function apAdminLogin(ByVal username As String, ByVal password As String) As String
        If SqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(*) FROM tbl_Employee WHERE eEmployeeCode='" + username + "' and ePassword='" + password + "' and eType='Admin';").Equals(1) Then
            HttpContext.Current.Session("admin") = username
            Return "1"
        Else
            Return "0"
        End If
    End Function

    <WebMethod()> _
    Function apGetBranches() As String
        Return ConvertData2Json(SqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT (SELECT COUNT(*) FROM dbo.tbl_Customers as c WHERE c.cBranchId = b.bID) as totalCustomer,* FROM tbl_Branch as b").Tables(0))
    End Function

    <WebMethod(EnableSession:=True)> _
    Function apSaveBranch(ByVal formData As String) As String
        Dim jss = New JavaScriptSerializer()
        Dim data = jss.DeserializeObject(formData)

        Dim dicItems As New Dictionary(Of String, Object)()
        dicItems = DirectCast(data, Dictionary(Of String, Object))

        Return SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_branch_insert",
                    New SqlClient.SqlParameter("@bCode", dicItems("bCode")),
                    New SqlClient.SqlParameter("@bName", dicItems("bName")),
                    New SqlClient.SqlParameter("@bAddress", dicItems("bAddress")),
                    New SqlClient.SqlParameter("@bIP", dicItems("bIP")),
                    New SqlClient.SqlParameter("@bDBConnectionString", dicItems("bDBConnectionString")),
                    New SqlClient.SqlParameter("@bOrderingWSurl", dicItems("bOrderingWSurl")),
                    New SqlClient.SqlParameter("@bInvoiceWSurl", dicItems("bInvoiceWSurl")),
                    New SqlClient.SqlParameter("@bCreatedBy", HttpContext.Current.Session("admin"))
                )
    End Function

    <WebMethod(EnableSession:=True)> _
    Function apUpdateBranch(ByVal formData As String) As String
        Dim jss = New JavaScriptSerializer()
        Dim data = jss.DeserializeObject(formData)

        Dim dicItems As New Dictionary(Of String, Object)()
        dicItems = DirectCast(data, Dictionary(Of String, Object))

        Return SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_branch_update",
                                         New SqlClient.SqlParameter("@bID", dicItems("bID")),
                                         New SqlClient.SqlParameter("@bCode", dicItems("bCode")),
                                         New SqlClient.SqlParameter("@bName", dicItems("bName")),
                                         New SqlClient.SqlParameter("@bAddress", dicItems("bAddress")),
                                         New SqlClient.SqlParameter("@bIP", dicItems("bIP")),
                                         New SqlClient.SqlParameter("@bDBConnectionString", dicItems("bDBConnectionString")),
                                         New SqlClient.SqlParameter("@bOrderingWSurl", dicItems("bOrderingWSurl")),
                                         New SqlClient.SqlParameter("@bInvoiceWSurl", dicItems("bInvoiceWSurl")),
                                         New SqlClient.SqlParameter("@bCreatedBy", HttpContext.Current.Session("admin"))
                )
    End Function

    <WebMethod(EnableSession:=True)> _
    Function apSyncBranch(ByVal bID As String) As String
        sqlConSB.ConnectionString = GetSelectedBranchDBStr(bID)
        For Each row As DataRow In SqlHelper.ExecuteDataset(sqlConSB, CommandType.Text, "SELECT *  FROM BOF_M_Customers").Tables(0).Rows

            SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_SaveCustomer",
                    New SqlClient.SqlParameter("@custBID", row("CustomerID")),
                    New SqlClient.SqlParameter("@cFirstname", row("CustomerName")),
                    New SqlClient.SqlParameter("@cFamilyname", row("FamilyName")),
                    New SqlClient.SqlParameter("@cCompany", row("Company")),
                    New SqlClient.SqlParameter("@cMobileNo", row("Mobile")),
                    New SqlClient.SqlParameter("@cHomeNo", row("Phone")),
                    New SqlClient.SqlParameter("@cOfficeNo", row("OfficePhone")),
                    New SqlClient.SqlParameter("@cCity", row("City")),
                    New SqlClient.SqlParameter("@cStreet", row("Street1")),
                    New SqlClient.SqlParameter("@cBuilding", row("Building1")),
                    New SqlClient.SqlParameter("@cFloor", row("Floor1")),
                    New SqlClient.SqlParameter("@cZone", row("MailAddressZone")),
                    New SqlClient.SqlParameter("@cAppartment", row("Appartment")),
                    New SqlClient.SqlParameter("@cNear", row("Near")),
                    New SqlClient.SqlParameter("@cPAOtherNo", row("OtherPhone")),
                    New SqlClient.SqlParameter("@cPAFax", row("Fax")),
                    New SqlClient.SqlParameter("@cPAEmail", row("Email")),
                    New SqlClient.SqlParameter("@cPAZipCode", row("ZipCode")),
                    New SqlClient.SqlParameter("@cSAOtherNo", ""),
                    New SqlClient.SqlParameter("@cSAFax", ""),
                    New SqlClient.SqlParameter("@cSAEmail", ""),
                    New SqlClient.SqlParameter("@cSAZipCode", ""),
                    New SqlClient.SqlParameter("@cLastSelectedBranch", bID))

        Next row
        Return 1
    End Function


    <WebMethod(EnableSession:=True)> _
    Function apDeleteBranch(ByVal bID As String) As String
        Return SqlHelper.ExecuteNonQuery(con, CommandType.Text, "DELETE FROM tbl_Branch WHERE bID=" + bID)
    End Function

    <WebMethod()> _
    Function apGetEmployees() As String
        Return ConvertData2Json(SqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT *  FROM tbl_Employee").Tables(0))
    End Function

    <WebMethod(EnableSession:=True)> _
    Function apSaveEmployee(ByVal formData As String) As String
        Dim jss = New JavaScriptSerializer()
        Dim data = jss.DeserializeObject(formData)

        Dim dicItems As New Dictionary(Of String, Object)()
        dicItems = DirectCast(data, Dictionary(Of String, Object))

        Return SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_employee_insert",
                    New SqlClient.SqlParameter("@eEmployeeCode", dicItems("eEmployeeCode")),
                    New SqlClient.SqlParameter("@ePassword", dicItems("ePassword")),
                    New SqlClient.SqlParameter("@eType", dicItems("eType")),
                    New SqlClient.SqlParameter("@eFullName", dicItems("eFullName")),
                    New SqlClient.SqlParameter("@eMobile", dicItems("eMobile")),
                    New SqlClient.SqlParameter("@eAddress", dicItems("eAddress")),
                    New SqlClient.SqlParameter("@eDOB", dicItems("eDOB")))

    End Function

    <WebMethod(EnableSession:=True)> _
    Function apUpdateEmployee(ByVal formData As String) As String
        Dim jss = New JavaScriptSerializer()
        Dim data = jss.DeserializeObject(formData)

        Dim dicItems As New Dictionary(Of String, Object)()
        dicItems = DirectCast(data, Dictionary(Of String, Object))

        Return SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_employee_update",
                                         New SqlClient.SqlParameter("@eID", dicItems("eID")),
                                        New SqlClient.SqlParameter("@eEmployeeCode", dicItems("eEmployeeCode")),
                                        New SqlClient.SqlParameter("@ePassword", dicItems("ePassword")),
                                        New SqlClient.SqlParameter("@eType", dicItems("eType")),
                                        New SqlClient.SqlParameter("@eFullName", dicItems("eFullName")),
                                        New SqlClient.SqlParameter("@eMobile", dicItems("eMobile")),
                                        New SqlClient.SqlParameter("@eAddress", dicItems("eAddress")),
                                         New SqlClient.SqlParameter("@eDOB", dicItems("eDOB")))

    End Function

    <WebMethod(EnableSession:=True)> _
    Function apDeleteEmployee(ByVal eID As String) As String
        Return SqlHelper.ExecuteNonQuery(con, CommandType.Text, "DELETE FROM tbl_Employee WHERE eID=" + eID)
    End Function

    <WebMethod()> _
    Function apGetOrders(ByVal whereCls As String) As String
        If whereCls.ToLower().LastIndexOf("delete").Equals(-1) Or whereCls.ToLower().LastIndexOf("insert").Equals(-1) Or whereCls.ToLower().LastIndexOf("update").Equals(-1) Then
            Return ConvertData2Json(SqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT * FROM POS_Delivery_CusOrdList " + whereCls).Tables(0))
        Else
            Return ""
        End If
    End Function

#End Region

#Region "Close Order"

    <WebMethod()> _
    Public Function GetPaymentTypes() As String
        Return ConvertData2Json(SqlHelper.ExecuteDataset(con, "POS_SEL_PaymentTypes").Tables(0))
    End Function

#End Region

End Class