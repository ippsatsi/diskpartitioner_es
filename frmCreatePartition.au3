Func CreateForm_frmCreatePartition(ByRef $afrmNew, $frmParent)

	Dim $afrmNew[15][2]

	$afrmNew[0][0] = "$frmCreatePartition"
	$afrmNew[0][1] = GUICreate("Crear Partitcion", 409, 271, (@DesktopWidth - 200)/2, (@DesktopHeight - 271)/2, _
						BitOr($WS_CAPTION, $WS_POPUP), -1, $frmParent)
	$afrmNew[1][0] = "$grPartPie"
	$afrmNew[1][1] = GuiCtrlCreateGraphic(8, 8, 160, 140)
	$afrmNew[2][0] = "$grLegend"
	$afrmNew[2][1] = GUICtrlCreateGraphic(0, 140, 200, 60)

	GUICtrlCreateLabel("Utilizado actualmente", 35, 154, 110, 20)
	$afrmNew[3][0] = "$lblAllocated"
	$afrmNew[3][1] = GUICtrlCreateLabel("", 150, 155, 30, 20)
	GUICtrlCreateLabel("Tamaño seleccionado", 35, 184, 110, 20)
	$afrmNew[4][0] = "$lblCurrentSize"
	$afrmNew[4][1] = GUICtrlCreateLabel("", 150, 185, 30, 20)
	GUICtrlCreateLabel("Espacio Libre", 35, 214, 110, 20)
	$afrmNew[5][0] = "$lblFreeSpace"
	$afrmNew[5][1] = GUICtrlCreateLabel("", 150, 215, 30, 20)

	GUICtrlCreateLabel("Tamaño de Partición (GB):", 148, 42, 140, 13, $SS_RIGHT)  ; version:0.5.1
	$afrmNew[6][0] = "$txtPartSize"
	$afrmNew[6][1] = GUICtrlCreateInput("0", 296, 39, 105, 22, $ES_NUMBER)
	;$afrmNew[6][1] = GUICtrlCreateInput("0", 296, 39, 105, 22)
	$afrmNew[7][0] = "$udPartSize"
	$afrmNew[7][1] = GUICtrlCreateUpdown(_GetCtrl("$txtPartSize", $afrmNew), BitOR($UDS_NOTHOUSANDS, $UDS_ARROWKEYS))
	$afrmNew[8][0] = "$slPartSize"
	$afrmNew[8][1] = GUICtrlCreateSlider(159, 80, 250, 26, BitOR($TBS_TOOLTIPS, $TBS_NOTICKS, $TBS_ENABLESELRANGE))

	GUICtrlCreateLabel("0 GB", 166, 108, 25, 13)   ; version:0.5.1
	$afrmNew[9][0] = "$lblMaxPartSize"
	$afrmNew[9][1] = GUICtrlCreateLabel("", 300, 108, 100, 13, $SS_RIGHT);, $WS_EX_STATICEDGE)

	GUICtrlCreateLabel("Tipo de Particion:", 188, 154, 100, 13, $SS_RIGHT)
	$afrmNew[10][0] = "$cboPartType"
	$afrmNew[10][1] = GUICtrlCreateCombo("", 296, 152, 105, 21, $CBS_DROPDOWNLIST)
;~ 	GUICtrlCreateLabel("Formatear con NTFS", 250, 184, 100, 13, $SS_RIGHT)
	$afrmNew[11][0] = "$chkFormatNtfs"
	$afrmNew[11][1] = GUICtrlCreateCheckbox("Formatear con NTFS", 275, 184, 120, 13, $BS_RIGHTBUTTON)
	GUICtrlCreateLabel("Asignar letra de unidad:", 198, 208, 120, 13, $SS_RIGHT)
	$afrmNew[12][0] = "$cboDriveLetter"
	$afrmNew[12][1] = GUICtrlCreateCombo("", 340, 206, 60, 21, BitOr($CBS_DROPDOWNLIST, $CBS_SORT, $WS_VSCROLL))

	$afrmNew[13][0] = "$cmdOK"
	$afrmNew[13][1] = GUICtrlCreateButton("&OK", 244, 238, 75, 25)
	$afrmNew[14][0] = "$cmdCancel"
	$afrmNew[14][1] = GUICtrlCreateButton("Cancelar", 324, 238, 75, 25)

