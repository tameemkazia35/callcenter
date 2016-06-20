Imports Microsoft.VisualBasic

Public Class Translator
    Public Shared Function getCode(key As String) As String
        Return Resources.g5.language.ResourceManager.GetString(key)
    End Function
End Class
