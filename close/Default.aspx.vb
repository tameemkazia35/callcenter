
Partial Class dashboard_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        'If HttpContext.Current.Session("EmployeeCode") Is Nothing Then
        '    Response.Redirect("/webpos/")
        'End If
    End Sub

   
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
       
    End Sub

End Class