EndFunc

Global $bExtendedPresent = False
Global $AllLogicalSize = 0
Global $ExtendedFreeSpace = 0
Global $ExtendedSize = 0
Global $iMaxSize = 0

Func frmCreatePartition_Initialize()
	Local $cboPartType
	Local $iDiskIndex, $iFreeSpace, $iAllocated
	Local $chkFormatCtrl

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next
	$chkFormatCtrl= _GetCtrl("$chkFormatNtfs",$afrmCreatePartition)
	GUICtrlSetState($chkFormatCtrl, $GUI_UNCHECKED)
;~ 	$iMaxSize = _ConvertToMB($asDisks[$iDiskIndex][3])
;~ 	$iMaxSize = ConvertToGB($asDisks[$iDiskIndex][3])
	$iFreeSpace = 0
;~ 	$iAllocated = _ConvertToMB($asDisks[$iDiskIndex][2]) - $iMaxSize - $iFreeSpace
	$iAllocated = ConvertToGB($asDisks[$iDiskIndex][2]) - ConvertToGB($asDisks[$iDiskIndex][3])

	$cboPartType = _GetCtrl("$cboPartType", $afrmCreatePartition)
	frmExtended_Logical_Size()
	; Initialize $cboPartTypes
	frmCreatePartition_LoadPartTypes()
	frmCreatePartition_cboPartType_Click()

	; Initialize $cboDriveLetter
	_LoadDriveLetters($afrmCreatePartition)

	; Update pie chart
	frmCreatePartition_CreatePieChart($iAllocated, $iMaxSize, $iFreeSpace)

	; Initialize other controls on form
	GUICtrlSetData(_GetCtrl("$lblMaxPartSize", $afrmCreatePartition), $iMaxSize & " GB")

	GUICtrlSetLimit(_GetCtrl("$slPartSize", $afrmCreatePartition), $iMaxSize, 0)
	_GUICtrlSliderSetRange32(_GetCtrl("$slPartSize", $afrmCreatePartition), 0, $iMaxSize)
	GUICtrlSetData(_GetCtrl("$slPartSize", $afrmCreatePartition), $iMaxSize)

	GUICtrlSetLimit(_GetCtrl("$udPartSize", $afrmCreatePartition), $iMaxSize, 0)
	_GUICtrlUpdownSetRange32(_GetCtrl("$udPartSize", $afrmCreatePartition), 0, $iMaxSize)
	GUICtrlSetData(_GetCtrl("$txtPartSize", $afrmCreatePartition), $iMaxSize)

	; Load icons
	frmCreatePartition_LoadIcons()

EndFunc

Func frmCreatePartition_WndProc()

	Select

	Case $msg[0] = $GUI_EVENT_CLOSE
		GUISetState(@SW_ENABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_HIDE, $afrmCreatePartition[0][1])
	Case $msg[0] = _GetCtrl("$slPartSize", $afrmCreatePartition)
			frmCreatePartition_slPartSize_Click()
	Case $msg[0] = _GetCtrl("$txtPartSize", $afrmCreatePartition)
		frmCreatePartition_txtPartSize_Click()
	Case $msg[0] = _GetCtrl("$cboPartType", $afrmCreatePartition)
		frmCreatePartition_cboPartType_Click()
	Case $msg[0] = _GetCtrl("$cmdOK", $afrmCreatePartition)
		frmCreatePartition_cmdOK_Click()
	Case $msg[0] = _GetCtrl("$cmdCancel", $afrmCreatePartition)
		 $msg[0] = $GUI_EVENT_CLOSE
		 frmCreatePartition_WndProc()

	EndSelect

EndFunc

