#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
Func CreateForm_frmNuevoDisco(ByRef $afrmNew, $frmParent)

	Dim $afrmNew[23][2]
	$afrmNew[0][0] = "frmNuevoDisco"
	$afrmNew[0][1] = GUICreate("Crear Particones", 438, 311, (@DesktopWidth - 100)/2, (@DesktopHeight - 274)/2, _
						BitOr($WS_CAPTION, $WS_SYSMENU, $WS_POPUP), -1, $frmParent)
	$afrmNew[1][0] = "$lblTamañoDeDisco"
	$afrmNew[1][1] = GUICtrlCreateLabel("Dividir el Disco de ", 40, 56, 152, 17)
	$afrmNew[2][0] = "$nNumeroDeParticiones"
	$afrmNew[2][1] = GUICtrlCreateInput("", 200, 52, 40, 21, BitOR($ES_NUMBER, $ES_READONLY, $ES_NOHIDESEL))
	$afrmNew[3][0] = "$upNumeroDeParticiones"
	$afrmNew[3][1] = GUICtrlCreateUpdown(_GetCtrl("$nNumeroDeParticiones", $afrmNew),$UDS_NOTHOUSANDS)
	GUICtrlCreateLabel("Particiones", 250, 56, 56, 17)
	GUICtrlCreateLabel("* Máximo 4 particiones, si desea crear más, haga clic en Manual", 32, 88, 319, 17)

	$afrmNew[4][0] = "$nParticion1"
	$afrmNew[4][1] = GUICtrlCreateInput("Input2", 30, 192, 57, 21,$ES_NUMBER )
	$afrmNew[5][0] = "$upParticion1"
	$afrmNew[5][1] = GUICtrlCreateUpdown(_GetCtrl("$nParticion1", $afrmNew),$UDS_NOTHOUSANDS)
	$afrmNew[6][0] = "sGB1"
	$afrmNew[6][1] = GUICtrlCreateLabel("GB", 90, 198, 35, 17)
	$afrmNew[7][0] = "$nParticion2"
	$afrmNew[7][1] = GUICtrlCreateInput("Input3", 126, 192, 57, 21, $ES_NUMBER)
	$afrmNew[8][0] = "$upParticion2"
	$afrmNew[8][1] = GUICtrlCreateUpdown(_GetCtrl("$nParticion2", $afrmNew),$UDS_NOTHOUSANDS)
	$afrmNew[9][0] = "sGB2"
	$afrmNew[9][1] = GUICtrlCreateLabel("GB", 186, 198, 35, 17)
	$afrmNew[10][0] = "$nParticion3"
	$afrmNew[10][1] = GUICtrlCreateInput("Input4", 228, 192, 57, 21, $ES_NUMBER)
	$afrmNew[11][0] = "$upParticion3"
	$afrmNew[11][1] = GUICtrlCreateUpdown(_GetCtrl("$nParticion3", $afrmNew),$UDS_NOTHOUSANDS)
	$afrmNew[12][0] = "sGB3"
	$afrmNew[12][1] = GUICtrlCreateLabel("GB", 288, 198, 35, 17)
	$afrmNew[13][0] = "$nParticion4"
	$afrmNew[13][1] = GUICtrlCreateInput("Input5", 322, 192, 57, 21, $ES_NUMBER)
	$afrmNew[14][0] = "$upParticion4"
	$afrmNew[14][1] = GUICtrlCreateUpdown(_GetCtrl("$nParticion4", $afrmNew),$UDS_NOTHOUSANDS)
	$afrmNew[15][0] = "sGB4"
	$afrmNew[15][1] = GUICtrlCreateLabel("GB", 382, 198, 35, 17)
	$afrmNew[16][0] = "lPart1"
	$afrmNew[16][1] = GUICtrlCreateLabel("Partición 1", 30, 160, 54, 17)
	$afrmNew[17][0] = "lPart2"
	$afrmNew[17][1] = GUICtrlCreateLabel("Partición 2", 126, 160, 54, 17)
	$afrmNew[18][0] = "lPart3"
	$afrmNew[18][1] = GUICtrlCreateLabel("Partición 3", 230, 160, 54, 17)
	$afrmNew[19][0] = "lPart4"
	$afrmNew[19][1] = GUICtrlCreateLabel("Partición 4", 326, 160, 52, 17)
	$afrmNew[20][0] = "$cmdManual"
	$afrmNew[20][1] = GUICtrlCreateButton("Manual", 40, 256, 75, 25)
	$afrmNew[21][0] = "$cmdOK"
	$afrmNew[21][1] = GUICtrlCreateButton("OK", 176, 256, 75, 25)
	$afrmNew[22][0] = "$cmdCancel"
	$afrmNew[22][1] = GUICtrlCreateButton("Cancelar", 312, 256, 75, 25)
	GUICtrlCreateGroup("Número de Particiones", 16, 16, 401, 97)
	GUICtrlCreateGroup("Crear las Particiones en NTFS", 16, 128, 401, 105)

