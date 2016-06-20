Imports System.IO
Imports System.IO.Ports
Imports System.Threading


Public Class Serials

#Region " Enums "
    Public Enum DispalyMode
        OverWrite = 1
        Vertical = 2
        Horizontal = 3
        StringModeUp = 4
        StringModeDown = 5
    End Enum
#End Region

#Region " Constructor "
    Public Sub New(ByVal PortID As Integer)
        Try

            'Port = New SerialPort(Func)
            'Port.Port.Cnfg.BaudRate = SerialPorts.LineSpeed.Baud_9600
            'Port.Cnfg.DataBits = SerialPorts.ByteSize.Eight
            'Port.Cnfg.Parity = SerialPorts.Parity.None
            'Port.Cnfg.StopBits = SerialPorts.StopBits.One
            'Port.Open(PortID)
        Catch ex As Exception

        End Try
    End Sub
#End Region

#Region " Destructor "
    Protected Overrides Sub Finalize()
        'Port.Close()
        'Port = Nothing
        MyBase.Finalize()
    End Sub
#End Region

#Region " Members "
    'Private Port As SerialPorts.SerialPort
    'Private Func As SerialPorts.WithEvents
    Private cDisplayMode As DispalyMode
#End Region

#Region " Properties "
    Public Property DisplayMode() As DispalyMode
        Get
            Return cDisplayMode
        End Get
        Set(ByVal Value As DispalyMode)
            Select Case Value
                Case DispalyMode.OverWrite
                    Dim b() As Byte = {27, 17}
                    'Port.Send(b)
                Case DispalyMode.Vertical
                    Dim b() As Byte = {27, 18}
                    'Port.Send(b)
                Case DispalyMode.Horizontal
                    Dim b() As Byte = {27, 19}
                    'Port.Send(b)
                Case DispalyMode.StringModeUp
                    Dim b As String = Chr(27) & Chr(81) & Chr(65)
                    'Port.Send(b)
                Case DispalyMode.StringModeDown
                    Dim b As String = Chr(27) & Chr(81) & Chr(66)
                    'Port.Send(b)
            End Select
            cDisplayMode = Value
        End Set
    End Property
#End Region

#Region " Methods "

    Public Sub CLS()
        Try
            Dim b As Byte = 12
            'Port.Send(b)
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me.Page, GetType(String), "showalert", "alert('" & ex.Message & "')", True)
        End Try
    End Sub

    Public Sub CLLine()
        Try
            Dim b As Byte = 24
            'Port.Send(b)
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me.Page, GetType(String), "showalert", "alert('" & ex.Message & "')", True)
        End Try
    End Sub

    Public Sub Send(ByVal s As String)
        Try
            If s.Length <> 0 Then
                Dim b() As Byte
                b = System.Text.Encoding.ASCII.GetBytes(s)
                'b = s
                'Port.Send(b)
            End If
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me.Page, GetType(String), "showalert", "alert('" & ex.Message & "')", True)
        End Try
    End Sub

    Public Sub WriteUpperLine(ByVal s As String)
        Try
            If DisplayMode <> DispalyMode.StringModeUp Then
                ' DisplayMode = DispalyMode.StringModeUp
            End If
            Send(s)
            MoveCursorLeftEnd()

        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me.Page, GetType(String), "showalert", "alert('" & ex.Message & "')", True)
        End Try
    End Sub

    Public Sub WriteLowerLine(ByVal s As String)
        Try
            If DisplayMode <> DispalyMode.StringModeDown Then
                'DisplayMode = DispalyMode.StringModeDown
            End If

            Send(s)
            MoveCursorDown()
            'MoveCursorLeftEnd()
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me.Page, GetType(String), "showalert", "alert('" & ex.Message & "')", True)
        End Try
    End Sub

    Public Sub MoveCursorDown()
        Try
            Dim b() As Byte = {10}
            'Port.Send(b)
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me.Page, GetType(String), "showalert", "alert('" & ex.Message & "')", True)
        End Try
    End Sub

    Public Sub MoveCursorLeftEnd()
        Try
            Dim b() As Byte = {13}
            'Port.Send(b)
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me.Page, GetType(String), "showalert", "alert('" & ex.Message & "')", True)
        End Try
    End Sub
    Public Sub dispose()



    End Sub


#End Region

    Private Function Page() As Page
        Throw New NotImplementedException
    End Function

End Class