Func frmCreatePartition_LoadIcons()
	If @compiled = 1 Then
		; Do nothing
	Else
		GUISetIcon("icons\0.ico", 0, $afrmCreatePartition[0][1])
	EndIf
EndFunc

Func frmCreatePartition_slPartSize_Click()
	Local $iDiskIndex
	Local $iCurrentSize, $iFreeSpace, $iAllocated
	Local $iOldSize = $iCurrentSize

	Local $hDLL = DllOpen("user32.dll")

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	;MsgBox(0, "Diskfree", ($asDisks[$iDiskIndex][3]))
;~ 	$iMaxSize = ConvertToGB($asDisks[$iDiskIndex][3])
	;MsgBox(0, "$iMaxSize", $iMaxSize)
;~ 	$iAllocated = ConvertToGB($asDisks[$iDiskIndex][2]) - $iMaxSize
	;MsgBox(0, "$iAllocated", $iAllocated)

	$iCurrentSize = GUICtrlRead(_GetCtrl("$slPartSize", $afrmCreatePartition))
	GUICtrlSetData(_GetCtrl("$txtPartSize", $afrmCreatePartition), $iCurrentSize)
	$iFreeSpace = $asDisks[$iDiskIndex][3] - $iCurrentSize   ; FreeSpace - CurrentSize
	$iAllocated = ConvertToGB($asDisks[$iDiskIndex][2]) - ConvertToGB($asDisks[$iDiskIndex][3])
	; Update pie chart
	frmCreatePartition_CreatePieChart($iAllocated, $iCurrentSize, $iFreeSpace)

	DLLClose($hDLL)

EndFunc

Func frmCreatePartition_txtPartSize_Click()
	Local $iDiskIndex, $iCurrentSize, $iFreeSpace, $iAllocated, $iError

	Local $hDLL = DllOpen("user32.dll")

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

;~ 	$iMaxSize = ConvertToGB($asDisks[$iDiskIndex][3])
	;MsgBox(0, "$iMaxSize", $iMaxSize)
;~ 	$iAllocated = ConvertToGB($asDisks[$iDiskIndex][2]) - $iMaxSize
;~ 	$iAllocated = ConvertToGB($asDisks[$iDiskIndex][2]) - ConvertToGB($asDisks[$iDiskIndex][3])

	$iCurrentSize = GUICtrlRead(_GetCtrl("$txtPartSize", $afrmCreatePartition))
	If $iCurrentSize > $iMaxSize Then
		DiskPartitioner_ErrorHandler("Tamaño de particion fuera de limites", _
									"Especifique un tamaño menor o igual a " & $iMaxSize & " GB.", "Non-Fatal")
		$iCurrentSize = $iMaxSize
		GUICtrlSetData(_GetCtrl("$txtPartSize", $afrmCreatePartition), $iCurrentSize)
		$iError = 1
	EndIf
	$iFreeSpace = $asDisks[$iDiskIndex][3] - $iCurrentSize   ; FreeSpace - CurrentSize
;~ 	$iFreeSpace = $iMaxSize - $iCurrentSize
	$iAllocated = ConvertToGB($asDisks[$iDiskIndex][2]) - ConvertToGB($asDisks[$iDiskIndex][3])
	GUICtrlSetData(_GetCtrl("$slPartSize", $afrmCreatePartition), $iCurrentSize)

	; Update pie chart
	If _Detect_Arrow_Keys() = 0 Then
	frmCreatePartition_CreatePieChart($iAllocated, $iCurrentSize, $iFreeSpace)
	EndIf

	SetError($iError)
EndFunc

