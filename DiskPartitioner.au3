#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icons\0.ico
#AutoIt3Wrapper_Outfile_x64=DiskPartitionerx64.Exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Comment=Front End for Microsoft Diskpart
#AutoIt3Wrapper_Res_Description=Disk Partitioner
#AutoIt3Wrapper_Res_Fileversion=0.7.0.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Ethan Queen
#AutoIt3Wrapper_Versioning=v
#AutoIt3Wrapper_Versioning_Parameters=/Comments v%fileversion%:
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Diskpartitioner - GUI for Microsoft Diskpart
;Version 0.4
;
;Original version can be found at:
;http://www.autoitscript.com/forum/topic/38921-microsoft-diskpart-automation/page__hl__diskpart

#Region - Compiler Directives

#EndRegion

Opt("MustDeclareVars", 1)	; Variables must be pre-declared
Opt("GUICloseOnEsc", 0)
Opt("TrayIconHide", 1)	; Hide the AutoIt tray icon
Opt("WinWaitDelay", 10)

; Flags declarations
;If Not IsDeclared("CB_SETCURSEL") Then Global Const $CB_SETCURSEL = 0x14E

; Global variable declarations
Global $msg	; application wide message variable
Global $DebugMode = True	; Set to TRUE to echo all communication with Diskpart.exe

Global $afrmDiskPart
Global $afrmSelectDisk
Global $afrmCreatePartition
Global $afrmDeletePartition
Global $afrmEditPartition
Global $afrmBorrarDisco   ;v:0.4.1.6
Global $afrmFormat       ;v:0.5.0.1
Global $afrmBootSector
Global $afrmNuevoDisco
Global $hTransferirProceso
; Global variables
Global $asDisks
Global $asPartitions

Global $sCurrentDisk
Local $FactorConversion = 1.0737
#include <Constants.au3>
#include <GUIConstants.au3>
#include <GUIListView.au3>
#include <Array.au3>

;ADDED
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <UpdownConstants.au3>
#include <SliderConstants.au3>
#include <ComboConstants.au3>
#include <GuiSlider.au3>
#include <GuiScrollBars.au3>
#include <Misc.au3>
#include <GuiEdit.au3>
;END ADDED

#include "ControlRange.au3"
#include "DiskPartErrors.au3"
#include "frmDiskPart.au3"
#include "frmSelectDisk.au3"
#include "frmCreatePartition.au3"
#include "frmDeletePartition.au3"
#include "frmEditPartition.au3"
#include "frmBorrarDisco.au3"   ; v: 0.4.1.4
#include "frmFormatPartition.au3"  ;v:0.5.0.1
#include "frmBootSector.au3"
#include "frmNewDisco.au3"

CreateForm_frmDiskPart($afrmDiskPart)
frmDiskPart_Initialize()

CreateForm_frmSelectDisk($afrmSelectDisk, $afrmDiskPart[0][1])

frmSelectDisk_Initialize()

CreateForm_frmCreatePartition($afrmCreatePartition, $afrmDiskPart[0][1])
CreateForm_frmDeletePartition($afrmDeletePartition, $afrmDiskPart[0][1])
CreateForm_frmEditPartition($afrmEditPartition, $afrmDiskPart[0][1])
CreateForm_frmBorrarDisco($afrmBorrarDisco, $afrmDiskPart[0][1])

CreateForm_frmFormat($afrmFormat, $afrmDiskPart[0][1])  ;v:0.5.0.1
CreateForm_BootSector($afrmBootSector, $afrmDiskPart[0][1])
CreateForm_frmNuevoDisco($afrmNuevoDisco, $afrmDiskPart[0][1])
GUISetState(@SW_SHOW, $afrmDiskPart[0][1])
frmSelectDisk_cmdRefresh_Click()
frmSelectDisk_cmdOK_Click(True)

While 1
	$msg = GuiGetMsg(1)

	; Prevent unnessary calls to _GetCtrl() by excluding $GUI_EVENT_MOUSEMOVE
	If $msg[0] <> $GUI_EVENT_MOUSEMOVE Then
		Select

		Case $msg[1] = $afrmDiskPart[0][1]
			frmDiskPart_WndProc()
		Case $msg[1] = $afrmSelectDisk[0][1]
			frmSelectDisk_WndProc()
		Case $msg[1] = $afrmCreatePartition[0][1]
			frmCreatePartition_WndProc()
		Case $msg[1] = $afrmDeletePartition[0][1]
			frmDeletePartition_WndProc()
		Case $msg[1] = $afrmEditPartition[0][1]
			frmEditPartition_WndProc()
		Case $msg[1] = $afrmBorrarDisco[0][1]  ;v: 0.4.1.5
			frmBorrarDisco_WndProc()     ;v: 0.4.1.5
		Case $msg[1] = $afrmFormat[0][1]  ;v:0.5.0.1
			frmFormat_WndProc()          ;v:0.5.0.1
		Case $msg[1] = $afrmBootSector[0][1]
			frmBootSector_WndProc()
		Case $msg[1] = $afrmNuevoDisco[0][1]
			frmNuevoDisco_WndProc()

		EndSelect
	EndIf
Wend

Func Cambiar_a_Ingles($string)
	$string = StringReplace($string, "Disco", "Disk" )

	$string = StringReplace($string, "Partici¢n", "Partition")
	$string = StringReplace($string, "Extendido", "Extended")
	$string = StringReplace($string, "L¢gico", "Logical")
	$string = StringReplace($string, "Oculta", "Hidden")
	$string = StringReplace($string, "Activa", "Active")
	$string = StringReplace($string, "S¡", "Si")

	Return $string
EndFunc

Func Cambiar_a_Esp($string)
	$string = StringReplace($string, "Disk", "Disco")
	$string = StringReplace($string, "Partition", "Partición")
	$string = StringReplace($string, "Extended", "Extendido")
	$string = StringReplace($string, "Logical", "Lógico")
	$string = StringReplace($string, "Hidden", "Oculta")
	$string = StringReplace($string, "Active", "Activa")
	$string = StringReplace($string, "Primary", "Primaria")
	Return $string
