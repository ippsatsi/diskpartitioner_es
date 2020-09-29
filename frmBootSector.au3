#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
Func CreateForm_BootSector(ByRef $afrmNew, $frmParent)

	Dim $afrmNew[5][2]
	$afrmNew[0][0] = "frmBootSector"
	$afrmNew[0][1] = GUICreate("Sector De Arranque", 250, 210, (@DesktopWidth - 100)/2, (@DesktopHeight - 274)/2, _
						BitOr($WS_CAPTION, $WS_SYSMENU, $WS_POPUP), -1, $frmParent)
	GUICtrlCreateGroup("Reinstalar Sector de Arranque :", 8, 15, 235, 60)
	GUICtrlCreateLabel("Esto eliminara cualquier virus que se" & @CRLF & "encuentre en el sector de arranque del disco duro en la unidad activa ( con el simbolo ", 20, 30, 220, 43)
	GUICtrlCreateIcon("shell32.dll", 16,213, 55, 16,16 )
	GUICtrlCreateLabel(")", 231, 55, 10, 13)
	GUICtrlCreateGroup("Sistema Operativo:", 8, 80,235, 90)
	$afrmNew[1][0] = "$bRadioW7"
	$afrmNew[1][1] = GUICtrlCreateRadio("Vista/W7/W8/W8.1",20, 110, 120, 13)
	$afrmNew[2][0] = "$bRadioXP"
	$afrmNew[2][1] = GUICtrlCreateRadio("Windows XP",20, 140, 90, 13)

	$afrmNew[3][0] = "$cmdOK"
	$afrmNew[3][1] = GUICtrlCreateButton("&OK", 50, 176, 75, 25)
	$afrmNew[4][0] = "$cmdCancel"
	$afrmNew[4][1] = GUICtrlCreateButton("Cancelar", 140, 176, 75, 25)

EndFunc

Func frmBootSector_Initialize()
	Local $iDiskIndex, $iPartIndex, $lvwPartitions
	Local $chkConfirmDelete, $cmdOK

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next
	GUICtrlSetState(_GetCtrl("$bRadioW7", $afrmBootSector), $GUI_CHECKED)
	frmBootSector_LoadIcons()

EndFunc

Func frmBootSector_LoadIcons()
	If @compiled = 1 Then
		; Do nothing
	Else
		GUISetIcon("icons\0.ico", 0, $afrmBootSector[0][1])
	EndIf
EndFunc

Func frmBootSector_WndProc()
	Select
		Case $msg[0] = $GUI_EVENT_CLOSE
			GUISetState(@SW_ENABLE, $afrmDiskpart[0][1])
			GUISetState(@SW_HIDE, $afrmBootSector[0][1])
		Case $msg[0] = _GetCtrl("$cmdOK", $afrmBootSector)
			frmBootSector_cmdOK_Click()
		Case $msg[0] = _GetCtrl("$cmdCancel", $afrmBootSector)
			$msg[0] = $GUI_EVENT_CLOSE
			frmBootSector_WndProc()
	EndSelect

EndFunc

Func frmBootSector_cmdOK_Click()
	Local $iPartIndex
	Local $lvwPartitions
	Local $bRadioSelected
	Local $sSistemaOperativoSelected, $sDriveLetter

	$bRadioSelected =GUICtrlRead(_GetCtrl("$bRadioW7", $afrmBootSector))
	If $bRadioSelected = $GUI_CHECKED Then
		$sSistemaOperativoSelected = "/nt60 "
	Else
		$sSistemaOperativoSelected = "/nt52 "
	EndIf


	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	If $iPartIndex <> "" Then
		$sDriveLetter = $asPartitions[$iPartIndex][5]
		If $sDriveLetter = "" Then
			DiskPartitioner_ErrorHandler("No drive letter assigned.", "A drive letter must be assigned to format the selected partition.", "Non-Fatal")
			SetError(1)
			Return
		Else
;~ 			MsgBox(0,"run","bootsect  " & $sSistemaOperativoSelected & $sDriveLetter & ":" & " /force /mbr & pause")
			Run(@ComSpec & " /c " & "bootsect  " & $sSistemaOperativoSelected & $sDriveLetter & ":" & " /force /mbr & pause", "", @SW_MAXIMIZE)
		EndIf
	EndIf


;~ 	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
;~ 	$Sistema_Selected = GUICtrlRead(_GetCtrl("$sComboSelect_sistem", $afrmBootSector))
;~ 	$msg[0] = $GUI_EVENT_CLOSE
;~ 	frmBootSector_WndProc()

;~ 	ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
;~ 	frmDiskPart_ChangeControlState()

;~ 	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
;~ 	GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)

;~ 	_FormatPartition($sCurrentDisk, $asPartitions[$iPartIndex][0], $Sistema_Selected, False, $stbStatus)

;~ 	frmSelectDisk_LoadDisks()
;~ 	frmDiskPart_LoadPartitions()

;~ 	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)


EndFunc