Func frmCreatePartition_cboPartType_Click()
	Local $sPartType, $iDiskIndex
	Local $iFreeSpace, $iAllocated
	Local $chkFormatCtrl

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	$iMaxSize = ConvertToGB($asDisks[$iDiskIndex][3])
	$chkFormatCtrl= _GetCtrl("$chkFormatNtfs",$afrmCreatePartition)
	$sPartType = GUICtrlRead(_GetCtrl("$cboPartType", $afrmCreatePartition))
	Select
		Case $sPartType = "Primary"
			$iMaxSize = $iMaxSize - $ExtendedFreeSpace
			GUICtrlSetState(_GetCtrl("$cboDriveLetter", $afrmCreatePartition), $GUI_ENABLE)
			GUICtrlSetState($chkFormatCtrl, $GUI_CHECKED + $GUI_ENABLE)
		Case $sPartType = "Logical"
			$iMaxSize = $ExtendedFreeSpace
			GUICtrlSetState(_GetCtrl("$cboDriveLetter", $afrmCreatePartition), $GUI_ENABLE)
			GUICtrlSetState($chkFormatCtrl, $GUI_CHECKED + $GUI_ENABLE)
		Case $sPartType = "Extended"
			GUICtrlSetState(_GetCtrl("$cboDriveLetter", $afrmCreatePartition), $GUI_DISABLE)
			GUICtrlSetState($chkFormatCtrl, $GUI_UNCHECKED + $GUI_DISABLE)
	EndSelect


		GUICtrlSetState(_GetCtrl("$slPartSize", $afrmCreatePartition), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$udPartSize", $afrmCreatePartition), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$txtPartSize", $afrmCreatePartition), $GUI_ENABLE)

	$iFreeSpace = $asDisks[$iDiskIndex][3] - $iMaxSize  ; FreeSpace - CurrentSize
	$iAllocated = ConvertToGB($asDisks[$iDiskIndex][2]) - ConvertToGB($asDisks[$iDiskIndex][3])

	GUICtrlSetData(_GetCtrl("$lblMaxPartSize", $afrmCreatePartition), $iMaxSize & " GB")

	GUICtrlSetLimit(_GetCtrl("$slPartSize", $afrmCreatePartition), $iMaxSize, 0)
	_GUICtrlSliderSetRange32(_GetCtrl("$slPartSize", $afrmCreatePartition), 0, $iMaxSize)
	GUICtrlSetData(_GetCtrl("$slPartSize", $afrmCreatePartition), $iMaxSize)

	GUICtrlSetLimit(_GetCtrl("$udPartSize", $afrmCreatePartition), $iMaxSize, 0)
	_GUICtrlUpdownSetRange32(_GetCtrl("$udPartSize", $afrmCreatePartition), 0, $iMaxSize)
	GUICtrlSetData(_GetCtrl("$txtPartSize", $afrmCreatePartition), $iMaxSize)

	; Update pie chart
	frmCreatePartition_CreatePieChart($iAllocated, $iMaxSize, $iFreeSpace)

EndFunc

Func frmCreatePartition_cmdOK_Click()
	Local $sPartType, $sDriveLetter
	Local $iPartSize, $iDiskIndex
	Local $stbStatus, $lvwPartitions
	Local $bFormatChecked, $iSelPart, $bPartToActive = False
	Local $bContinueToFormat = False

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iSelPart = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	If $asPartitions = 0 Then $bPartToActive = True

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next
;~ 	$iMaxSize = ConvertToGB($asDisks[$iDiskIndex][3])

	; Refresh partition size value
	frmCreatePartition_txtPartSize_Click()
	If @error Then
		; Invalid value in partition size
		Return
	Else
		$iPartSize = GUICtrlRead(_GetCtrl("$txtPartSize", $afrmCreatePartition))
		If $iPartSize = 0 Then
			DiskPartitioner_ErrorHandler("El tamaño de la particion no puede ser 0 Gb","" ,"Non-Fatal")
			Return
		EndIf

		$sPartType = GUICtrlRead(_GetCtrl("$cboPartType", $afrmCreatePartition))
		$sDriveLetter = GUICtrlRead(_GetCtrl("$cboDriveLetter", $afrmCreatePartition))
		$bFormatChecked = GUICtrlRead(_GetCtrl("$chkFormatNtfs", $afrmCreatePartition))
		If $bFormatChecked = $GUI_CHECKED Then $bContinueToFormat = True

		$msg[0] = $GUI_EVENT_CLOSE
		frmCreatePartition_WndProc()

		ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
		frmDiskPart_ChangeControlState()

		GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)
		$hTransferirProceso = 0 											; Desactivamos la opcion de crear particiones consecutivas y no transferimos procesos
		If $iPartSize = $iMaxSize Then
			_CreatePartition($sCurrentDisk, $sPartType, -1, $sDriveLetter, $stbStatus, $bContinueToFormat)
		Else
			_CreatePartition($sCurrentDisk, $sPartType, $iPartSize, $sDriveLetter, $stbStatus, $bContinueToFormat)
		EndIf

		If $bFormatChecked = $GUI_CHECKED Then
			_FormatPartition($sCurrentDisk, -1, "NTFS", $bPartToActive, $stbStatus)
		EndIf

		frmSelectDisk_LoadDisks()
		frmDiskPart_LoadPartitions()

		GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)
	EndIf
