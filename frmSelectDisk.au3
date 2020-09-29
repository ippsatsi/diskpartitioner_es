Func CreateForm_frmSelectDisk(ByRef $afrmNew, $frmParent)

	Dim $afrmNew[5][2], $iExStyle

	$afrmNew[0][0] = "$frmSelectDisk"
	$afrmNew[0][1] = GUICreate("Seleccione Disco Duro", 510, 200, (@DesktopWidth - 100)/2, (@DesktopHeight - 352)/2, _
							BitOr($WS_CAPTION, $WS_SYSMENU, $WS_POPUP), -1, $frmParent)
	GUICtrlCreateLabel("Discos Duros disponibles:", 8, 8, 180, 13)
	$afrmNew[1][0] = "$lvwHardDisks"
	$afrmNew[1][1] = GUICtrlCreateListView("Disco #   |Modelo|id|Tipo|Tamaño|Espacio Libre|", 8, 28, 495, 124, _
					BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER, $LVS_SINGLESEL))
					GUICtrlSendMsg(-1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	$afrmNew[2][0] = "$cmdRefresh"
	$afrmNew[2][1] = GUICtrlCreateButton("&Actualizar", 8, 159, 75, 23)
	$afrmNew[3][0] = "$cmdOK"
	$afrmNew[3][1] = GUICtrlCreateButton("&OK", 230, 159, 75, 23, $WS_DISABLED)
	$afrmNew[4][0] = "$cmdCancel"
	$afrmNew[4][1] = GUICtrlCreateButton("Cancelar", 311, 159, 75, 23, $BS_DEFPUSHBUTTON)
EndFunc

Func frmSelectDisk_Initialize()
	frmSelectDisk_LoadDisks()

	frmSelectDisk_LoadIcons()
	frmSelectDisk_ChangeControlState()
EndFunc

Func frmSelectDisk_WndProc()

	frmSelectDisk_ChangeControlState()

	Select

	Case $msg[0] = $GUI_EVENT_CLOSE
		GUISetState(@SW_ENABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_HIDE, $afrmSelectDisk[0][1])
	Case $msg[0] = _GetCtrl("$cmdRefresh", $afrmSelectDisk)
		frmSelectDisk_cmdRefresh_Click()
	Case $msg[0] = _GetCtrl("$cmdOK", $afrmSelectDisk)
		$msg[0] = $GUI_EVENT_CLOSE
		frmSelectDisk_WndProc()
		frmSelectDisk_cmdOK_Click()
	Case $msg[0] = _GetCtrl("$cmdCancel", $afrmSelectDisk)
		$msg[0] = $GUI_EVENT_CLOSE
		frmSelectDisk_WndProc()
	EndSelect
EndFunc

Func frmSelectDisk_ChangeControlState()
	If ControlListView($afrmSelectDisk[0][1], "", _GetCtrl("$lvwHardDisks", $afrmSelectDisk), _
						"GetSelectedCount") = 1 Then

		GUICtrlSetState(_GetCtrl("$cmdOK", $afrmSelectDisk), $GUI_ENABLE)
	Else
		GUICtrlSetState(_GetCtrl("$cmdOK", $afrmSelectDisk), $GUI_DISABLE)
	EndIf
EndFunc

Func frmSelectDisk_LoadIcons()
	If @compiled = 1 Then
		GUICtrlSetImage(_GetCtrl("$lvwHardDisks", $afrmSelectDisk), @ScriptFullPath, 0)
	Else
		GUISetIcon("icons\0.ico", 0, $afrmSelectDisk[0][1])
		GUICtrlSetImage(_GetCtrl("$lvwHardDisks", $afrmSelectDisk), "icons\0.ico", 0)
	EndIf
EndFunc

Func frmSelectDisk_cmdRefresh_Click()
	Local $stbStatus

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmSelectDisk), $GUI_DISABLE)
	GUICtrlSetState(_GetCtrl("$cmdOK", $afrmSelectDisk), $GUI_DISABLE)

	_RefreshDiskPartInfo("", $stbStatus)
	frmSelectDisk_LoadDisks()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmSelectDisk), $GUI_ENABLE)
EndFunc

Func frmSelectDisk_LoadDisks()
	Local $lvwHardDisks

	$lvwHardDisks = _GetCtrl("$lvwHardDisks", $afrmSelectDisk)

	; Populate $lvwHardDisks
	GUICtrlSendMsg($lvwHardDisks, $LVM_DELETEALLITEMS, 0, 0)	; Delete all Items

	For $i = 0 to UBound($asDisks, 1) - 1
		GUICtrlCreateListViewItem($asDisks[$i][0] & '|' & $asDisks[$i][6] & '|' & $asDisks[$i][7] & '|' & $asDisks[$i][8] _
									& '|' & $asDisks[$i][2] & '|' & $asDisks[$i][3], $lvwHardDisks)

	;MsgBox(0, "Disk Info", "asDisks[$i][0]: " & $asDisks[$i][0] & @CRLF & "asDisks[$i][1]: " & $asDisks[$i][1] & @CRLF _
	;					 & "asDisks[$i][2]: " & $asDisks[$i][2] & @CRLF & "asDisks[$i][3]: " & $asDisks[$i][3] & @CRLF _
	;					 & "asDisks[$i][4]: " & $asDisks[$i][4] & @CRLF & "asDisks[$i][5]: " & $asDisks[$i][5] & @CRLF _
	;					 & "asDisks[$i][6]: " & $asDisks[$i][6] & @CRLF & "asDisks[$i][7]: " & $asDisks[$i][7] & @CRLF _
	;					 & "asDisks[$i][8]: " & $asDisks[$i][8])
	Next
EndFunc

Func frmSelectDisk_cmdOK_Click($bLoadFirstDisk = False)
	Local $sDiskNo, $iDiskIndex
	Local $lvwHardDisks, $lvwPartitions, $stbStatus

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$lvwHardDisks = _GetCtrl("$lvwHardDisks", $afrmSelectDisk)
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)

	If ControlListView($afrmSelectDisk[0][1], "", $lvwHardDisks, "GetItemCount") > 0 Then
		If $bLoadFirstDisk = True Then
			$sDiskNo = ControlListView($afrmSelectDisk[0][1], "", $lvwHardDisks, "GetText", 0, 0)
		Else
			$iDiskIndex = ControlListView($afrmSelectDisk[0][1], "", $lvwHardDisks, "GetSelected")
			$sDiskNo = ControlListView($afrmSelectDisk[0][1], "", $lvwHardDisks, "GetText", $iDiskIndex, 0)
		EndIf

		ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
		frmDiskPart_ChangeControlState()

		GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)

		_RefreshDiskPartInfo($sDiskNo, $stbStatus)

		GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)
	EndIf

	frmDiskPart_LoadPartitions()
EndFunc
