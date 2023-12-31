extends Control
class_name UI

signal tool_change(tool: int)
signal toggle_outlines(value: bool)
signal toggle_shading(value: bool)

@onready
var _light: DirectionalLight3D = $"../DirectionalLight3D"

@onready
var _environment: WorldEnvironment = $"../WorldEnvironment"
@onready
var _sky: Sky = _environment.environment.sky

@onready
var _tool_list: ToolList = $HSplitContainer/ToolList

@onready
var _material_list: VBoxContainer = $HSplitContainer2/MaterialPanel/MaterialVBox/MaterialScroll/MaterialSelectors

@onready
var _emission_switch: CheckButton = $MenuPanel/HBoxContainer/EmissionsEnabled
@onready
var _shadow_switch: CheckButton = $MenuPanel/HBoxContainer/ShadowsEnabled
@onready
var _outline_switch: CheckButton = $MenuPanel/HBoxContainer/OutlinesEnabled
@onready
var _shading_switch: CheckButton = $MenuPanel/HBoxContainer/Shading
@onready
var _tool_texture: Sprite2D = $"../Tool"

@onready
var _add_material_button: Button = $HSplitContainer2/MaterialPanel/MaterialVBox/AddMaterial

var _selected_material = Voxel.no_material

var _shading_enabled = true

var editor: MaterialEditor

func _ready():
	update_materials()
	select_material(Voxel.no_material)
	_tool_list.tool_change.connect(_on_tool_change)
	_shading_switch.button_pressed = _shading_enabled
	_emission_switch.button_pressed = _environment.environment.glow_enabled
	_shadow_switch.button_pressed = _light.shadow_enabled
	_emission_switch.toggled.connect(_toggle_emissions)
	_shadow_switch.toggled.connect(_toggle_shadows)
	_add_material_button.button_up.connect(_add_material)
	_outline_switch.toggled.connect(_toggle_outlines)
	_shading_switch.toggled.connect(_toggle_shading)
	Materials.material_delete.connect(_delete_material)

func get_outlines_enabled():
	return _outline_switch.button_pressed

func update_materials():
	if (editor != null):
		remove_child(editor)
		editor = null
	for child in _material_list.get_children():
		if (child is MaterialButton):
			child.toggle.disconnect(_on_select_material)
		_material_list.remove_child(child)
	for i in Materials.materials.keys():
		var material_button: MaterialButton = MaterialButton.new(i,i == _selected_material)
		_material_list.add_child(material_button)
		material_button.toggle.connect(_on_select_material)

func _delete_material(material_id: int):
	if (_selected_material == material_id):
		if (Materials.materials.keys().size() > 1):
			select_material(Materials.materials.keys()[0])
		else:
			select_material(Voxel.no_material)
	update_materials()

func _unhandled_input(event):
	if (event is InputEventKey):
		if(event.pressed && event.keycode == KEY_ESCAPE && editor != null):
			remove_child(editor)
			editor = null
		elif(event.keycode == KEY_ALT):
			if (event.pressed):
				_tool_texture.texture = Tools.get_tool(Tools.EYEDROPPER).icon
			else:
				if (get_selected_tool_index() != Tools.NONE):
					_tool_texture.texture = get_selected_tool().icon
				else:
					_tool_texture.texture = null

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
	_environment.environment.glow_enabled = value

func _toggle_shadows(value: bool):
	_light.shadow_enabled = value

func _on_tool_change(index: int):
	if (index != Tools.NONE):
		_tool_texture.texture = _tool_list.selected_tool_icon()
	else:
		_tool_texture.texture = null
	tool_change.emit(index)

func get_selected_tool():
	return _tool_list.selected_tool()

func get_selected_tool_index():
	return _tool_list.selected_tool_index()

func _toggle_outlines(value: bool):
	toggle_outlines.emit(value)

func _toggle_shading(value: bool):
	_shadow_switch.disabled = !value
	_emission_switch.disabled = !value
	if (!value):
		_toggle_shadows(false)
		_toggle_emissions(false)
		_environment.environment.background_mode = Environment.BG_COLOR
		_environment.environment.background_color = Color(0.2,0.2,0.2)
	else:
		_toggle_shadows(_shadow_switch.button_pressed)
		_toggle_emissions(_emission_switch.button_pressed)
		_environment.environment.background_mode = Environment.BG_SKY
		_environment.environment.sky = _sky
	toggle_shading.emit(value)

