extends Control
class_name UI

signal tool_change(tool: Tools)

enum Tools {
	PLACE = 0,
	BREAK = 1,
	PENCIL = 2,
	ERASER =3
}

const _tool_textures = {
	Tools.PLACE: preload("res://assets/place_tool.png"),
	Tools.BREAK: preload("res://assets/hammer_tool.png"),
	Tools.PENCIL: preload("res://assets/pencil_tool.png"),
	Tools.ERASER: preload("res://assets/eraser_tool.png")
}

const _hotkey_map = {
	KEY_D: Tools.PLACE,
	KEY_E: Tools.BREAK,
	KEY_B: Tools.PENCIL,
	KEY_C: Tools.ERASER
}

@onready
var _tool_list: ItemList = $HSplitContainer/SidebarPanel/ToolList

@onready
var _material_list: VBoxContainer = $HSplitContainer2/MaterialPanel/MaterialVBox/MaterialScroll/MaterialSelectors

@onready
var _emission_switch: CheckButton = $MenuPanel/HBoxContainer/EmissionsEnabled

@onready
var _tool_texture: Sprite2D = $"../Tool"

@onready
var _add_material_button: Button = $HSplitContainer2/MaterialPanel/MaterialVBox/AddMaterial

var _selected_material = Voxel.no_material

var selected_tool: Tools = Tools.PLACE

var editor: MaterialEditor

func _ready():
	update_materials()
	select_material(Voxel.no_material)
	_tool_list.select(Tools.PLACE)
	_tool_texture.texture = _tool_textures[Tools.PLACE]
	_emission_switch.button_pressed = Materials.get_emissions_enabled()
	_emission_switch.toggled.connect(_toggle_emissions)
	_tool_list.item_selected.connect(_set_tool)
	_add_material_button.button_up.connect(_add_material)

func update_materials():
	if (editor != null):
		remove_child(editor)
		editor = null
	for child in _material_list.get_children():
		if (child is MaterialButton):
			child.toggle.disconnect(_on_select_material)
		_material_list.remove_child(child)
	for i in Materials.materials.size():
		var material_button: MaterialButton = MaterialButton.new(i,i == _selected_material)
		_material_list.add_child(material_button)
		material_button.toggle.connect(_on_select_material)

func _unhandled_input(event):
	if (event is InputEventKey):
		if (event.pressed && _hotkey_map.has(event.keycode)):
			_set_tool(_hotkey_map[event.keycode])
			_tool_list.select(_hotkey_map[event.keycode])
		elif(event.pressed && event.keycode == KEY_ESCAPE && editor != null):
			remove_child(editor)
			editor = null

func _on_select_material(material_id: int, value: bool):
	if (value):
		select_material(material_id)

func select_material(material_id: int):
	_selected_material = material_id
	for child in _material_list.get_children():
		if (child.get_material_id() != material_id):
			child.deselect()
		else:
			child.select()

func get_selected_material()->int:
	return _selected_material

func _add_material():
	Materials.add_material()
	update_materials()
	select_material(Materials.materials.size()-1)

func _toggle_emissions(value: bool):
	Materials.set_emissions_enabled(value)

func _set_tool(value:int):
	selected_tool = value as Tools
	_tool_texture.texture = _tool_textures[value]
	tool_change.emit(selected_tool)