EndFunc

Func frmCreatePartition_LoadPartTypes()
	Local $iDiskIndex, $cboPartType
	Local $PartExtendedNo  ; version 0.5.1

	$cboPartType = _GetCtrl("$cboPartType", $afrmCreatePartition)

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	GUICtrlSetData($cboPartType, "")	; Delete all items


	If $bExtendedPresent = False Then
		GUICtrlSetData($cboPartType, "Primary|Extended")
		GUICtrlSetState($cboPartType, $GUI_ENABLE)
	Else
		If $ExtendedFreeSpace <=  1 Then
			GUICtrlSetData($cboPartType, "Primary")					  ; entonces noy espacio para mas unidades logicas
			GUICtrlSetState($cboPartType, $GUI_DISABLE)
		ElseIf ConvertToGB($asDisks[$iDiskIndex][3]) - $ExtendedFreeSpace <= 1 Then
			GUICtrlSetData($cboPartType, "Logical")
			GUICtrlSetState($cboPartType, $GUI_DISABLE)
		Else
			GUICtrlSetData($cboPartType, "Primary|Logical")
			GUICtrlSetState($cboPartType, $GUI_ENABLE)
		EndIf
	EndIf


	GUICtrlSendMsg($cboPartType, $CB_SETCURSEL, 0, 0)
EndFunc

