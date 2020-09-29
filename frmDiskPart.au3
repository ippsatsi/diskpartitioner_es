Func CreateForm_frmDiskPart(ByRef $afrmNew)
	Local $pyInicio = 8
	Dim $afrmNew[27][2]

	$afrmNew[0][0] = "$frmDiskPart"
	$afrmNew[0][1] = GUICreate("Diskpart GUI 0.9 Beta", 408, 500);, (@DesktopWidth - 405)/2, (@DesktopHeight - 457)/2)

	Local $iAlto_Grupo1 = 116
	GUICtrlCreateGroup("Disco actual:", 8, $pyInicio, 391, $iAlto_Grupo1)
	$afrmNew[1][0] = "$icoDrive"
	$afrmNew[1][1] = GUICtrlCreateIcon ("shell32.dll", 50, 24, 32, 32, 32)
	$afrmNew[2][0] = "$lblDiskLabel"
	$afrmNew[2][1] = GUICtrlCreateLabel("", 90, $pyInicio, 250, 16, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
					GUICtrlSetFont(-1, 8.5, 600)
	Local $pyDisco_1linea = $pyInicio + 22
	GUICtrlCreateLabel("Disco: ", 100, $pyDisco_1linea, 53, 21)
	$afrmNew[3][0] = "$lblDiskNo"
	$afrmNew[3][1] = GUICtrlCreateLabel("", 136, $pyDisco_1linea, 30, 21, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[4][0] = "$lblDiskType"
	$afrmNew[4][1] = GUICtrlCreateLabel("Estado:", 198, $pyDisco_1linea, 100, 21, $SS_LEFTNOWORDWRAP)
	Local $pyDisco_2linea = $pyDisco_1linea + 21
	$afrmNew[25][0] = "$lblDiskDinamic"
	$afrmNew[25][1] = GUICtrlCreateLabel("Dinamico: ", 100, $pyDisco_2linea, 100, 21, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[26][0] = "$lblDiskGPT_UEFI"
	$afrmNew[26][1] = GUICtrlCreateLabel("UEFI: ", 198, $pyDisco_2linea, 130, 21, $SS_LEFTNOWORDWRAP)

	Local $pyDisco_3linea = $pyDisco_2linea + 22
	$afrmNew[5][0] = "$lblDiskSize"
	$afrmNew[5][1] = GUICtrlCreateLabel("Tamaño: ", 100, $pyDisco_3linea, 100, 21, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[6][0] = "$lblDiskFree"
	$afrmNew[6][1] = GUICtrlCreateLabel("Espacio Libre: ", 198, $pyDisco_3linea, 130, 21, $SS_LEFTNOWORDWRAP)

	Local $pyDiscoBotones = $pyDisco_3linea + 16
	$afrmNew[7][0] = "$cmdDiskBrowse"
	$afrmNew[7][1] = GUICtrlCreateButton("Cambiar Disco", 16, $pyDiscoBotones, 80, 27)  ; v 0.4.0.2
	$afrmNew[24][0] = "$cmdDiskClean"  ;v: 0.4.1.4
	$afrmNew[24][1] = GUICtrlCreateButton("Borrar Disco", 198,$pyDiscoBotones, 80,27) ;v: 0.4.1.4
	Local $pyParticiones = $pyInicio + $iAlto_Grupo1 + 8
	GUICtrlCreateLabel("Particiones encontradas:", 8, $pyParticiones, 200, 13)   ;version: 0.4.1.0
	GUICtrlCreateGroup("", 8, $pyParticiones + 11, 391, 201)
	$afrmNew[8][0] = "$lvwPartitions"
	$afrmNew[8][1] = GUICtrlCreateListView("Particion|Tipo|Tamaño|Espacio Libre|Sist. Archivos", 16, $pyParticiones + 26, 375, 144, _
					BitOr($LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $LVS_NOSORTHEADER)) ;version: 0.4.1.0
					GUICtrlSendMsg(-1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	Local $pyPartBttn = $pyParticiones + 178
	$afrmNew[9][0] = "$cmdAdd"
	$afrmNew[9][1] = GUICtrlCreateButton("&Añadir...", 16,  $pyPartBttn, 75, 25, $WS_DISABLED)
	$afrmNew[10][0] = "$cmdDelete"
	$afrmNew[10][1] = GUICtrlCreateButton("&Borrar", 96,  $pyPartBttn, 75, 25, $WS_DISABLED)
	$afrmNew[11][0] = "$cmdEdit"
	$afrmNew[11][1] = GUICtrlCreateButton("&Editar...", 176,  $pyPartBttn, 75, 25, $WS_DISABLED)
	$afrmNew[12][0] = "$cmdRefresh"
	$afrmNew[12][1] = GUICtrlCreateButton("Actualiza&r", 256,  $pyPartBttn, 75, 25)
	Local $pyDtPart =  220 + $pyParticiones ;330
	GUICtrlCreateLabel("Datos de Particion:", 8, $pyDtPart, 100, 13)
	GUICtrlCreateGroup("", 8, $pyDtPart + 11, 391, 101)
	Local $pyDtPart_1linea = $pyDtPart + 25
	Local $pyDtPart_2linea = $pyDtPart + 49
	GUICtrlCreateLabel("Volumen #:", 16, $pyDtPart_1linea, 60, 13);, -1, $WS_EX_STATICEDGE)
	$afrmNew[13][0] = "$lblVolNo"
	$afrmNew[13][1] = GUICtrlCreateLabel("", 77, $pyDtPart_1linea, 65, 13, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	GUICtrlCreateLabel("Offset:", 16, $pyDtPart_2linea, 60, 13);, -1, $WS_EX_STATICEDGE)
	$afrmNew[14][0] = "$lblOffset"
	$afrmNew[14][1] = GUICtrlCreateLabel("", 77, $pyDtPart_2linea, 65, 13, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	GUICtrlCreateLabel("Oculto:", 143, $pyDtPart_1linea, 45, 13);, -1, $WS_EX_STATICEDGE)
	$afrmNew[15][0] = "$lblHidden"
	$afrmNew[15][1] = GUICtrlCreateLabel("", 189, $pyDtPart_1linea, 65, 13, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	GUICtrlCreateLabel("Activo:", 143, $pyDtPart_2linea, 45, 13);, -1, $WS_EX_STATICEDGE)
	$afrmNew[16][0] = "$lblActive"
	$afrmNew[16][1] = GUICtrlCreateLabel("", 189, $pyDtPart_2linea, 65, 13, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	GUICtrlCreateLabel("Estado:", 256, $pyDtPart_1linea, 40, 13);, -1, $WS_EX_STATICEDGE)
	$afrmNew[17][0] = "$lblStatus"
	$afrmNew[17][1] = GUICtrlCreateLabel("", 297, $pyDtPart_1linea, 85, 13, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	GUICtrlCreateLabel("Info:", 256, $pyDtPart_2linea, 40, 13);, -1, $WS_EX_STATICEDGE)
	$afrmNew[18][0] = "$lblInfo"
	$afrmNew[18][1] = GUICtrlCreateLabel("", 297, $pyDtPart_2linea, 85, 13, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	Local $pyDtPart_botones = $pyDtPart + 78
	$afrmNew[19][0] = "$cmdFormat"
	$afrmNew[19][1] = GUICtrlCreateButton("&Formatear...", 16, $pyDtPart_botones, 75, 25, $WS_DISABLED)
	$afrmNew[20][0] = "$cmdCheck"
	$afrmNew[20][1] = GUICtrlCreateButton("&Check...", 96, $pyDtPart_botones, 75, 25, $WS_DISABLED)
	$afrmNew[21][0] = "$cmdDefrag"
	$afrmNew[21][1] = GUICtrlCreateButton("Boot...", 176, $pyDtPart_botones, 75, 25, $WS_DISABLED)
	$afrmNew[22][0] = "$cmdProperties"
	$afrmNew[22][1] = GUICtrlCreateButton("&Propiedades...", 256, $pyDtPart_botones, 75, 25, $WS_DISABLED)
	$afrmNew[23][0] = "$stbStatus"
	$afrmNew[23][1] = GUICtrlCreateLabel("", 4, $pyDtPart_botones + 45, 400, 18, -1, $WS_EX_STATICEDGE)
EndFunc

Func frmDiskPart_Initialize()

	frmDiskPart_LoadIcons()
	frmDiskPart_ChangeControlState()
EndFunc

Func frmDiskPart_WndProc()

	frmDiskPart_ChangeControlState()

	Select

	Case $msg[0] = $GUI_EVENT_CLOSE
		DiskPartitioner_WndProc()	; Send end application message if main window closed
	Case $msg[0] = _GetCtrl("$cmdDiskBrowse", $afrmDiskPart)
		frmSelectDisk_Initialize()
		GUISetState(@SW_DISABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_SHOW, $afrmSelectDisk[0][1])
	Case $msg[0] = _GetCtrl("$cmdAdd", $afrmDiskPart)
		frmDiskPart_cmdAdd_Click()
	Case $msg[0] = _GetCtrl("$cmdDelete", $afrmDiskPart)
		frmDiskPart_cmdDelete_Click()
	Case $msg[0] = _GetCtrl("$cmdEdit", $afrmDiskPart)
		frmEditPartition_Initialize()
		GUISetState(@SW_DISABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_SHOW, $afrmEditPartition[0][1])
	Case $msg[0] = _GetCtrl("$cmdRefresh", $afrmDiskPart)
		frmDiskPart_cmdRefresh_Click()
	Case $msg[0] = _GetCtrl("$cmdFormat", $afrmDiskPart)
		frmDiskPart_cmdFormat_Click()
	Case $msg[0] = _GetCtrl("$cmdCheck", $afrmDiskPart)
		frmDiskPart_cmdCheck_Click()
	Case $msg[0] = _GetCtrl("$cmdDefrag", $afrmDiskPart)
		frmDiskPart_cmdBootSector_Click()
	Case $msg[0] = _GetCtrl("$cmdProperties", $afrmDiskPart)
		frmDiskPart_cmdProperties_Click()
	Case $msg[0] = _GetCtrl("$cmdDiskClean", $afrmDiskPart)
		frmDiskPart_cmdBorrarDisco_Click()

	EndSelect
EndFunc

Func frmDiskPart_ChangeControlState()
	Local $lvwPartitions, $iSelPart

	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iSelPart = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")

	If  $iSelPart = "" Then
		GUICtrlSetState(_GetCtrl("$cmdDelete", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdEdit", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdFormat", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdCheck", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdDefrag", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdProperties", $afrmDiskPart), $GUI_DISABLE)
	ElseIf ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetText", $iSelPart, 1) = "Extended" Then
		GUICtrlSetState(_GetCtrl("$cmdDelete", $afrmDiskPart), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$cmdEdit", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdFormat", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdCheck", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdDefrag", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdProperties", $afrmDiskPart), $GUI_DISABLE)
	Else
		GUICtrlSetState(_GetCtrl("$cmdDelete", $afrmDiskPart), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$cmdEdit", $afrmDiskPart), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$cmdFormat", $afrmDiskPart), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$cmdCheck", $afrmDiskPart), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$cmdDefrag", $afrmDiskPart), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$cmdProperties", $afrmDiskPart), $GUI_ENABLE)
	EndIf

	If $iSelPart = "" Then
		GUICtrlSetData(_GetCtrl("$lblVolNo", $afrmDiskPart), "")
		GUICtrlSetData(_GetCtrl("$lblOffset", $afrmDiskPart), "")
		GUICtrlSetData(_GetCtrl("$lblHidden", $afrmDiskPart), "")
		GUICtrlSetData(_GetCtrl("$lblActive", $afrmDiskPart), "")
		GUICtrlSetData(_GetCtrl("$lblStatus", $afrmDiskPart), "")
		GUICtrlSetData(_GetCtrl("$lblInfo", $afrmDiskPart), "")
	Else
		GUICtrlSetData(_GetCtrl("$lblVolNo", $afrmDiskPart), StringMid($asPartitions[$iSelPart][4], 8))
		GUICtrlSetData(_GetCtrl("$lblOffset", $afrmDiskPart), $asPartitions[$iSelPart][3])
		GUICtrlSetData(_GetCtrl("$lblHidden", $afrmDiskPart), $asPartitions[$iSelPart][12])
		GUICtrlSetData(_GetCtrl("$lblActive", $afrmDiskPart), $asPartitions[$iSelPart][13])
		GUICtrlSetData(_GetCtrl("$lblStatus", $afrmDiskPart), $asPartitions[$iSelPart][10])
		GUICtrlSetData(_GetCtrl("$lblInfo", $afrmDiskPart), $asPartitions[$iSelPart][11])
	EndIf
EndFunc

Func frmDiskPart_LoadIcons()
	If @compiled = 1 Then
		GUICtrlSetImage(_GetCtrl("$icoDrive", $afrmDiskPart), @ScriptFullPath, 0)
		GUICtrlSetImage(_GetCtrl("$lvwPartitions", $afrmDiskPart), @ScriptFullPath, 1)
	Else
		GUISetIcon("icons\0.ico", 0, $afrmDiskPart[0][1])
		GUICtrlSetImage(_GetCtrl("$icoDrive", $afrmDiskPart), "icons\0.ico", 0)
		GUICtrlSetImage(_GetCtrl("$lvwPartitions", $afrmDiskPart), "icons\1.ico", 0)
;~ 		GUICtrlSetImage(_GetCtrl("$lvwPartitions", $afrmDiskPart), "shell32.dll", 16)

	EndIf
EndFunc

Func frmDiskPart_cmdBorrarDisco_Click()
	Local $iDiskIndex

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

		frmBorrarDisco_Initialize()
		GUISetState(@SW_DISABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_SHOW, $afrmBorrarDisco[0][1])


EndFunc

Func frmDiskPart_cmdAdd_Click()
	Local $iDiskIndex

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next
;~ MsgBox(0,"error", "error")
	If _ConvertToMB($asDisks[$iDiskIndex][3]) = 0 Then
		DiskPartitioner_ErrorHandler("No hay espacio disponble en este disco.", "", "Non-Fatal")
	ElseIf  $asPartitions = 0 Then
		frmNuevoDisco_Initialize()
		GUISetState(@SW_DISABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_SHOW, $afrmNuevoDisco[0][1])
	Else

		frmCreatePartition_Initialize()
		GUISetState(@SW_DISABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_SHOW, $afrmCreatePartition[0][1])
	EndIf
EndFunc

Func frmDiskPart_cmdDelete_Click()
	Local $iPartIndex, $bLogicalPresent
	Local $lvwPartitions, $stbStatus

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")

	If $asPartitions[$iPartIndex][1] = "Extended" Then
		$bLogicalPresent = False
		For $i = 0 to UBound($asPartitions, 1) - 1
			If $asPartitions[$i][1] = "Logical" Then
				$bLogicalPresent = True
				ExitLoop
			EndIf
		Next

		If $bLogicalPresent Then
			DiskPartitioner_ErrorHandler("No puede borrar particiones extendidas cuando existen particiones lógicas.", _
										"Borre las particiones lógicas antes de borrar la partición extendida.", "Non-Fatal")
		Else
			; Delete extended without prompting when logical drives are not present
			ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
			frmDiskPart_ChangeControlState()

			GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
			GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)

			_DeletePartition($sCurrentDisk, $asPartitions[$iPartIndex][0], True, $stbStatus)

			frmSelectDisk_LoadDisks()
			frmDiskPart_LoadPartitions()

			GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)
		EndIf
	Else
		frmDeletePartition_Initialize()
		GUISetState(@SW_DISABLE, $afrmDiskPart[0][1])
		GUISetState(@SW_SHOW, $afrmDeletePartition[0][1])
	EndIf
EndFunc

Func frmDiskPart_cmdRefresh_Click()
	Local $lvwPartitions, $stbStatus

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)

	ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
	frmDiskPart_ChangeControlState()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
	GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)

	_RefreshDiskPartInfo($sCurrentDisk, $stbStatus)
	frmSelectDisk_LoadDisks()
	frmDiskPart_LoadPartitions()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)
EndFunc

Func frmDiskPart_cmdFormat_Click()
	Local $GuiFormat

	frmFormat_Initialize()
	GUISetState(@SW_DISABLE, $afrmDiskPart[0][1])
	GUISetState(@SW_SHOW, $afrmFormat[0][1])

EndFunc

Func frmDiskPart_cmdBootSector_Click()
	Local $GuiFormat

	frmBootSector_Initialize()
	GUISetState(@SW_DISABLE, $afrmDiskPart[0][1])
	GUISetState(@SW_SHOW, $afrmBootSector[0][1])

EndFunc

;~ Func frmDiskPart_cmdFormat_Click()
;~ 	Local $SHFD_CAPACITY_DEFAULT = 0
;~ 	Local $SHMT_FORMAT_QUICK = 1  ;Quick format
;~ 	Local $SHMT_FORMAT_FULL = 0  ;Full format
;~ 	Local $iLetter, $sDriveLetter, $iPartIndex, $lvwPartitions

;~ 	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
;~ 	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
;~ 	If $iPartIndex <> "" Then
;~ 		$sDriveLetter = $asPartitions[$iPartIndex][5]
;~ 		If $sDriveLetter = "" Then
;~ 			DiskPartitioner_ErrorHandler("No drive letter assigned.", "A drive letter must be assigned to format the selected partition.", "Non-Fatal")
;~ 			SetError(1)
;~ 			Return
;~ 		Else
;~ 			$iLetter = Asc($sDriveLetter) - 65
;~ 			DllCall("shell32.dll", "long", "SHFormatDrive", "hwnd", $afrmDiskPart[0][1], "int", $iLetter, _
;~ 				"int", $SHFD_CAPACITY_DEFAULT, "int", $SHMT_FORMAT_QUICK)
;~ 		EndIf
;~ 	EndIf
;~ EndFunc

Func frmDiskPart_cmdCheck_Click()
	Local $sDriveLetter, $sDriveLabel, $iPartIndex, $lvwPartitions

	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	If $iPartIndex <> "" Then
		$sDriveLetter = $asPartitions[$iPartIndex][5]
		If $sDriveLetter = "" Then
			DiskPartitioner_ErrorHandler("No tiene una letra de unidad asignada.", "Debe asignarle una letra de unidad para poder revisar el sistema de archivos.", "Non-Fatal")
			SetError(1)
			Return
		Else
;~ 			MsgBox(0,"run","chkdsk /f " & $sDriveLetter & ":" & " & pause")
			 Run(@ComSpec & " /c " & "chkdsk /f " & $sDriveLetter & ":" & " & pause", "", @SW_MAXIMIZE)
		EndIf
	EndIf

;~ 			$sDriveLabel = $asPartitions[$iPartIndex][6]
;~ 			If $sDriveLabel = "" Then $sDriveLabel = "Local Disk"
;~ 			DllCall("shell32.dll", "int", "SHObjectProperties", "hwnd", $afrmDiskPart[0][1], "int", 2, "wstr", $sDriveLetter & ":\", "wstr", "Tools")
;~ 			If WinWaitActive($sDriveLabel & " (" & $sDriveLetter & ":) Properties", "", 5) = 1 Then
;~ 				WinSetState ($sDriveLabel & " (" & $sDriveLetter & ":) Properties", "", @SW_HIDE)
;~ 				ControlClick ($sDriveLabel & " (" & $sDriveLetter & ":) Properties", "", "Button2")
;~ 			EndIf
;~ 			; Putting the $GUI_EVENT_CLOSE for the drive properties window closes it immediately after the check disk window exits.
;~ 			WinClose($sDriveLabel & " (" & $sDriveLetter & ":) Properties")
;~ 		EndIf
;~ 	EndIf
EndFunc

Func frmDiskPart_cmdDefrag_Click()
	Local $sDriveLetter, $iPartIndex, $lvwPartitions

	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	If $iPartIndex <> "" Then
		$sDriveLetter = $asPartitions[$iPartIndex][5]
		If $sDriveLetter = "" Then
			DiskPartitioner_ErrorHandler("No drive letter assigned.", "A drive letter must be assigned to defragment the selected partition.", "Non-Fatal")
			Return
		ElseIf FileExists(@SystemDir & "\MMC.exe") And FileExists(@SystemDir & "\dfrg.msc") Then
			DllCall("shell32.dll", "long", "ShellExecute", "hwnd", $afrmDiskPart[0][1], "str", "", _
					"str", @SystemDir & "\dfrg.msc", "str", $sDriveLetter & ":", "str", @SystemDir, "long", @SW_SHOWNORMAL)
		EndIf
	EndIf
EndFunc

Func frmDiskPart_cmdProperties_Click()
	Local $sDriveLetter, $iPartIndex, $lvwPartitions

	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
	$iPartIndex = ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "GetSelected")
	If $iPartIndex <> "" Then
		$sDriveLetter = $asPartitions[$iPartIndex][5]
		If $sDriveLetter = "" Then
			DiskPartitioner_ErrorHandler("No tiene una letra de unidad asignada.", "Una letra de unidad deberá ser asignada para visualizar las propiedades de la partición.", "Non-Fatal")
			Return
		Else
			DllCall("shell32.dll", "int", "SHObjectProperties", "hwnd", $afrmDiskPart[0][1], "int", 2, "wstr", $sDriveLetter & ":\", "wstr", "")
		EndIf
	EndIf
EndFunc

Func frmDiskPart_LoadPartitions()
	Local $lvwPartitions, $sPartName, $sDriveFreeSpace, $Fila

	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)

	GUICtrlSendMsg($lvwPartitions, $LVM_DELETEALLITEMS, 0, 0)	; Delete all Items

	If $asDisks = 0 Then
		GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)
		GUICtrlSetState(_GetCtrl("$cmdDiskClean", $afrmDiskPart), $GUI_DISABLE)  ; version: 0.4.1.5
		GUICtrlSetData(_GetCtrl("$lblDiskLabel", $afrmDiskPart), "(NO HAY DISCOS)");version: 0.4.0.3
		GUICtrlSetData(_GetCtrl("$lblDiskNo", $afrmDiskPart), "")
		GUICtrlSetData(_GetCtrl("$lblDiskType", $afrmDiskPart), "Tipo: ") ; version: 0.4.0.3
		GUICtrlSetData(_GetCtrl("$lblDiskSize", $afrmDiskPart), "Tamaño: ");version: 0.4.0.3
		GUICtrlSetData(_GetCtrl("$lblDiskFree", $afrmDiskPart), "Espacio libre: "); version: 0.4.1.2
	Else
		GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_ENABLE)
		GUICtrlSetState(_GetCtrl("$cmdDiskClean", $afrmDiskPart), $GUI_ENABLE)  ; version: 0.4.1.5
		For $i = 0 to Ubound($asDisks, 1) - 1
			If $asDisks[$i][0] = $sCurrentDisk Then
				GUICtrlSetData(_GetCtrl("$lblDiskLabel", $afrmDiskPart), $asDisks[$i][6])
				GUICtrlSetData(_GetCtrl("$lblDiskNo", $afrmDiskPart), StringMid($asDisks[$i][0], 5))
				GUICtrlSetData(_GetCtrl("$lblDiskType", $afrmDiskPart), "Tipo: " & $asDisks[$i][8])
				GUICtrlSetData(_GetCtrl("$lblDiskSize", $afrmDiskPart), "Tamaño: " & $asDisks[$i][2])
				GUICtrlSetData(_GetCtrl("$lblDiskFree", $afrmDiskPart), "Espacio libre: " & $asDisks[$i][3])

				ExitLoop
			EndIf
		Next

		; Populate $lvwPartitions
		For $i = 0 to UBound($asPartitions, 1) - 1
			$sPartName = ""
			$sDriveFreeSpace = ""
			If $asPartitions[$i][5] <> "" Then
				$sPartName = $asPartitions[$i][6] & ' (' & $asPartitions[$i][5] & ":)"
				If DriveStatus($asPartitions[$i][5] & ":") <> "DESCONOCIDO" Then	; check whether drive is formatted
					$sDriveFreeSpace = Int(DriveSpaceFree($asPartitions[$i][5] & ":")) & " MB"
				EndIf
			Else
				$sPartName = $asPartitions[$i][6]
			EndIf

			If $sPartName = "" Then $sPartName = " "	; Shows junk value in first listviewitem if empty

			$Fila = GUICtrlCreateListViewItem($sPartName & '|' & $asPartitions[$i][1] & '|' & _ConvertirGBbinToGBdecimal($asPartitions[$i][2]) & _
									 '|' & $sDriveFreeSpace & '|' & $asPartitions[$i][7], $lvwPartitions)
			If StringInStr($asPartitions[$i][13], "Si") Then
				GUICtrlSetImage($Fila, "shell32.dll", 16)
			Else
				GUICtrlSetImage($Fila, "shell32.dll", 9)
			EndIf

		Next
	EndIf

	_GUICtrlListView_SetColumnWidth($lvwPartitions, 0, 75)

	frmDiskPart_ChangeControlState()
EndFunc