EndFunc

Func frmNuevoDisco_Initialize()
	Local $iDiskIndex, $iPartIndex, $lvwPartitions
	Local $chkConfirmDelete, $cmdOK

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	_GUICtrlUpdownSetRange32(_GetCtrl("$upNumeroDeParticiones", $afrmNuevoDisco), 1, 4)
	GUICtrlSetData(_GetCtrl("$nNumeroDeParticiones", $afrmNuevoDisco), 2)
	GUICtrlSetData(_GetCtrl("$lblTamañoDeDisco", $afrmNuevoDisco),"Dividir el Disco de " & $asDisks[$iDiskIndex][2] & " en")
	frmNuevoDisco_NumeroDeParticiones()
	frmNuevoDisco_LoadIcons()

EndFunc

Func frmNuevoDisco_LoadIcons()
	If @compiled = 1 Then
		; Do nothing
	Else
		GUISetIcon("icons\0.ico", 0, $afrmNuevoDisco[0][1])
	EndIf
EndFunc

Func frmNuevoDisco_WndProc()
	Select
		Case $msg[0] = $GUI_EVENT_CLOSE
			GUISetState(@SW_ENABLE, $afrmDiskpart[0][1])
			GUISetState(@SW_HIDE, $afrmNuevoDisco[0][1])
		Case $msg[0] = _GetCtrl("$nNumeroDeParticiones", $afrmNuevoDisco)
			frmNuevoDisco_NumeroDeParticiones()
		Case $msg[0] = _GetCtrl("$nParticion1", $afrmNuevoDisco)
			frmNuevoDisco_InputPartitions(1)
		Case $msg[0] = _GetCtrl("$nParticion2", $afrmNuevoDisco)
			frmNuevoDisco_InputPartitions(2)
		Case $msg[0] = _GetCtrl("$nParticion3", $afrmNuevoDisco)
			frmNuevoDisco_InputPartitions(3)
		Case $msg[0] = _GetCtrl("$nParticion4", $afrmNuevoDisco)
			frmNuevoDisco_InputPartitions(4)
		Case $msg[0] = _GetCtrl("$cmdOK", $afrmNuevoDisco)
			frmNuevoDisco_cmdOK_Click()
		Case $msg[0] = _GetCtrl("$cmdCancel", $afrmNuevoDisco)
			$msg[0] = $GUI_EVENT_CLOSE
			frmNuevoDisco_WndProc()
		Case $msg[0] = _GetCtrl("$cmdManual", $afrmNuevoDisco)
			frmCreatePartition_Initialize()
			GUISetState(@SW_SHOW, $afrmCreatePartition[0][1])
			GUISetState(@SW_HIDE, $afrmNuevoDisco[0][1])
	EndSelect
EndFunc

Func frmNuevoDisco_cmdOK_Click()
	Local $bPartToActive, $iDiskIndex
	Local $lvwPartitions, $stbStatus
	Local $Sistema_Selected
	Local $sPartType, $sDriveLetter, $bContinueToFormat
	Local $NoParticiones, $sCtrlInputParticion, $ValorParticion, $i

	$stbStatus = _GetCtrl("$stbStatus", $afrmDiskPart)
	$lvwPartitions = _GetCtrl("$lvwPartitions", $afrmDiskPart)
