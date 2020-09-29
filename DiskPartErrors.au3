Global $asDiskPartErrors[10]
$asDiskPartErrors[0] = "The arguments you specified for this command are not valid."
$asDiskPartErrors[1] = "The disk management services could not complete the operation."
$asDiskPartErrors[2] = "There is no volume specified." & @LF & "Please select a volume and try again."
$asDiskPartErrors[3] = "The disk you specified is not valid." & @LF & "There is no disk selected."
$asDiskPartErrors[4] = "The specified partition is not valid." & @LF & "Please select a valid partition."
$asDiskPartErrors[5] = "DiskPart was unable to create the specified partition."
$asDiskPartErrors[6] = "The selected partition may be neccessary to the operation of your computer, and may not be deleted."
$asDiskPartErrors[7] = "DiskPart assigned the drive letter, but your computer needs to be rebooted" & @LF & "before the changes take effect."
$asDiskPartErrors[8] = "DiskPart cannot reassign the drive letter on a system, boot or pagefile volume."
$asDiskPartErrors[9] = "El volumen es demasiado grande."

Func _CheckForDiskPartErrors($sOutput)
;~ 	MsgBox(0, "errores", $sOutput)
	For $i = 0 to UBound($asDiskPartErrors) - 1
		If StringInStr($sOutput, $asDiskPartErrors[$i]) > 0 Then
			DiskPartitioner_ErrorHandler($asDiskPartErrors[$i], "", "Non-Fatal")
			ExitLoop
		EndIf
	Next
EndFunc