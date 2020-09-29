#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
Func CreateForm_frmFormat(ByRef $afrmNew, $frmParent)

	Dim $afrmNew[4][2]
	$afrmNew[0][0] = "frmFormat"
	$afrmNew[0][1] = GUICreate("Formatear con", 200, 110, (@DesktopWidth - 100)/2, (@DesktopHeight - 274)/2, _
						BitOr($WS_CAPTION, $WS_SYSMENU, $WS_POPUP), -1, $frmParent)

	GUICtrlCreateLabel("Sist. de Archivos: ", 20, 30, 130, 13)
	$afrmNew[1][0] = "$sComboSelect_sistem"
	$afrmNew[1][1] = GUICtrlCreateCombo("",115, 26, 70, 13, $CBS_DROPDOWNLIST )
	GUICtrlCreateLabel("* en FAT32 maximo hasta 32 GB", 22, 55, 160,13)
	$afrmNew[2][0] = "$cmdOK"
	$afrmNew[2][1] = GUICtrlCreateButton("&OK", 20, 76, 75, 25)
	$afrmNew[3][0] = "$cmdCancel"
	$afrmNew[3][1] = GUICtrlCreateButton("Cancelar", 110, 76, 75, 25)

EndFunc

Func frmFormat_Initialize()
	Local $iDiskIndex, $iPartIndex, $lvwPartitions
	Local $chkConfirmDelete, $cmdOK

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	GUICtrlSetData(_GetCtrl("$sComboSelect_sistem", $afrmFormat),"")
	GUICtrlSetData(_GetCtrl("$sComboSelect_sistem", $afrmFormat),"NTFS|FAT32", "NTFS")

	frmFormat_LoadIcons()

EndFunc

Func frmFormat_LoadIcons()
	If @compiled = 1 Then
		; Do nothing
	Else
		GUISetIcon("icons\0.ico", 0, $afrmFormat[0][1])
	EndIf
EndFunc

Func frmFormat_WndProc()
	Select
		Case $msg[0] = $GUI_EVENT_CLOSE
			GUISetState(@SW_ENABLE, $afrmDiskpart[0][1])
			GUISetState(@SW_HIDE, $afrmFormat[0][1])
		Case $msg[0] = _GetCtrl("$cmdOK", $afrmFormat)
			frmFormat_cmdOK_Click()
		Case $msg[0] = _GetCtrl("$cmdCancel", $afrmFormat)
			$msg[0] = $GUI_EVENT_CLOSE
			frmFormat_WndProc()
	EndSelect

EndFunc

Func frmFormat_cmdOK_Click()
	Local $iPartIndex
	Local $lvwPartitions, $stbStatus
	Local $Sistema_Selected

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)

	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	$Sistema_Selected = GUICtrlRead(_GetCtrl("$sComboSelect_sistem", $afrmFormat))
	$msg[0] = $GUI_EVENT_CLOSE
	frmFormat_WndProc()

	ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
	frmDiskPart_ChangeControlState()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
	GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)

	_FormatPartition($sCurrentDisk, $asPartitions[$iPartIndex][0], $Sistema_Selected, False, $stbStatus)

	frmSelectDisk_LoadDisks()
	frmDiskPart_LoadPartitions()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)


EndFunc