;	If $asPartitions = 0 Then $bPartToActive = True
	$NoParticiones = GUICtrlRead(_GetCtrl("$nNumeroDeParticiones", $afrmNuevoDisco))

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	$sPartType = "NTFS"																	; sist. de archivos NTFS
	$sDriveLetter = -1																	;asigne letras de forma automatica
	$bContinueToFormat = True															;todas las particiones seran formateadas

	$msg[0] = $GUI_EVENT_CLOSE													;mandamos cerrar la ventana
	frmNuevoDisco_WndProc()														;
																				;
	ControlListView($afrmDiskPart[0][1], "", $lvwPartitions, "SelectClear")		;y activamos la ventana padre
	frmDiskPart_ChangeControlState()											;

	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_DISABLE)		;codigo generico mientras se ejecuta algun
	GUICtrlSetState(_GetCtrl("$cmdAdd", $afrmDiskPart), $GUI_DISABLE)			;comando con Diskpart
	$hTransferirProceso = 0
;codigo aqui
	For $i = 1 To $NoParticiones
		$sCtrlInputParticion = "$nParticion" & $i
		$ValorParticion =  GUICtrlRead(_GetCtrl($sCtrlInputParticion, $afrmNuevoDisco))
		If $i = 1 Then												;la primera particion la activamos
			$bPartToActive = True
		Else
			$bPartToActive = False
		EndIf
		If $i = $NoParticiones Then $ValorParticion = -1			; la ultima particion,la creamos con lo q resta y cerramos el proceso Diskpart
		_CreatePartition($sCurrentDisk, "Primary", $ValorParticion, $sDriveLetter, $stbStatus, $bContinueToFormat)
		_FormatPartition($sCurrentDisk, -1, $sPartType, $bPartToActive, $stbStatus, $ValorParticion)
	Next
	;
	frmSelectDisk_LoadDisks()													;codigo generico
	frmDiskPart_LoadPartitions()												;despues de ejecutar una operacion con
																				;diskpart
	GUICtrlSetState(_GetCtrl("$cmdRefresh", $afrmDiskPart), $GUI_ENABLE)		;

EndFunc

Func frmNuevoDisco_InputPartitions($NoParticionModificada)
	Local $iDiskIndex
	Local $NoParticiones, $sCtrlInputParticion,  $i, $EspacioLibre, $ValorParticion, $MaximoTamanoParticion
	Local $k, $TamanoCadaParticion, $j

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	$NoParticiones = GUICtrlRead(_GetCtrl("$nNumeroDeParticiones", $afrmNuevoDisco))
	$EspacioLibre = $asDisks[$iDiskIndex][2]
	For $i=1 To $NoParticiones												; leemos todos las particiones ingresadas desde la particion 1
		$sCtrlInputParticion = "$nParticion" & $i
		$ValorParticion =  GUICtrlRead(_GetCtrl($sCtrlInputParticion, $afrmNuevoDisco))
		$MaximoTamanoParticion = $EspacioLibre - ($NoParticiones - $i)		; calculamos el maximo tamaño q puede ser ingresado en este control "input"
		If $NoParticionModificada = $i Then											; buscamos cual es la particion q el usuario modifico
			If $ValorParticion > $MaximoTamanoParticion Or $ValorParticion < 1 Then		; si hay error se coloca un valor por defecto, q seria el espacio restante
				MsgBox (0, "error", "Tamaño de particion fuera de rango. Tiene que estar entre 1Gb hasta " & $MaximoTamanoParticion & "Gb") ; entre el numero de particiones q faltan asignar valor
				$ValorParticion = Int($EspacioLibre / ($NoParticiones - ($i - 1) ))              ; si $i = 1 se divide /4, $i=2 -> /3, si son 4 particiones
				GUICtrlSetData(_GetCtrl($sCtrlInputParticion, $afrmNuevoDisco), $ValorParticion)
			EndIf																					;una vez q encontramos cual particion el usuario modifico
			$EspacioLibre = $EspacioLibre - $ValorParticion											; empezamos a modificar el resto de particiones
			$TamanoCadaParticion = Int($EspacioLibre / ($NoParticiones - $i))						;
			For $k = $i + 1 To $NoParticiones														; una vez q llegamos al control en el cual el usuario
				If $k = $NoParticiones Then															;hizo el ingreso de una cantidad, dividimos en partes iguales
					$ValorParticion = $EspacioLibre													;el resto del espacio por particionar y rellenamos
				Else																				;los siguientes controles con el mismo tamaño de particion
					$ValorParticion = $TamanoCadaParticion											;
					$EspacioLibre = $EspacioLibre - $ValorParticion									;en $ValorParticion = $EspacioLibre nos aseguramos
				EndIf																				;q la ultima particion se llene con la cantidad q sobre despues
				$sCtrlInputParticion = "$nParticion" & $k											;de rellenar las anteriores particiones
				GUICtrlSetData(_GetCtrl($sCtrlInputParticion, $afrmNuevoDisco), $ValorParticion)	;
			Next
		EndIf
		$EspacioLibre = $EspacioLibre - $ValorParticion									;Vamos calculando el espacio restante a medida q leemos cada particion
	Next
	If $NoParticiones - $NoParticionModificada > 1 Then										;Codigo para activar (colocar el cursor y seleccionar todo el texto)
		$NoParticionModificada += 1															;el siguiente control "input" despues de ingresar
		$sCtrlInputParticion = "$nParticion" & $NoParticionModificada						;alguna cantidad en el anterior control y presionar enter
		GUICtrlSetState(_GetCtrl($sCtrlInputParticion, $afrmNuevoDisco), $GUI_FOCUS)		;
		_GUICtrlEdit_SetSel(_GetCtrl($sCtrlInputParticion, $afrmNuevoDisco), 0, -1)			;verificamos de no activar el ultimo control q normalmente esta DISABLE
	EndIf
