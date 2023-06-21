extends Camera3D



var _shift: bool = false

var target: Vector3 = Vector3(0,0,0)


func _check_shift(event: InputEvent):
	if (event is InputEventKey):
		_shift = (event.keycode == KEY_SHIFT && event.pressed)


func _unhandled_input(event):
	_check_shift(event)

	if (event is InputEventMouseMotion):
		if (event.button_mask == MOUSE_BUTTON_MASK_MIDDLE):
			
	
