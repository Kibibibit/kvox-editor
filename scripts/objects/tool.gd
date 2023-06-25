class_name Tool
extends Object

var name: String
var icon: AtlasTexture
var color: Color
var key_code: int
var shift_pressed: bool
var control_pressed: bool
var alt_pressed: bool
var tooltip_text: String

func _init(
	_name: String, 
	_icon: AtlasTexture,
	_tooltip_text: String = "",
	_color: Color = Color.CADET_BLUE,
	_key_code: int = KEY_NONE, 
	_shift_pressed: bool = false,
	_control_pressed: bool = false,
	_alt_pressed: bool = false,
):
	name = _name
	icon = _icon
	color = _color
	key_code = _key_code
	shift_pressed = _shift_pressed
	control_pressed = _control_pressed
	alt_pressed = _alt_pressed
	tooltip_text = _tooltip_text
	
	if (tooltip_text.is_empty()):
		tooltip_text = name
	if (_key_code != KEY_NONE):
		var hotkey: String = String.chr(_key_code)
		if (shift_pressed):
			hotkey = "%s+%s" % ["SHIFT", hotkey]
		if (alt_pressed):
			hotkey = "%s+%s" % ["ALT", hotkey]
		if (control_pressed):
			hotkey = "%s+%s" % ["CTRL", hotkey]
		tooltip_text = "(%s) %s" % [hotkey ,tooltip_text]
	