EndFunc

Func DiskPartitioner_WndProc()
	Select

	Case $msg[0] = $GUI_EVENT_CLOSE
		GUIDelete($afrmEditPartition[0][1])
		GUIDelete($afrmDeletePartition[0][1])
		GUIDelete($afrmCreatePartition[0][1])
		GUIDelete($afrmSelectDisk[0][1])
		GUIDelete($afrmDiskPart[0][1])
		GUIDelete($afrmBorrarDisco[0][1])  ;v: 0.4.1.5
		GUIDelete($afrmFormat[0][1])       ;v:0.5.0.1
		GUIDelete($afrmBootSector[0][1])
		GUIDelete($afrmNuevoDisco[0][1])
		Exit

	EndSelect
EndFunc

Func _GetCtrl($sCtrlName, $afrmArray)
	For $i = 0 to UBound($afrmArray, 1) - 1
		If $afrmArray[$i][0] = $sCtrlName Then
			Return $afrmArray[$i][1]
		EndIf
	Next

	; Error Handler
	If $i > UBound($afrmArray, 1) - 1 Then
		DiskPartitioner_ErrorHandler("Control reference invalid ", _
								"Control Name: " & $sCtrlName  & @CRLF & _
								"Form Name: " & $afrmArray[0][0], "Fatal")
		SetError(1)
	EndIf
EndFunc

; Application wide central message handler.
; Displays an error msg and exits the application if the error is fatal.
Func DiskPartitioner_ErrorHandler($sError, $sSolution, $sImpact)
	If $sImpact = "Non-Fatal" Then
		MsgBox(8256, "DiskPart GUI", $sError & @CRLF & @CRLF & $sSolution)
	ElseIf $sImpact = "Fatal" Then
		MsgBox(8240, "DiskPart GUI", $sError & @CRLF & @CRLF & $sSolution)
		$msg[0] = $GUI_EVENT_CLOSE
		DiskPartitioner_WndProc()
	EndIf
EndFunc

Func _ConvertToMB($sSize)
	If StringInStr($sSize, "MB") Then
		Return(Number($sSize))
	ElseIf StringInStr($sSize, "GB") Then
		Return(Number($sSize) * 1024)
	ElseIf StringInStr($sSize, "TB") Then
		Return(Number($sSize) * 1024 * 1024)
	Else
		Return 0
	EndIf
EndFunc

Func ConvertToGB($sSize)
	If StringInStr($sSize, "MB") Then
		Return(Round(Number($sSize)/1024))
	ElseIf StringInStr($sSize,"GB") Then
		Return (Number($sSize))
	ElseIf StringInStr($sSize, "TB") Then
		Return (Number($sSize)*1024)
	Else
		Return 0
	EndIf
EndFunc

Func _ConvertirGBbinToGBdecimal($size)
	If StringInStr($size, "GB") Then
		Return  String(Round(Number($size) * 1.075)) & " GB"   ;1024  * 1024 * 1024
;		Return  String(Round(Number($size) * $FactorConversion)) & " GB"   ;1024  * 1024 * 1024
	Else
		Return $size
	EndIf
EndFunc

Func _CreateDiskPartProcess()

	Local $sOutput, $hPrDiskPart
	Local $iChoice
	;MsgBox(0, "Diskpart", "2")
	If FileExists(@ScriptDir & "\DiskPart.exe") Or _
		FileExists(@SystemDir & "\DiskPart.exe") Then

		$hPrDiskPart = Run("DiskPart.exe", "", @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)

		While StringRight(StdoutRead($hPrDiskPart, True, False), 10) <> "DISKPART> "
			Sleep(100)

			If Not(ProcessExists($hPrDiskPart)) Then
				$iChoice = MsgBox(5 + 64, "DiskPart GUI", "DiskPart GUI could not connect to the Disk Management services." & @CRLF & _
										"Make sure this program is run with administrative privileges." & @CRLF & @CRLF & _
										"Click Retry to try connecting again or choose Cancel to abort.")
				If $iChoice = 4 Then
					$hPrDiskPart = Run("DiskPart.exe", "", @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)
				Else
					$hPrDiskPart = 0
					ExitLoop
				EndIf
			EndIf
		Wend

		If $hPrDiskPart <> 0 Then
			; Remove the characters from the process stream
			$sOutput = StdoutRead($hPrDiskPart)
			If $DebugMode = True Then ConsoleWrite($sOutput)


		EndIf

		Return $hPrDiskPart
	Else
		MsgBox(8240, "DiskPart GUI", "One or more required files are missing." & @CRLF & @CRLF & _
					"Command-line DiskPart.exe is required to use this software." & @CRLF & _
					"Download the latest version of DiskPart.exe from Microsoft Download Center.")
		Exit
	EndIf
EndFunc

Func _WaitForCommand($hPrDiskPart)
	While StringRight(StdoutRead($hPrDiskPart, True, False), 10) <> "DISKPART> "
		Sleep(100)
	Wend
EndFunc

;---------------------------------------
;- Pause until arrow keys are released -
;  25 - Left                           -
;  26 - Up                             -
;  27 - Right                          -
;  28 - Down                           -
;---------------------------------------
Func _Wait_For_Arrow_Keys()
	Local $hDLL = DllOpen("user32.dll")

	While(_IsPressed(25, $hDLL) OR _IsPressed(26, $hDLL) OR _IsPressed(27, $hDLL) OR _IsPressed(28, $hDLL))
		Sleep(10)
	WEnd

    DLLClose($hDLL)
EndFunc

;---------------------------------------
;- Detect if arrow keys are held down -
;  25 - Left                           -
;  26 - Up                             -
;  27 - Right                          -
;  28 - Down                           -
;---------------------------------------
Func _Detect_Arrow_Keys()
	Local $hDLL = DllOpen("user32.dll")
	local $is_pressed = 0

	If(_IsPressed(25, $hDLL)) Then
	   $is_pressed = 1
	EndIf

	If(_IsPressed(26, $hDLL)) Then
	   $is_pressed = 1
	EndIf

	If(_IsPressed(27, $hDLL)) Then
		$is_pressed = 1
	EndIf

	If(_IsPressed(28, $hDLL)) Then
		$is_pressed = 1
	EndIf

    DLLClose($hDLL)

	Return $is_pressed
