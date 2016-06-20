Imports Microsoft.VisualBasic
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient


Public Class DataAccessLayer

    Dim _con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Dataconnection").ToString())

    Public Function GetData(ByVal SqlCmd As SqlCommand, Optional ByVal CmdType As CommandType = CommandType.StoredProcedure) As DataTable
        SqlCmd.Connection = _con
        SqlCmd.CommandType = CmdType
        Dim dApt As SqlDataAdapter = New SqlDataAdapter()
        dApt.SelectCommand = SqlCmd
        Dim dtTemp As DataTable = New DataTable()
        dtTemp.Clear()
        dApt.Fill(dtTemp)
        Return dtTemp
    End Function

End Class
