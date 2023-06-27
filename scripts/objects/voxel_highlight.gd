extends CubeOutline


@onready
var _ui: UI = $"../../../UI"


func _ready():
	super._ready()
	_ui.tool_change.connect(_tool_change)
	set_color(Color.WHITE)

func _tool_change(tool: int):
	if (tool != Tools.NONE):
		set_color(_ui.get_selected_tool().color)
	else:
		set_color(Color.WHITE)

func _unhandled_key_input(event):
	if (event is InputEventKey):
		if (event.keycode == KEY_ALT):
			if (event.pressed):
				set_color(Tools.get_tool(Tools.EYEDROPPER).color)
			else:
				if (_ui.get_selected_tool_index() != Tools.NONE):
					set_color(_ui.get_selected_tool().color)
				else:
					set_color(Color.WHITE)