EndFunc

Func _GetOutput($sProcess)
	Local $sOutput
	$sOutput = Cambiar_a_Ingles(StdoutRead($sProcess))
;	$sOutput =StdoutRead($sProcess)       ; habilitar esto en un futuro, para no afectar nombres de particion escritos en ingles

	If $DebugMode = True Then ConsoleWrite($sOutput)
	Return $sOutput
EndFunc

Func _LoadDriveLetters($afrm)
	Local $sDriveLetters, $asDriveLetters, $asDrives
	Local $cboDriveLetter

	$cboDriveLetter = _GetCtrl("$cboDriveLetter", $afrm)
	GUICtrlSetData($cboDriveLetter, "")	; Delete all items

	$sDriveLetters = "C:|D:|E:|F:|G:|H:|I:|J:|K:|L:|M:|N:|O:|P:|Q:|R:|S:|T:|U:|V:|W:|X:|Y:|Z:"
	$asDriveLetters = StringSplit($sDriveLetters, '|', 1)
	$asDrives = DriveGetDrive("ALL")
	_ArraySort($asDrives, 0, 1)

	Local $drives
	For $i = 0 to UBound($asDrives, 1) - 1
		$drives = $drives & $asDrives[$i] & " "
	Next

	For $i = 1 to UBound($asDriveLetters, 1) - 1
		If _ArrayBinarySearch($asDrives, $asDriveLetters[$i], 1) = -1 Then
			If @error = 2 OR @error = 3 Then
				GUICtrlSetData($cboDriveLetter, $asDriveLetters[$i])
			Else
				MsgBox(0, "Load Drive Letters combo box - Error", "@error is: " & @error) ; todo: add error messages for specific errors instead of just printing out the error number
			EndIf
		EndIf
	Next

	GUICtrlSendMsg($cboDriveLetter, $CB_SETCURSEL, 0, 0)
EndFunc

Func _RefreshDiskPartInfo($sDiskNo = "", $stbStatus = 0, $hPrDiskPart = 0)
	Local $sOutput, $bPrDiskpartExists = True

	GUICtrlSetData($stbStatus, "Actualizando informacion de Disco(s) Duro(s), espere...")   ;v: 0.4.1.5

	If $hPrDiskPart = 0 Then
		$bPrDiskpartExists = False
		$hPrDiskPart = _CreateDiskPartProcess()
	EndIf

	_GetDiskInfoBasic($hPrDiskPart)
	_GetDiskInfoExtended($hPrDiskPart)

	If $sDiskNo <> "" Then
		; Update global variable


		$sCurrentDisk = $sDiskNo

		GUICtrlSetData($stbStatus, Cambiar_a_Esp("Actualizando datos de Particion para " & $sDiskNo & ", Espere..."))    ;v: 0.4.1.5
;~ 		$sDiskNo = StringReplace($sDiskNo,"Disco", "disk") ;version: 0.4.0.3
		_GetPartInfoBasic($hPrDiskPart, $sDiskNo)
		_GetPartInfoExtended($hPrDiskPart, $sDiskNo)
	EndIf

	If $bPrDiskpartExists = False Then
		StdinWrite($hPrDiskPart)	; Close the DiskPart process
	EndIf

	GUICtrlSetData($stbStatus, "")
EndFunc

