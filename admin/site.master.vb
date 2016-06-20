
Partial Class admin_site
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        If HttpContext.Current.Session("admin") Is Nothing Then
            Response.Redirect("/callcenter/admin")
        End If
    End Sub

End Class

