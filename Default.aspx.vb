Imports System.Threading
Imports System.Globalization


Partial Class _Default
    Inherits System.Web.UI.Page
    Dim language As [String]
    Protected Overrides Sub InitializeCulture()

        If HttpContext.Current.Session("lang") Is Nothing Then
            HttpContext.Current.Session("lang") = "en-Us"
            language = HttpContext.Current.Session("lang")
        Else
            language = HttpContext.Current.Session("lang")
            'Only for the first page
            HttpContext.Current.Session.RemoveAll()
            HttpContext.Current.Session("lang") = language
        End If


        If Request.Form("ddlLang") <> Nothing Then
            HttpContext.Current.Session("lang") = Request.Form("ddlLang")
            language = HttpContext.Current.Session("lang")
        End If

        If language <> Nothing And language.Length > 0 Then
            Thread.CurrentThread.CurrentUICulture = New CultureInfo(language)
            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(language)
        End If



    End Sub

    

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        ddlLang.SelectedValue = language
    End Sub
End Class