Func _GetDiskInfoBasic($hPrDiskPart)

	Local $sDiskList, $iPosDataStart, $iPosDataEnd
	Local $asDiskList, $asOffset[6]
	Local $sFormatted, $asDiskBasicInfo, $l, $k

	Dim $asDisks = 0	; Clear Disks array

	If $hPrDiskPart = 0 Then
		Return
	EndIf

	; List disk
	StdinWrite($hPrDiskPart, "List Disk" & @CRLF)
	If $DebugMode = True Then ConsoleWrite("List Disk" & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sDiskList = _GetOutput($hPrDiskPart)

	_CheckForDiskPartErrors($sDiskList)

	$iPosDataStart = StringInStr($sDiskList, "----")

	If @OSVersion <> "WIN_XP" Then
		$iPosDataEnd = StringInStr($sDiskList, @CRLF & @CRLF & "DISKPART> ")

	Else
		$iPosDataEnd = StringInStr($sDiskList, @LF & @LF & "DISKPART> ")
	Endif

	If $iPosDataStart <> 0 And $iPosDataEnd <> 0 Then
		; Extract relevant data from $sDiskList
		$sDiskList = StringMid($sDiskList, $iPosDataStart, $iPosDataEnd - $iPosDataStart)

		;MsgBox(0, "$sDiskList", $sDiskList)
		;MsgBox(0, "@OSType", @OSType)
		;MsgBox(0, "@OSVersion", @OSVersion)
	;;;	$asDiskList = StringSplit($sDiskList, @LF)
		$asDiskList = StringSplit($sDiskList, @LF, 2)
		_ArrayDelete($asDiskList, 0)  ; Borramos primer elemento que contiene "------ -------- ------"  v: 0.4.0.7
 		For $i = 0 to UBound($asDiskList) - 1
			If StringLeft($asDiskList[$i], 1) = "*" Then
				$asDiskList[$i] = StringMid($asDiskList[$i], 2) ; Remove '*' in the beginning
			EndIf
 			$asDiskList[$i] = StringStripWS($asDiskList[$i], 1)
 		Next

	;	For $i=1 to
		; Count the offset values
;~ 		$asOffset[0] = 1
;~ 		For $i = 1 to UBound($asOffset) - 1
;~ 			$asOffset[$i] = StringInStr($asDiskList[1], " -", 0, $i) + 1
;~ 			;;MsgBox(0, "offset", (StringMid($asDiskList[1], ($asOffset[$i]-1))))
;~ 		Next

;~ 		For $i = 2 to UBound($asDiskList) - 1
;~ 			$sFormatted = ""
;~ 			For $j = 1 to UBound($asOffset) - 1
;~ 				;$sFormatted = $sFormatted & StringMid($asDiskList[$i], $asOffset[$j - 1], $asOffset[$j] - $asOffset[$j - 1]) & "|"
;~ 				$sFormatted = $sFormatted & StringMid($asDiskList[$i], $asOffset[$j - 1], $asOffset[$j] - $asOffset[$j - 1]) & "|"
;~ 			;;	MsgBox(0, $i, $sFormatted)
;~ 			Next
;~ 			$sFormatted = $sFormatted & StringMid($asDiskList[$i], $asOffset[$j - 1])
;~ 			$asDiskList[$i] = $sFormatted
;~ 			;;MsgBox(0, "33", $asDiskList[$i])
;~ 		Next

;~ 		_ArrayDelete($asDiskList, 0)
;~ 		_ArrayDelete($asDiskList, 0)	; Repeat - $asDiskList[1] is now $asDiskList[0]
;~ 		;_ArrayDisplay($asDiskList, "")
		;;;Dim $asDisks[UBound($asDiskList)][21]
		Dim $asDisks[UBound($asDiskList)][21]
		For $i = 0 to UBound($asDiskList) - 1
			$asDiskList[$i] = StringReplace($asDiskList[$i],"B       ","B    n  ")
;~ 			MsgBox(0,"33", StringReplace($asDiskList[$i]," ","_"))
			$asDiskList[$i] = StringReplace($asDiskList[$i],"n   *","n   g")
			$asDiskList[$i] = StringReplace($asDiskList[$i],"B   *","A   d")
;~ 			$asDiskList[$i] = StringReplace($asDiskList[$i],"d   *","d   g")
;~ 			$asDiskList[$i] = StringReplace($asDiskList[$i],"d    ","d1234")
			$asDiskBasicInfo = StringSplit($asDiskList[$i], "  ", 3)
;~ 			_ArrayDisplay( $asDiskBasicInfo, "asDisksxxx")
			$l = 0
;~ *******************
;~ 			$k = 0																					Otra forma de
;~ 			Do                                                                                      de extraer la data
;~ 			If $asDiskBasicInfo[$k] = "" Then                                                       descartando los campos
;~ 				$k += 1                                                                             vacios
;~ 			Else
;~ 				$asDisks[$i][$l] = $asDiskBasicInfo[$k]
;~ 				$l += 1
;~ 				$k += 1
;~ 			EndIf
;~ 			Until $k > UBound($asDiskBasicInfo) - 1
;~ *****************
			For $k = 0 to Ubound($asDiskBasicInfo) - 1            ;extraer los campos utiles
				$asDisks[$i][$l] = StringStripWS($asDiskBasicInfo[$k], 3)			   ; descartando los espacios vacios
				If $asDisks [$i][$l] <> "" Then
;~ 					MsgBox(0, "espacios", "ddd-" & $asDisks[$i][$l] & "-ddd")
					$l += 1
				EndIf
			Next
		Next

;~ 		_ArrayDisplay( $asDisks, "asDisks")
;~ 		For $i = 0 to UBound($asDiskList) - 1
;~ 			$asDiskBasicInfo = StringSplit($asDiskList[$i], "|")
;~ 			For $j = 1 to UBound($asDiskBasicInfo) - 1
;~ 				$asDisks[$i][$j - 1] = StringStripWS($asDiskBasicInfo[$j], 3)
;~ 				;ConsoleWrite("$asDisks[" & $i & "][" & $j - 1 & "] = " & $asDisks[$i][$j - 1])
;~ 			Next
;~ 		Next
	EndIf

EndFunc

Func _GetDiskInfoExtended($hPrDiskPart)
	Local $sDiskList, $sDiskDetails, $iPosDataStart, $iPosDataEnd, $reempDisk
	;Local $asDiskInfoExtended

	If $asDisks = 0 Then
		Return
	EndIf

	For $i = 0 to UBound($asDisks, 1) - 1

		Dim $asDiskInfoExtended = 0 ; clear
		Dim $asDiskInfoExtended[18]

		; Select disk
;~ 		$reempDisk = StringReplace($asDisks[$i][0],"Disco", "disk") ;version: 0.4.0.3,   0.4.1.0
		StdinWrite($hPrDiskPart, "Select " & $asDisks[$i][0] & @CRLF);version: 0.4.0.3  0.4.1.0
;~ 		StdinWrite($hPrDiskPart, "Select " & $reempDisk & @CRLF);version: 0.4.0.3  0.4.1.0
		If $DebugMode = True Then ConsoleWrite("Select " & $asDisks[$i][0] & @CRLF)

		_WaitForCommand($hPrDiskPart)

		$sDiskList = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sDiskList)

		; Detail disk
		StdinWrite($hPrDiskPart, "Detail Disk" & @CRLF)
		If $DebugMode = True Then ConsoleWrite("Detail Disk" & @CRLF)

		_WaitForCommand($hPrDiskPart)

		$sDiskList = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sDiskList)

		$iPosDataStart = 2
		$iPosDataEnd = StringInStr($sDiskList, "Volume #") - 4
		If $iPosDataStart <> 0 And $iPosDataEnd <> 0 Then
			$sDiskList = StringMid($sDiskList, $iPosDataStart, $iPosDataEnd - $iPosDataStart)
;~ 			MsgBox(0, "Extended", $sDiskList)
			$asDiskInfoExtended = StringSplit($sDiskList, @LF)
