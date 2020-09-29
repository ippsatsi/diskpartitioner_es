;These functions eliminate the default control limits of -32,768 to 32,767

;Original code for this function found at:
	;http://www.autoitscript.com/forum/topic/105296-guictrlcreateinput-can-no-set-upper-limit-higher-than-32767/
Func _GUICtrlUpdownSetRange32($h_updown=0, $i_Low=-2147483648, $i_High=2147483647)
	; Windows message ID for the UDM_SETRANGE32 message
	; UDM_SETRANGE32 - Sets the 32-bit range of an up-down control.
	; http://msdn.microsoft.com/en-us/library/bb759968%28VS.85%29.aspx
	Const $UDM_SETRANGE32 = $WM_USER+111
	GUICtrlSendMsg($h_updown, $UDM_SETRANGE32, $i_Low, $i_High)
EndFunc

Func _GUICtrlSliderSetRange32($h_slider=0, $i_Low=-2147483648, $i_High=2147483647)
	;TBM_SETRANGEMIN Sets the 32-bit range minimum of a slider control.
	; http://msdn.microsoft.com/en-us/library/bb760226(v=vs.85).aspx
	;TBM_SETRANGEMAX Sets the 32-bit range maximum of a slider control.
	;http://msdn.microsoft.com/en-us/library/bb760224(v=vs.85).aspx
	GUICtrlSendMsg($h_slider, $TBM_SETRANGEMIN, 0, $i_Low)
	GUICtrlSendMsg($h_slider, $TBM_SETRANGEMAX, 0, $i_High)
EndFunc