EndFunc

Func frmNuevoDisco_NumeroDeParticiones()
	Local $CantidadDeParticiones
	Local $StateOfControl, $sCtrlInputParticion, $NoParticiones, $ValorParticion, $TamanoCadaParticion, $StyleOfControl
	Local $iDiskIndex
	Local $EspacioUsado = 0
	Local $sLabelGB, $sLabelPart, $StateOfControlLabelParticion, $sCtrlUp, $EspacioRestante_Limite

	For $i = 0 to Ubound($asDisks, 1) - 1
		If $asDisks[$i][0] = $sCurrentDisk Then
			$iDiskIndex = $i
			ExitLoop
		EndIf
	Next

	$CantidadDeParticiones = GUICtrlRead(_GetCtrl("$nNumeroDeParticiones", $afrmNuevoDisco))
	If $CantidadDeParticiones > 4 Or $CantidadDeParticiones < 1 Then
		DiskPartitioner_ErrorHandler("Cantidad de particiones fuera de limites", _
									"Especifique un numero de particiones entre 1 a 4 particiones", "Non-Fatal")
		$CantidadDeParticiones = 2
		GUICtrlSetData(_GetCtrl("$nNumeroDeParticiones", $afrmNuevoDisco), 2)
	EndIf


	$TamanoCadaParticion = Int ($asDisks[$iDiskIndex][2] / $CantidadDeParticiones)
	$NoParticiones = $CantidadDeParticiones
	$StateOfControl = BitOR($GUI_ENABLE, $GUI_SHOW)
	$StateOfControlLabelParticion = BitOR($GUI_ENABLE, $GUI_SHOW)
	For $i=1 To 4
		If $NoParticiones < 1 Then
			$StateOfControl = $GUI_HIDE
			$ValorParticion = 0
			$StateOfControlLabelParticion = $GUI_HIDE
		ElseIf $NoParticiones = 1 Then
			$ValorParticion = $asDisks[$iDiskIndex][2] - $EspacioUsado
			$StateOfControl = BitOR($GUI_DISABLE, $GUI_SHOW)
		Else
			$ValorParticion = $TamanoCadaParticion
			$EspacioUsado = $TamanoCadaParticion + $EspacioUsado
		EndIf
		$sCtrlInputParticion = "$nParticion" & $i
		$sLabelGB = "sGB" & $i
		$sLabelPart = "lPart" & $i
		$sCtrlUp = "$upParticion" & $i
		GUICtrlSetState(_GetCtrl($sCtrlInputParticion, $afrmNuevoDisco),$StateOfControl)
		GUICtrlSetData(_GetCtrl($sCtrlInputParticion, $afrmNuevoDisco), $ValorParticion)
		GUICtrlSetState(_GetCtrl($sLabelGB, $afrmNuevoDisco),$StateOfControlLabelParticion)
		GUICtrlSetState(_GetCtrl($sLabelPart, $afrmNuevoDisco),$StateOfControlLabelParticion)
		GUICtrlSetState(_GetCtrl($sCtrlUp, $afrmNuevoDisco),$StateOfControlLabelParticion)
		$NoParticiones -= 1
	Next

EndFunc

Func frmNuevoDisco_EnableInputParticiones($NoParticiones)

EndFunc
