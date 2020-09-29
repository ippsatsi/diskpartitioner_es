Func CreateForm_frmEditPartition(ByRef $afrmNew, $frmParent)

	Dim $afrmNew[6][2]

	$afrmNew[0][0] = "$frmEditPartition"
	$afrmNew[0][1] = GUICreate("Editar Particion", 278, 144,  (@DesktopWidth - 0)/2, (@DesktopHeight - 274)/2, _
									BitOr($WS_CAPTION, $WS_SYSMENU, $WS_POPUP), -1, $frmParent)

	GUICtrlCreateLabel("Cambiar nombre:", 8, 16, 108, 13, $SS_RIGHT);, $WS_EX_STATICEDGE)
	$afrmNew[1][0] = "$txtPartLabel"
	$afrmNew[1][1] = GUICtrlCreateInput("", 124, 14, 125, 21)
	GUICtrlCreateLabel("Asignar letra:", 8, 49, 108, 13, $SS_RIGHT)
	$afrmNew[2][0] = "$cboDriveLetter"
	$afrmNew[2][1] = GUICtrlCreateCombo("", 124, 47, 125, 21, BitOr($CBS_DROPDOWNLIST, $CBS_SORT, $WS_VSCROLL))
	$afrmNew[3][0] = "$chkActive"
	$afrmNew[3][1] = GUICtrlCreateCheckbox("Marcar particion como activa", 106, 80, 165, 17)
	$afrmNew[4][0] = "$cmdOK"
	$afrmNew[4][1] = GUICtrlCreateButton("&OK", 96, 112, 75, 25)
	$afrmNew[5][0] = "$cmdCancel"
	$afrmNew[5][1] = GUICtrlCreateButton("Cancelar", 176, 112, 75, 25, $BS_DEFPUSHBUTTON)
EndFunc

Func frmEditPartition_Initialize()
	Local $iPartIndex
	Local $lvwPartitions, $cboDriveLetter, $chkActive, $chkInactive

	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	$cboDriveLetter = _GetCtrl("$cboDriveLetter", $afrmEditPartition)
	$chkActive = _GetCtrl("$chkActive", $afrmEditPartition)

	frmEditPartition_LoadIcons()

	If $asPartitions[$iPartIndex][1] = "Principal" Then   ; de Primary a Principal version 0.4.1.1
		If $asPartitions[$iPartIndex][13] = "No" Then
			GUICtrlSetState($chkActive, $GUI_UNCHECKED)
			GUICtrlSetState($chkActive, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkActive, $GUI_CHECKED)
			GUICtrlSetState($chkActive, $GUI_DISABLE)
		EndIf
	Else
		GUICtrlSetState($chkActive, $GUI_DISABLE)
		GUICtrlSetState($chkActive, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData(_GetCtrl("$txtPartLabel", $afrmEditPartition), $asPartitions[$iPartIndex][6])

	GUICtrlSetData($cboDriveLetter, "")	; Delete all items

	;frmEditPartition_LoadDriveLetters()
	_LoadDriveLetters($afrmEditPartition) ; populate drive letter drop-down

	If $asPartitions[$iPartIndex][5] <> "" Then
        ;add and set current drive letter to default position in drop down
		GUICtrlSetData($cboDriveLetter, $asPartitions[$iPartIndex][5] & ":", $asPartitions[$iPartIndex][5] & ":")
	Endif

	GUICtrlSetState(_GetCtrl("$txtPartLabel", $afrmEditPartition), $GUI_FOCUS)

	frmEditPartition_LoadIcons()
EndFunc

Func frmEditPartition_WndProc()
	Select

	Case $msg[0] = $GUI_EVENT_CLOSE
		GUISetState(@SW_ENABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_HIDE, $afrmEditPartition[0][1])
	Case $msg[0] = _GetCtrl("$cmdOK", $afrmEditPartition)
		frmEditPartition_cmdOK_Click()
	Case $msg[0] = _GetCtrl("$cmdCancel", $afrmEditPartition)
		$msg[0] = $GUI_EVENT_CLOSE
		frmEditPartition_WndProc()
	EndSelect
EndFunc

Func frmEditPartition_LoadIcons()
	If @compiled = 1 Then
		; Do nothing
	Else
		GUISetIcon("icons\0.ico", 0, $afrmEditPartition[0][1])
	EndIf
EndFunc

Func frmEditPartition_cmdOK_Click()
	Local $iDiskNo, $iPartIndex
	Local $lvwPartitions, $stbStatus
	Local $sNewLabel, $sCurrLetter, $sNewLetter, $bMarkActive = False

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)

	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	$sNewLabel = GUICtrlRead(_GetCtrl("$txtPartLabel", $afrmEditPartition))
	$sNewLetter = GUICtrlRead(_GetCtrl("$cboDriveLetter", $afrmEditPartition))

	; Close $frmEditPartition window
	$msg[0] = $GUI_EVENT_CLOSE
	frmEditPartition_WndProc()

	If $asPartitions[$iPartIndex][5] <> "" Then
		$sCurrLetter = $asPartitions[$iPartIndex][5] & ":"
	EndIf

	If $sNewLetter = "(None)" Then
		$sNewLetter = ""
	EndIf

	If GUICtrlRead(_GetCtrl("$chkActive", $afrmEditPartition)) = $GUI_CHECKED And _
		GUICtrlGetState(_GetCtrl("$chkActive", $afrmEditPartition)) <> 144 Then

		$bMarkActive = True
	EndIf

	ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
	frmDiskPart_ChangeControlState()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
	GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)

	_EditPartition($sCurrentDisk, $asPartitions[$iPartIndex][0], $sCurrLetter, $sNewLetter, $sNewLabel, $bMarkActive, $stbStatus)

	frmSelectDisk_LoadDisks()
	frmDiskPart_LoadPartitions()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)
EndFunc