;~ 			_ArrayDisplay($asDiskInfoExtended, "extended")

		  ; notes for already existing fields from basic disk info
		  ;-----------------------------------------------------------
		  ; $asDisks[$i][0]                                          ; Disk Number
          ; $asDisks[$i][1]                                          ; Status
		  ; $asDisks[$i][2]                                          ; Size
		  ; $asDisks[$i][3]                                          ; Free
		  ; $asDisks[$i][4]                                          ; ?? - blank
		  ; $asDisks[$i][5]                                          ; ?? - blank
		  ;-----------------------------------------------------------
			If @OSVersion <> "WIN_XP" Then ; need to test other versions before Windows 7
				$asDisks[$i][2] = _ConvertirGBbinToGBdecimal($asDisks[$i][2])	; Convertir los GB binarios A  DECIMALES
				$asDisks[$i][3] = _ConvertirGBbinToGBdecimal($asDisks[$i][3])	; Convertir los GB binarios A  DECIMALES
				$asDisks[$i][6] = $asDiskInfoExtended[2]	             ; Model #
				$asDisks[$i][7] = StringMid($asDiskInfoExtended[3], 14)	 ; ID
				$asDisks[$i][8] = StringMid($asDiskInfoExtended[4], 14)	 ; Type
				$asDisks[$i][9] = StringMid($asDiskInfoExtended[5], 10)	 ; Status - same as above
				$asDisks[$i][10] = StringMid($asDiskInfoExtended[6], 14) ; Path
				$asDisks[$i][11] = StringMid($asDiskInfoExtended[7], 14) ; Target
				$asDisks[$i][12] = StringMid($asDiskInfoExtended[8], 14) ; LUN ID
				$asDisks[$i][13] = StringMid($asDiskInfoExtended[9], 22) ; Location Path
				$asDisks[$i][14] = StringMid($asDiskInfoExtended[10], 32); Current Read-only State
				$asDisks[$i][15] = StringMid($asDiskInfoExtended[11], 21); Read-only  13
				$asDisks[$i][16] = StringMid($asDiskInfoExtended[12], 21); Boot Disk  13
				$asDisks[$i][17] = StringMid($asDiskInfoExtended[13], 34); Pagefile Disk  17
				$asDisks[$i][18] = StringMid($asDiskInfoExtended[14], 35); Hibernation File Disk  25
				$asDisks[$i][19] = StringMid($asDiskInfoExtended[15], 20); Crashdump Disk   18
				$asDisks[$i][20] = StringMid($asDiskInfoExtended[16], 18); Clustered Disk   18
			Else
				$asDisks[$i][6] = $asDiskInfoExtended[1]	             ; Model #
				$asDisks[$i][7] = StringMid($asDiskInfoExtended[2], 10)	 ; ID
				$asDisks[$i][8] = StringMid($asDiskInfoExtended[3], 10)	 ; Type
				$asDisks[$i][9] = StringMid($asDiskInfoExtended[4], 10)	 ; Bus
				$asDisks[$i][11] = StringMid($asDiskInfoExtended[5], 10) ; Target
				$asDisks[$i][12] = StringMid($asDiskInfoExtended[6], 10) ; LUN ID
			Endif
;~ 			_ArrayDisplay($asDisks, "final")
		EndIf
	Next
EndFunc

Func _GetPartInfoBasic($hPrDiskPart, $sDiskNo)
	Local $sPartList, $iPosDataStart, $iPosDataEnd
	Local $asPartList, $asOffset[4]
	Local $sFormatted, $asPartBasicInfo, $l

	Dim $asPartitions = 0 ; Clear Partitions array

	If $hPrDiskPart = 0 Then
		Return
	EndIf
;~ 	MsgBox(0, "disk", $sDiskNo)
	; Select disk
	StdinWrite($hPrDiskPart, "Select " & $sDiskNo & @CRLF)
	If $DebugMode = True Then ConsoleWrite("Select " & $sDiskNo & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sPartList = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sPartList)

	; List partition
	StdinWrite($hPrDiskPart, "List Partition" & @CRLF)
	If $DebugMode = True Then ConsoleWrite("List Partition" & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sPartList = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sPartList)

	$iPosDataStart = StringInStr($sPartList, "----")
	If @OSVersion <> "WIN_XP" Then
		$iPosDataEnd = StringInStr($sPartList, @CRLF & @CRLF & "DISKPART> ")
	Else
		$iPosDataEnd = StringInStr($sPartList, @LF & @LF & "DISKPART> ")
	Endif

	If $iPosDataStart <> 0 And $iPosDataEnd <> 0 Then
		; Extract relevant data from $sPartList
		$sPartList = StringMid($sPartList, $iPosDataStart, $iPosDataEnd - $iPosDataStart)
;~ 		MsgBox(0,"part",$sPartList)
		$asPartList = StringSplit($sPartList, @LF, 2)
		_ArrayDelete($asPartList,0)  ; Borramos primer elemento que contiene "------ -------- ------"  v: 0.4.0.7

 		For $i = 0 to UBound($asPartList) - 1
			If StringLeft($asPartList[$i], 1) = "*" Then
				$asPartList[$i] = StringMid($asPartList[$i], 2) ; Remove '*' in the beginning
			EndIf
 			$asPartList[$i] = StringStripWS($asPartList[$i], 3)
;~ 			MsgBox(0,"Part_list " & $i , $asPartList[$i])
 		Next

		; Count the offset values
;~ 		$asOffset[0] = 1
;~ 		For $i = 1 to UBound($asOffset) - 1
;~ 			$asOffset[$i] = StringInStr($asPartList[1], " -", 0, $i) + 1
;~ 		Next

;~ 		For $i = 2 to UBound($asPartList) - 1
;~ 			$sFormatted = ""
;~ 			For $j = 1 to UBound($asOffset) - 1
;~ 				$sFormatted = $sFormatted & StringMid($asPartList[$i], $asOffset[$j - 1], $asOffset[$j] - $asOffset[$j - 1]) & "|"
;~ 			Next
;~ 			$sFormatted = $sFormatted & StringMid($asPartList[$i], $asOffset[$j - 1])
;~ 			$asPartList[$i] = $sFormatted
;~ 		Next

;~ 		_ArrayDelete($asPartList, 0)
;~ 		_ArrayDelete($asPartList, 0)	; Repeat - $asPartList[1] is now $asPartList[0]
		;_ArrayDisplay($asPartList, "")

		Dim $asPartitions[UBound($asPartList)][14]

		For $i = 0 to UBound($asPartList) - 1
			$asPartBasicInfo = StringSplit($asPartList[$i], "  ", 3)
