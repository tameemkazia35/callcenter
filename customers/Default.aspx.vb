Imports System.Threading
Imports System.Globalization

Partial Class customers_Default
    Inherits System.Web.UI.Page

    Protected Overrides Sub InitializeCulture()

        If HttpContext.Current.Session("EmployeeCode") Is Nothing Or HttpContext.Current.Session("lang") Is Nothing Then
            Response.Redirect("/callcenter/")
        End If

        Thread.CurrentThread.CurrentUICulture = New CultureInfo(HttpContext.Current.Session("lang").ToString())
        Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(HttpContext.Current.Session("lang").ToString())

    End Sub

End Class
