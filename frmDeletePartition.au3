Func CreateForm_frmDeletePartition(ByRef $afrmNew, $frmParent)

	Dim $afrmNew[12][2]

	$afrmNew[0][0] = "$frmDeletePartition"
	$afrmNew[0][1] = GUICreate("Borrar Partición", 384, 260, (@DesktopWidth - 100)/2, (@DesktopHeight - 274)/2, _
									BitOr($WS_CAPTION, $WS_SYSMENU, $WS_POPUP), -1, $frmParent)
	$afrmNew[1][0] = "$icoDelete"
	$afrmNew[1][1] = GUICtrlCreateIcon("shell32.dll", 50, 8, 8, 32, 32)
	GUICtrlCreateLabel("Advertencia: La particion seleccionada puede contener datos importantes." & @CRLF & _
					"Si continua borrara todos los datos en esta partición.", 51, 10, 325, 50);, -1, $WS_EX_STATICEDGE)
					GUICtrlSetFont(-1, 8.5, 600)

	GUICtrlCreateGroup("Información de Partición:", 8, 59, 368, 105)
	$afrmNew[2][0] = "$lblPartLocation"
	$afrmNew[2][1] = GUICtrlCreateLabel("", 16, 80, 352, 17, $SS_CENTER, $WS_EX_STATICEDGE)
					GUICtrlSetFont(-1, 8.5, 600)
	$afrmNew[3][0] = "$lblPartType"
	$afrmNew[3][1] = GUICtrlCreateLabel("Tipo: ", 16, 105, 105, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[4][0] = "$lblPartSize"
	$afrmNew[4][1] = GUICtrlCreateLabel("Tamaño: ", 16, 130, 105, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[5][0] = "$lblPartLabel"
	$afrmNew[5][1] = GUICtrlCreateLabel("Nombre: ", 123, 105, 122, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[6][0] = "$lblDriveLetter"
	$afrmNew[6][1] = GUICtrlCreateLabel("Letra: ", 123, 130, 122, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[7][0] = "$lblPartFS"
	$afrmNew[7][1] = GUICtrlCreateLabel("Sist. de archivos: ", 247, 105, 122, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[8][0] = "$lblPartActive"
	$afrmNew[8][1] = GUICtrlCreateLabel("Activo: ", 247, 130, 122, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)

	GUICtrlCreateLabel("¿Esta seguro de borrar esta partición?", 8, 171, 368, 17, $SS_CENTER);, $WS_EX_STATICEDGE)
					GUICtrlSetFont(-1, 8.5, 600)
	$afrmNew[9][0] = "$chkConfirmDelete"
	$afrmNew[9][1] = GUICtrlCreateCheckbox("Borrar Partición y todos los datos en esta partición.", 8, 195, 368, 17 )
	$afrmNew[10][0] = "$cmdDelete"
	$afrmNew[10][1] = GUICtrlCreateButton("Borrar", 222, 226, 75, 25, $WS_DISABLED)
	$afrmNew[11][0] = "$cmdCancel"
	$afrmNew[11][1] = GUICtrlCreateButton("Cancelar", 302, 226, 75, 25, $BS_DEFPUSHBUTTON)
EndFunc

Func frmDeletePartition_Initialize()
	Local $iDiskIndex, $iPartIndex, $lvwPartitions
	Local $chkConfirmDelete, $cmdDelete

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	$chkConfirmDelete = _GetCtrl("$chkConfirmDelete", $afrmDeletePartition)
	$cmdDelete = _GetCtrl("$cmdDelete", $afrmDeletePartition)

	GUICtrlSetData(_GetCtrl("$lblPartLocation", $afrmDeletePartition), $asPartitions[$iPartIndex][0] & " on " & $asDisks[$iDiskIndex][6])
	GUICtrlSetData(_GetCtrl("$lblPartType", $afrmDeletePartition), "Tipo: " & $asPartitions[$iPartIndex][1])
	GUICtrlSetData(_GetCtrl("$lblPartSize", $afrmDeletePartition), "Tamaño: " & _ConvertirGBbinToGBdecimal($asPartitions[$iPartIndex][2]))
	GUICtrlSetData(_GetCtrl("$lblPartLabel", $afrmDeletePartition), "Nombre: " & $asPartitions[$iPartIndex][6])
	GUICtrlSetData(_GetCtrl("$lblDriveLetter", $afrmDeletePartition), "Letra: " & $asPartitions[$iPartIndex][5])
	GUICtrlSetData(_GetCtrl("$lblPartFS", $afrmDeletePartition), "Sist. de archivos: " & $asPartitions[$iPartIndex][7])
	GUICtrlSetData(_GetCtrl("$lblPartActive", $afrmDeletePartition), "Activo: " & $asPartitions[$iPartIndex][13])

	frmDeletePartition_LoadIcons()
	GUICtrlSetState($chkConfirmDelete, $GUI_UNCHECKED)
	GUICtrlSetState($cmdDelete, $GUI_DISABLE)

EndFunc

Func frmDeletePartition_WndProc()

	Select

	Case $msg[0] = $GUI_EVENT_CLOSE
		GUISetState(@SW_ENABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_HIDE, $afrmDeletePartition[0][1])
	Case $msg[0] = _GetCtrl("$chkConfirmDelete", $afrmDeletePartition)
		frmDeletePartition_chkConfirmDelete_Click()
	Case $msg[0] = _GetCtrl("$cmdDelete", $afrmDeletePartition)
		frmDeletePartition_cmdDelete_Click()
	Case $msg[0] = _GetCtrl("$cmdCancel", $afrmDeletePartition)
		$msg[0] = $GUI_EVENT_CLOSE
		frmDeletePartition_WndProc()
	EndSelect
EndFunc

Func frmDeletePartition_LoadIcons()
	If @compiled = 1 Then
		GUICtrlSetImage(_GetCtrl("$icoDelete", $afrmDeletePartition), @ScriptFullPath, 2)
	Else
		GUISetIcon("icons\0.ico", 0, $afrmDeletePartition[0][1])
		GUICtrlSetImage(_GetCtrl("$icoDelete", $afrmDeletePartition), "icons\2.ico", 0)
	EndIf
EndFunc

Func frmDeletePartition_chkConfirmDelete_Click()
	Local $chkConfirmDelete, $cmdDelete, $stbStatus

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$chkConfirmDelete = _GetCtrl("$chkConfirmDelete", $afrmDeletePartition)
	$cmdDelete = _GetCtrl("$cmdDelete", $afrmDeletePartition)

	If GUICtrlRead($chkConfirmDelete) = $GUI_CHECKED Then
		GUICtrlSetState($cmdDelete, $GUI_ENABLE)
	ElseIf GUICtrlRead($chkConfirmDelete) = $GUI_UNCHECKED Then
		GUICtrlSetState($cmdDelete, $GUI_DISABLE)
	EndIf
EndFunc

Func frmDeletePartition_cmdDelete_Click()
	Local $iPartIndex
	Local $lvwPartitions, $stbStatus

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)

	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")

	$msg[0] = $GUI_EVENT_CLOSE
	frmDeletePartition_WndProc()

	ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
	frmDiskPart_ChangeControlState()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
	GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)

	_DeletePartition($sCurrentDisk, $asPartitions[$iPartIndex][0], False, $stbStatus)

	frmSelectDisk_LoadDisks()
	frmDiskPart_LoadPartitions()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)
EndFunc