Func frmCreatePartition_CreatePieChart($iAllocated, $iCurrentSize, $iFreeSpace)
	Local $iTotalTests, $iPerAllocated, $iDegAllocated
	Local $iPerCurSize, $iDegCurSize, $iPerFreeSpace, $iDegFreeSpace
	Local $iColorAllocated, $iColorCurSize, $iColorFreeSpace
	Local $hgrCtrlPie, $hgrCtrlLegend

	$hgrCtrlPie = _GetCtrl("$grPartPie", $afrmCreatePartition)
	$hgrCtrlLegend = _GetCtrl("$grLegend", $afrmCreatePartition)

	;$iColorAllocated = 0x787878	; Black
	$iColorAllocated = 0xB0B4FB
	;$iColorCurSize = 0xBEBEBE		; Grey
	$iColorCurSize = 0x8F8FF5
	$iColorFreeSpace = 0xFFFFFF	; White

	;===== The following functions calculate Percentages and Degrees =====
	$iTotalTests = $iAllocated + $iCurrentSize + $iFreeSpace

	$iPerAllocated = $iAllocated / $iTotalTests
	$iDegAllocated =  $iPerAllocated * 360

	$iPerCurSize = $iCurrentSize / $iTotalTests
	$iDegCurSize =  $iPerCurSize * 360

	$iPerFreeSpace = $iFreeSpace / $iTotalTests
	$iDegFreeSpace = $iPerFreeSpace * 360
	;=====================================================================

	;=== This section will create the Pie Chart ==========================
	;Passed Pie section
	GUICtrlSetGraphic($hgrCtrlPie, $GUI_GR_COLOR, 0x000000, $iColorAllocated)
	;Set the Pie chart piece Starts at 90^ and sweeps for $iDegAllocated number of ^
	GUICtrlSetGraphic($hgrCtrlPie, $GUI_GR_PIE, 75, 70, 60, 90, $iDegAllocated)
	;Failed Pie section
	GUICtrlSetGraphic($hgrCtrlPie, $GUI_GR_COLOR, 0x000000, $iColorCurSize)
	;Set the Pie chart Piece Starts at 90^ + total ^ of $iDegAllocated
	GUICtrlSetGraphic($hgrCtrlPie, $GUI_GR_PIE, 75, 70, 60, 90 + $iDegAllocated, $iDegCurSize)
	;Warnings Pie Section
	GUICtrlSetGraphic($hgrCtrlPie, $GUI_GR_COLOR, 0x000000, $iColorFreeSpace)
	;Set the Pie Chart Piece Start at 90^ + Total ^ of $iDegAllocated and $iDegCurSize
	GUICtrlSetGraphic($hgrCtrlPie, $GUI_GR_PIE, 75, 70, 60, 90 + $iDegAllocated + $iDegCurSize, $iDegFreeSpace)

	;=== This section creates the Legend =============================

	;Allocated Legend
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_PENSIZE, 5);Makes the Dot bigger so you can see the color
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_COLOR, $iColorAllocated, $iColorAllocated)
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_DOT, 20, 20)
	;Calculates the total percentage to display
	GUICtrlSetData(_GetCtrl("$lblAllocated", $afrmCreatePartition), Round($iPerAllocated * 100, 0) & "%")

	;Current Partition Size Legend
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_PENSIZE, 5);Makes the Dot bigger so you can see the color
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_COLOR, $iColorCurSize, $iColorCurSize)
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_DOT, 20, 50)
	;Calculates the total percentage to display
	GUICtrlSetData(_GetCtrl("$lblCurrentSize", $afrmCreatePartition), Round($iPerCurSize * 100, 0) & "%")
	;Free Space Legend
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_PENSIZE, 5);Makes the Dot bigger so you can see the color
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_COLOR, $iColorFreeSpace, $iColorFreeSpace)
	GUICtrlSetGraphic($hgrCtrlLegend, $GUI_GR_DOT, 20, 80)
	;Calculates the total percentage to display
	GUICtrlSetData(_GetCtrl("$lblFreeSpace", $afrmCreatePartition), Round($iPerFreeSpace * 100, 0) & "%")

	;Refresh Graphics
	GUICtrlSetState($hgrCtrlPie, $GUI_DISABLE)
	GUICtrlSetState($hgrCtrlPie, $GUI_ENABLE)
	GUICtrlSetState($hgrCtrlLegend, $GUI_DISABLE)
	GUICtrlSetState($hgrCtrlLegend, $GUI_ENABLE)
EndFunc

Func frmExtended_Logical_Size()
	Local $PartExtendedNo

	$bExtendedPresent = False
	$AllLogicalSize = 0
	For $i = 0 to UBound($asPartitions, 1) - 1
		If $asPartitions[$i][1] = "Extended" Then
			$bExtendedPresent = True
			$PartExtendedNo = $i ; version 0.5.1
			For $i = 0 To UBound ($asPartitions,  1) - 1
				If $asPartitions[$i][1] = "Logical" Then
					$AllLogicalSize = ConvertToGB(_ConvertirGBbinToGBdecimal($asPartitions[$i][2])) + $AllLogicalSize
				EndIf
			Next
			ExitLoop
		EndIf
	Next

	If $bExtendedPresent = True Then
		$ExtendedSize = ConvertToGB(_ConvertirGBbinToGBdecimal($asPartitions[$PartExtendedNo][2]))
		$ExtendedFreeSpace = $ExtendedSize - $AllLogicalSize
;~ 	Else
;~ 		$ExtendedSize = 0
;~ 		$ExtendedFreeSpace = 0
	EndIf


EndFunc

