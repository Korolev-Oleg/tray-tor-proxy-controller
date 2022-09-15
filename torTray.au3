#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.0
 Author:         myName

 Script Function:
	controll tor proxy from try menu

#ce ----------------------------------------------------------------------------


#include <TrayConstants.au3>
@TrayIconVisible

Global $switch_item = 0
Global $tor_pid
Global $porxy_status = True


Func Setup()
	Global $switch_item
	Global $tor_pid
	Global $porxy_status
	Opt("TrayMenuMode", 3)
	Opt("TrayOnEventMode", 1)

	$switch_item = TrayCreateItem("Disable Proxy")
	TrayItemSetOnEvent($switch_item, 'ProxyStatusSwitch')

	$restart_item = TrayCreateItem('Refresh')
	TrayItemSetOnEvent($restart_item, 'RestartTor')
	
	TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1, "ExitScript")
	TraySetIcon('shell32.dll', 14)


	RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings', 'ProxyEnable', "REG_DWORD", 1)
	RunTor()
EndFunc

Func ProxyStatusSwitch()
	Global $proxy_status
	RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings', 'ProxyEnable', "REG_DWORD", int($proxy_status))
	If $proxy_status Then
		TrayItemSetText($switch_item, 'Disable Proxy')
		$proxy_status = False
	Else
		TrayItemSetText($switch_item, 'Enable Proxy')
		$proxy_status = True
	EndIf
	ConsoleWrite($proxy_status)
EndFunc



Func RunTor()
	Global $tor_pid
	ConsoleWrite($tor_pid)
	ConsoleWrite(@CRLF)
	$tor_pid = Run('tor.exe -f "C:\tools\tor\Tor\torrc"', '', @SW_HIDE)
	ConsoleWrite($tor_pid)
	ConsoleWrite(@CRLF)
EndFunc

Func RestartTor()
	ProcessClose($tor_pid)
	RunTor()
EndFunc

Func ExitScript()
	ProcessClose($tor_pid)
	Exit
EndFunc

Setup()

While True
	Sleep(1000)
WEnd