;~ 			_ArrayDisplay($asPartBasicInfo, "basicinfo")
			$l=0

			For $j = 0 to UBound($asPartBasicInfo) - 1
;~ 				$asPartitions[$i][$j - 1] = StringStripWS($asPartBasicInfo[$j], 3)
				$asPartitions[$i][$l] = StringStripWS($asPartBasicInfo[$j], 3)  ; v: 0.4.0.7
				If $asPartitions[$i][$l] <> "" Then
					$l +=1
;~ 					MsgBox(0, "espacios", "ddd-" & $asPartitions[$i][$l] & "-ddd")
				EndIf

				;ConsoleWrite("$asPartitions[" & $i & "][" & $j - 1 & "] = " & $asPartitions[$i][$j - 1])
			Next
		Next
;~ 		_ArrayDisplay($asPartitions, "Partitions")
	EndIf
EndFunc

Func _GetPartInfoExtended($hPrDiskPart, $sDiskNo)
	Local $sPartList, $sPartDetails, $sPartInfo, $iPosDataStart, $iPosDataEnd
	Local $asPartList, $asOffset[8]
	Local $sFormatted, $asPartExtendedInfo
	Local $reempDisk, $reemPartition

	If $asPartitions = 0 Then
		Return
	EndIf

	; Select disk

	StdinWrite($hPrDiskPart, "Select " & $sDiskNo & @CRLF)
	If $DebugMode = True Then ConsoleWrite("Select " & $sDiskNo & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sPartList = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sPartList)

	For $i = 0 to UBound($asPartitions, 1) - 1

		; Select partition
;~ 		$reemPartition= StringReplace($asPartitions[$i][0], "Partici¢n", "partition")  0.4.1.0

		StdinWrite($hPrDiskPart, "Select " & $asPartitions[$i][0] & @CRLF)   ; 0.4.1.0
;~ 		StdinWrite($hPrDiskPart, "Select " & $reemPartition & @CRLF)  0.4.1.0
		If $DebugMode = True Then ConsoleWrite("Select " & $asPartitions[$i][0] & @CRLF)

		_WaitForCommand($hPrDiskPart)

		$sPartDetails = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sPartDetails)

		; Detail partition
		StdinWrite($hPrDiskPart, "Detail Partition" & @CRLF)
		If $DebugMode = True Then ConsoleWrite("Detail Partition" & @CRLF)

		_WaitForCommand($hPrDiskPart)

		$sPartDetails = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sPartDetails)

		$iPosDataStart = 1
		$iPosDataEnd = StringInStr($sPartDetails, "DISKPART> ")

		If $iPosDataStart <> 0 And $iPosDataEnd <> 0 Then
			$sPartList = StringMid($sPartDetails, $iPosDataStart, $iPosDataEnd - $iPosDataStart)
;~ 			MsgBox(0,"parti", $sPartList)
			$iPosDataStart = StringInStr($sPartList, "Hidden") + 16   ;version: 0.4.1.0
;~ 			MsgBox(0, "hid", StringMid($sPartList,$iPosDataStart))
			$asPartitions[$i][12] = StringStripWS(StringMid($sPartList, $iPosDataStart, 4), 3)
;~ 			MsgBox(0, "hid", $asPartitions[$i][12])
			$iPosDataStart = StringInStr($sPartList, "Active") + 16  ;version: 0.4.1.0
;~ 			MsgBox(0, "act", StringMid($sPartList,$iPosDataStart))
			$asPartitions[$i][13] = StringStripWS(StringMid($sPartList, $iPosDataStart, 4), 3)
;~ 			MsgBox(0, "act", $asPartitions[$i][13])

			$iPosDataStart = StringInStr($sPartList, "----")
			If $iPosDataStart <> 0 Then
				; Extract relevant data from $sPartList
				$sPartList = StringMid($sPartList, $iPosDataStart)
				$asPartList = StringSplit($sPartList, @LF)
				For $j = 1 to UBound($asPartList) - 1
					If StringLeft($asPartList[$j], 1) = "*" Then
						$asPartList[$j] = StringMid($asPartList[$j], 2)	; Remove '*' in the beginning
					EndIf
					$asPartList[$j] = StringStripWS($asPartList[$j], 3)
				Next

				;_ArrayDisplay($asPartList, "")

				; Count the offset values
				$asOffset[0] = 1
				For $j = 1 to UBound($asOffset) - 1
					$asOffset[$j] = StringInStr($asPartList[1], " -", 0, $j) + 1
				Next

				;_ArrayDisplay($asOffset, "")

				For $j = 2 to UBound($asPartList) - 1
					$sFormatted = ""
					For $k = 1 to UBound($asOffset) - 1
						$sFormatted = $sFormatted & StringMid($asPartList[$j], $asOffset[$k - 1], $asOffset[$k] - $asOffset[$k - 1]) & "|"
					Next
					$sFormatted = $sFormatted & StringMid($asPartList[$j], $asOffset[$k - 1])
					$asPartList[$j] = $sFormatted
				Next

;~ 				_ArrayDisplay($asPartList, "")

				$asPartExtendedInfo = StringSplit($asPartList[2], "|")
;~ 				_ArrayDisplay($asPartExtendedInfo, "")

				For $j = 1 to UBound($asPartExtendedInfo) - 1
					$asPartitions[$i][$j + 3] = StringStripWS($asPartExtendedInfo[$j], 3)
;~
					;ConsoleWrite("$asPartitions[" & $i & "][" & $j + 3 & "] = " & $asPartitions[$i][$j + 3])
				Next
			EndIf
		EndIf
