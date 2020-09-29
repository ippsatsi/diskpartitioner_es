#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
Func CreateForm_frmBorrarDisco(ByRef $afrmNew, $frmParent)

	Dim $afrmNew [14][2]
	$afrmNew[0][0] = "frmBorrarDisco"
	$afrmNew[0][1] = GUICreate("Borrar Disco", 384, 200, (@DesktopWidth - 100)/2, (@DesktopHeight - 274)/2, _
						BitOr($WS_CAPTION, $WS_SYSMENU, $WS_POPUP), -1, $frmParent)
	GUICtrlCreateGroup("Informacion de Disco", 8, 8, 365, 80)
	$afrmNew[2][0] = "$lblDiscoNumero"
	$afrmNew[2][1] = GUICtrlCreateLabel("Disco:",16, 25, 50, 17, $SS_LEFTNOWORDWRAP)
	$afrmNew[3][0] = "$lblPartLocation"
	$afrmNew[3][1] = GUICtrlCreateLabel("", 16, 45, 352, 17, $SS_CENTER, $WS_EX_STATICEDGE)
					GUICtrlSetFont(-1, 8.5, 600)
	$afrmNew[4][0] = "$lblPartSize"
	$afrmNew[4][1] = GUICtrlCreateLabel("Tamaño: ", 16, 70, 130, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	$afrmNew[5][0] = "$lblPartFree"
	$afrmNew[5][1] = GUICtrlCreateLabel("Espacio Libre: ", 200, 70, 130, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	Local $Warning = GUICtrlCreateLabel("ADVERTENCIA", 150, 95, 90, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	GUICtrlSetColor($Warning, $COLOR_RED)
	GUICtrlCreateLabel("¡Se eliminaran todas las particiones y los archivos contenidos en este disco!", 15, 110, 362, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)
	GUICtrlCreateLabel("La informacion borrada sera irrecuperable.  ¿ESTA SEGURO?", 15, 125, 340, 17, $SS_LEFTNOWORDWRAP);, $WS_EX_STATICEDGE)

	$afrmNew[12][0] = "$cmdOK"
	$afrmNew[12][1] = GUICtrlCreateButton("&OK", 200, 165, 75, 25)
	$afrmNew[13][0] = "$cmdCancel"
	$afrmNew[13][1] = GUICtrlCreateButton("Cancelar", 300, 165, 75, 25)
EndFunc

Func frmBorrarDisco_WndProc()
	Select
		Case $msg[0] = $GUI_EVENT_CLOSE
			GUISetState(@SW_ENABLE, $afrmDiskpart[0][1])
			GUISetState(@SW_HIDE, $afrmBorrarDisco[0][1])
		Case $msg[0] = _GetCtrl("$cmdOK", $afrmBorrarDisco)
			frmBorrarDisco_cmdOK_Click()
		Case $msg[0] = _GetCtrl("$cmdCancel", $afrmBorrarDisco)
			$msg[0] = $GUI_EVENT_CLOSE
			frmBorrarDisco_WndProc()
	EndSelect

EndFunc

Func frmBorrarDisco_Initialize()
	Local $iDiskIndex, $iPartIndex, $lvwPartitions
	Local $chkConfirmDelete, $cmdOK

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	$cmdOK = _GetCtrl("$cmdOK", $afrmBorrarDisco)
	GUICtrlSetData(_GetCtrl("$lblDiscoNumero", $afrmBorrarDisco), "Disco: " & $iDiskIndex)
	GUICtrlSetData(_GetCtrl("$lblPartLocation", $afrmBorrarDisco), $asDisks[$iDiskIndex][6])
	GUICtrlSetData(_GetCtrl("$lblPartSize", $afrmBorrarDisco),"Tamaño: " & $asDisks[$iDiskIndex][2])
	GUICtrlSetData(_GetCtrl("$lblPartFree", $afrmBorrarDisco), "Espacio libre: " & $asDisks[$iDiskIndex][3])
	frmBorrarDisco_LoadIcons()

EndFunc

Func frmBorrarDisco_LoadIcons()
	If @compiled = 1 Then
		; Do nothing
	Else
		GUISetIcon("icons\0.ico", 0, $afrmBorrarDisco[0][1])
	EndIf
EndFunc


Func frmBorrarDisco_cmdOK_Click()
	Local $stbStatus, $lvwPartitions

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$msg[0] = $GUI_EVENT_CLOSE
	frmBorrarDisco_WndProc()

	ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")
	frmDiskPart_ChangeControlState()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)
	GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)

	_BorrarDisco($sCurrentDisk, $stbStatus)

	frmSelectDisk_LoadDisks()
	frmDiskPart_LoadPartitions()

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)


;~ 	MsgBox(0, "Borrando Disco", $sCurrentDisk)
EndFunc

