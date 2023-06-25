class_name ToolList
extends Control

signal tool_change(tool_code: int)

@onready
var _list: ItemList = ItemList.new()

@onready
var _tools = {
	Tools.PLACE: Tool.new(
		"Place", Icons.place,
		"Place new voxels",
		Color.GREEN,
		KEY_D
	),
	Tools.BREAK: Tool.new(
		"Break", Icons.hammer,
		"Break voxels",
		Color.RED,
		KEY_E
	),
	Tools.BRUSH: Tool.new(
		"Brush", Icons.brush,
		"Recolour voxels",
		Color.WHITE,
		KEY_B
	),
	Tools.WAND: Tool.new(
		"Wand", Icons.wand,
		"Unimplemented!",
		Color.PINK,
		KEY_W
	),
	Tools.PENCIL: Tool.new(
		"Pencil", Icons.pencil,
		"Unimplemented!"
	),
	Tools.ERASER: Tool.new(
		"Eraser", Icons.eraser,
		"Remove material from voxels",
		Color.DEEP_PINK,
		KEY_C
	),
	Tools.BUCKET: Tool.new(
		"Bucket", Icons.bucket,
		"Recolour adjacent voxels",
		Color.BLUE,
		KEY_G
	),
}

func selected_tool_index():
	if (!_list.get_selected_items().is_empty()):
		return _list.get_selected_items()[0]
	else:
		return Tools.NONE

func selected_tool():
	var index = selected_tool_index()
	if (index != Tools.NONE):
		return _tools[index]
	else:
		return null

func selected_tool_icon():
	var tool: Tool = selected_tool()
	if (tool != null):
		return tool.icon
	else:
		return null



func _ready():
	custom_minimum_size = Vector2(90,0)
	size = Vector2(90, 615.6)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(_list)
	_list.focus_mode = Control.FOCUS_NONE
	_list.select_mode = ItemList.SELECT_SINGLE
	_list.anchor_top = 0
	_list.anchor_bottom = 1
	_list.anchor_left = 0
	_list.anchor_right = 1

	for tool_key in _tools.keys():
		var tool: Tool = _tools[tool_key]
		_list.add_item(tool.name, tool.icon)
		_list.set_item_tooltip(tool_key, tool.tooltip_text)
	_list.item_clicked.connect(_on_select)
	

func _on_select(index: int, _at: Vector2, button_index: int):
	if (button_index == MOUSE_BUTTON_LEFT):
		_list.select(index)
		tool_change.emit(index)
	elif (button_index == MOUSE_BUTTON_RIGHT):
		_list.deselect(index)
		tool_change.emit(Tools.NONE)

func _unhandled_input(event):
	if (event is InputEventKey):
		if (event.pressed):
			for tool_key in _tools.keys():
				var tool: Tool = _tools[tool_key]
				if (event.keycode == tool.key_code):
					if (
						event.is_command_or_control_pressed() == tool.control_pressed &&
						event.shift_pressed == tool.shift_pressed &&
						event.alt_pressed  == tool.alt_pressed
					):
						_list.select(tool_key)
						tool_change.emit(tool_key)
						break