;~ 		$asPartitions[$i][0] = # particion  (Particion 1)
;~ 		$asPartitions[$i][1] =  Tipo PArticion (Principal,extendido, logica)
;~ 		$asPartitions[$i][2] =  Tamaño (350 MB)
;~ 		$asPartitions[$i][3] =  offset (1048576 (bytes))
;~ 		$asPartitions[$i][4] =  # Volume (volume 1)
;~ 		$asPartitions[$i][5] =   Letra (c)
;~ 		$asPartitions[$i][6] =   Etiqueta (Resevado, nombre de disco)
;~ 		$asPartitions[$i][7] =   Sistema de archivos  (NTFS)
;~ 		$asPartitions[$i][8] =   Particion (es?)(Particion)
;~ 		$asPartitions[$i][9] =   Tamaño  (19 Gb)
;~ 		$asPartitions[$i][10] =  Estado (correcto)
;~ 		$asPartitions[$i][11] = info (sistema, arranque)
;~ 		$asPartitions[$i][12] =  oculto (si, no)
;~ 		$asPartitions[$i][13] =  activo (si,no)

;~ _ArrayDisplay($asPartitions,"last")
		;ConsoleWrite("$asPartitions[" & $i & "][12] = " & $asPartitions[$i][12])
		;ConsoleWrite("$asPartitions[" & $i & "][13] = " & $asPartitions[$i][13])
	Next

EndFunc

Func _CreatePartition($sDiskNo, $sPartType, $iPartSize, $sLetter = "", $stbStatus = 0, $bContinueToFormat = False )
	Local $sOutput
	Local $hPrDiskPart

	If $iPartSize = -1 Then		; -1 significa q es la ultima particion, y la crearemos con lo q resta de espacio
		GUICtrlSetData($stbStatus, Cambiar_a_Esp("Creando Partición " & $sPartType & " con el espacio  libre restante en " & $sDiskNo & ", Espere..."))
	Else

		GUICtrlSetData($stbStatus, Cambiar_a_Esp("Creando Partición " & $sPartType & " de " & $iPartSize & "GB en " & $sDiskNo & ", Espere..."))
		$iPartSize = Round($iPartSize * (1024/$FactorConversion))	;953.26754)
	EndIf

	If $hTransferirProceso = 0 Then ; esto significa q no estamos en la creacion de particiones en serie
									; solo estamos creando una sola particion, y creamos el proceso
		$hPrDiskPart = _CreateDiskPartProcess()	; Diskpart de cero

		If $hPrDiskPart = 0 Then
			Return
		EndIf

		; Select disk
		StdinWrite($hPrDiskPart, "Select " & $sDiskNo & @CRLF)
		If $DebugMode = True Then ConsoleWrite("Select " & $sDiskNo & @CRLF)

		_WaitForCommand($hPrDiskPart)

		$sOutput = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sOutput)
		$hTransferirProceso = $hPrDiskPart
	EndIf
	$hPrDiskPart = $hTransferirProceso ; por si el proceso viene de una creacion de particiones
										; en serie
	; Create partition
	If $iPartSize = -1 Then
		; Create partition of the specified type with max. size
		StdinWrite($hPrDiskPart, "Create Partition " & $sPartType & @CRLF)					; crea particion con lo q resta
		If $DebugMode = True Then ConsoleWrite("Create Partition " & $sPartType & @CRLF)
	Else
		StdinWrite($hPrDiskPart, "Create Partition " & $sPartType & " Size=" & $iPartSize & @CRLF); crea particion con un tamaño especifico
		If $DebugMode = True Then ConsoleWrite("Create Partition " & $sPartType & " Size=" & $iPartSize & @CRLF)
	EndIf

	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

	; Assign drive letter
	If $sPartType <> "Extended" Then
		If $sLetter = -1 Then													;asigna letra por defecto
			StdinWrite($hPrDiskPart, "Assign" & @CRLF)							;automaticamente si $sLetter es igual a -1
			If $DebugMode = True Then ConsoleWrite("Assign" & @CRLF)
		Else
			StdinWrite($hPrDiskPart, "Assign Letter=" & $sLetter & @CRLF)
			If $DebugMode = True Then ConsoleWrite("Assign Letter=" & $sLetter & @CRLF)
		EndIf

		_WaitForCommand($hPrDiskPart)

		$sOutput = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sOutput)
	EndIf
	$hTransferirProceso = $hPrDiskPart
	If $bContinueToFormat = False Then								; sino formateamos la particion recien creada
		_RefreshDiskPartInfo($sDiskNo, $stbStatus, $hPrDiskPart)	;cerramos el proceso aqui nomas
		StdinWrite($hPrDiskPart)	; Close the DiskPart process
	EndIf
EndFunc

Func _DeletePartition($sDiskNo, $sPartNo, $bIsExtended = False, $stbStatus = 0)
	Local $sOutput
	Local $hPrDiskPart

	GUICtrlSetData($stbStatus, Cambiar_a_Esp("Borrando " & $sPartNo & " en " & $sDiskNo & ", Espere..."))

	$hPrDiskPart = _CreateDiskPartProcess()

	If $hPrDiskPart = 0 Then
		Return
	EndIf

	; Select disk
	StdinWrite($hPrDiskPart, "Select " & $sDiskNo & @CRLF)
	If $DebugMode = True Then ConsoleWrite("Select " & $sDiskNo & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

	; Select partition
	StdinWrite($hPrDiskPart, "Select " & $sPartNo & @CRLF)
	If $DebugMode = True Then ConsoleWrite("Select " & $sPartNo & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

	; Delete partition
	If $bIsExtended = True Then
		StdinWrite($hPrDiskPart, "Delete Partition Override" & @CRLF)
		If $DebugMode = True Then ConsoleWrite("Delete Partition Override" & @CRLF)
	Else
		StdinWrite($hPrDiskPart, "Delete Partition Override" & @CRLF)
		If $DebugMode = True Then ConsoleWrite("Delete Partition Override" & @CRLF)
	EndIf

	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

	_RefreshDiskPartInfo($sDiskNo, $stbStatus, $hPrDiskPart)
	StdinWrite($hPrDiskPart)	; Close the DiskPart process
EndFunc

Func _EditPartition($sDiskNo, $sPartNo, $sCurrLetter, $sNewLetter, $sLabel, $bMarkActive = False, $stbStatus = 0)
	Local $sOutput
	Local $hPrDiskPart

	GUICtrlSetData($stbStatus, Cambiar_a_Esp("Modificando atributos de " & $sPartNo & " en " & $sDiskNo & ", Espere..."))

	; Set drive label
	If $sCurrLetter <> "" And $sNewLetter = "" Then
		DriveSetLabel($sCurrLetter, $sLabel)
	EndIf

	$hPrDiskPart = _CreateDiskPartProcess()

	If $hPrDiskPart = 0 Then
		Return
	EndIf

	; Select disk
	StdinWrite($hPrDiskPart, "Select " & $sDiskNo & @CRLF)
	If $DebugMode = True Then ConsoleWrite("Select " & $sDiskNo & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

	; Select partition
	StdinWrite($hPrDiskPart, "Select " & $sPartNo & @CRLF)
	If $DebugMode = True Then ConsoleWrite("Select " & $sPartNo & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

	; Assign or remove drive letter
	If $sNewLetter <> $sCurrLetter Then
		If $sNewLetter = "(Primera disponible)" Then  ;version 0.4.1.3
			StdinWrite($hPrDiskPart, "assign" & @CRLF)
			If $DebugMode = True Then ConsoleWrite("assign" & @CRLF)
		Else
			If $sNewLetter = "" Then
			StdinWrite($hPrDiskPart, "Remove" & @CRLF)
			If $DebugMode = True Then ConsoleWrite("Remove" & @CRLF)
		Else
			StdinWrite($hPrDiskPart, "Assign Letter=" & $sNewLetter & @CRLF)
			If $DebugMode = True Then ConsoleWrite("Assign Letter=" & $sNewLetter & @CRLF)
		EndIf
	EndIf

		_WaitForCommand($hPrDiskPart)

		$sOutput = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sOutput)
	EndIf

	; Mark partition active
	If $bMarkActive = True Then
		StdinWrite($hPrDiskPart, "Active" & @CRLF)
		If $DebugMode = True Then ConsoleWrite("Active" & @CRLF)

		_WaitForCommand($hPrDiskPart)

		$sOutput = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sOutput)
	EndIf

	; Set drive label
	If $sNewLetter <> "" Then
		DriveSetLabel($sNewLetter, $sLabel)
	EndIf

	_RefreshDiskPartInfo($sDiskNo, $stbStatus, $hPrDiskPart)
	StdinWrite($hPrDiskPart)	; Close the DiskPart process
EndFunc

Func _BorrarDisco($sDiskNo, $stbStatus = 0)
	Local $sOutput
	Local $hPrDiskPart

	GUICtrlSetData($stbStatus, "Borrando el " & Cambiar_a_Esp($sDiskNo) & ", Espere...")

	$hPrDiskPart = _CreateDiskPartProcess()

	If $hPrDiskPart = 0 Then
		Return
	EndIf

	; Select disk
	StdinWrite($hPrDiskPart, "Select " & $sDiskNo & @CRLF)
	If $DebugMode = True Then ConsoleWrite("Select " & $sDiskNo & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

	; Select partition
	StdinWrite($hPrDiskPart, "clean" & @CRLF)
	If $DebugMode = True Then ConsoleWrite("clean" & @CRLF)

	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

_RefreshDiskPartInfo($sDiskNo, $stbStatus, $hPrDiskPart)
	StdinWrite($hPrDiskPart)	; Close the DiskPart process
EndFunc

Func _FormatPartition($sDiskNo, $sPartNo, $sSistArch, $bToActive, $stbStatus = 0, $CloseProcess = -1)  ; CloseProcess  -1 por defecto cierra el proceso Diskpart
	Local $sOutput
	Local $hPrDiskPart

	If $sPartNo <> -1 Then  ; esto significa q se ejecuta el formateo de forma aislada de la creacion de la particion
							; se crea el proceso Diskpart de cero
		GUICtrlSetData($stbStatus, Cambiar_a_Esp("Formateando " & $sPartNo & " en " & $sDiskNo & ", Espere..."))

		$hPrDiskPart = _CreateDiskPartProcess()

		If $hPrDiskPart = 0 Then
			Return
		EndIf

		; Select disk
		StdinWrite($hPrDiskPart, "Select " & $sDiskNo & @CRLF)
		If $DebugMode = True Then ConsoleWrite("Select " & $sDiskNo & @CRLF)

		_WaitForCommand($hPrDiskPart)

		$sOutput = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sOutput)

		; Select partition
		StdinWrite($hPrDiskPart, "Select " & $sPartNo & @CRLF)
		If $DebugMode = True Then ConsoleWrite("Select " & $sPartNo & @CRLF)

		_WaitForCommand($hPrDiskPart)

		$sOutput = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sOutput)
		$hTransferirProceso = $hPrDiskPart
	EndIf

	If $sPartNo = -1 Then
		GUICtrlSetData($stbStatus, Cambiar_a_Esp("Formateando Partición en " & $sDiskNo & ", Espere..."))
	EndIf
	$hPrDiskPart = $hTransferirProceso
	; Formatear partition
	StdinWrite($hPrDiskPart, "Format fs=" & $sSistArch & " quick" & @CRLF)
	If $DebugMode = True Then ConsoleWrite("Format fs=" & $sSistArch & " quick" & @CRLF)
	_WaitForCommand($hPrDiskPart)

	$sOutput = _GetOutput($hPrDiskPart)
	_CheckForDiskPartErrors($sOutput)

	If $bToActive = True Then
		StdinWrite($hPrDiskPart, "active" & @CRLF)
		If $DebugMode = True Then ConsoleWrite("active" & @CRLF)
		_WaitForCommand($hPrDiskPart)

		$sOutput = _GetOutput($hPrDiskPart)
		_CheckForDiskPartErrors($sOutput)

	EndIf
	$hTransferirProceso = $hPrDiskPart			; Transfiere el proceso Diskpart por si vamos acrear particiones en serie
	If $CloseProcess = -1 Then						; Cierra el proceso por defecto
		_RefreshDiskPartInfo($sDiskNo, $stbStatus, $hPrDiskPart)
		StdinWrite($hPrDiskPart)	; Close the DiskPart process
		$hTransferirProceso = 0				;Cierra la Tranferencia de procesos, no se va a realizar partciones en serie
	EndIf

EndFunc



