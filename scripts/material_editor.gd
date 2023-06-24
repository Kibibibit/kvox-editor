extends Control
class_name MaterialEditor

signal update(color:Color, roughness:int, metallic:int, emission:int)
signal update_name(new_name:String)
signal close

@onready
var _demo: Node3D = $"Panel/MarginContainer/HBoxContainer/Settings Container/PreviewContainer/SubViewportContainer/SubViewport/material_demo"

@onready
var _color_rect: ColorRect = $"Panel/MarginContainer/HBoxContainer/Settings Container/PreviewContainer/ColorRect"
@onready
var _color_picker: ColorPicker = $Panel/MarginContainer/HBoxContainer/MarginContainer/ColorPicker

@onready
var _rough_slider: HSlider = $"Panel/MarginContainer/HBoxContainer/Settings Container/RoughnessContainer/RoughnessSlider"
@onready
var _rough_label: SpinBox = $"Panel/MarginContainer/HBoxContainer/Settings Container/RoughnessContainer/RoughnessValueLabel"
@onready
var _metal_slider: HSlider = $"Panel/MarginContainer/HBoxContainer/Settings Container/RoughnessContainer/MetallicSlider"
@onready
var _metal_label: SpinBox = $"Panel/MarginContainer/HBoxContainer/Settings Container/RoughnessContainer/MetallicValueLabel"
@onready
var _emission_slider: HSlider = $"Panel/MarginContainer/HBoxContainer/Settings Container/RoughnessContainer/EmissionSlider"
@onready
var _emission_label: SpinBox = $"Panel/MarginContainer/HBoxContainer/Settings Container/RoughnessContainer/EmissionValueLabel"
@onready
var _name: LineEdit = $"Panel/MarginContainer/HBoxContainer/Settings Container/NameContainer/NameEdit"

var material_id: int

var _color: Color = Color.BLACK
var _metallic: int = 0
var _roughness: int = 0
var _emission: int = 0

func set_material_id(mat_id: int):
	material_id = mat_id
	var mat: VoxelMaterial = Materials.voxel_materials[mat_id]
	var mat_name = Materials.material_names[mat_id]
	_color = mat.color
	_metallic = mat.metallic
	_roughness = mat.roughness
	_emission = mat.emission_energy
	_color_picker.color = _color
	_rough_slider.value = _roughness
	_rough_label.value = _roughness
	_metal_slider.value = _metallic
	_metal_label.value = _metallic
	_emission_slider.value = _emission
	_emission_label.value = _emission
	_name.text = mat_name
	_update()

func _ready():
	_color_picker.color = _color
	_color_picker.color_changed.connect(_update_color)
	_rough_slider.value_changed.connect(_update_roughness.bind(true))
	_metal_slider.value_changed.connect(_update_metallic.bind(true))
	_emission_slider.value_changed.connect(_update_emission.bind(true))
	_rough_label.value_changed.connect(_update_roughness.bind(false))
	_metal_label.value_changed.connect(_update_metallic.bind(false))
	_emission_label.value_changed.connect(_update_emission.bind(false))
	_name.text_changed.connect(_update_name)
	_update()

func _process(delta):
	_demo.get_node("Example").rotate_y(delta)

func _update_color(color):
	_color = color
	_update()

func _update_label(value:int, label: SpinBox):
	label.set_value_no_signal(value)
	label.get_line_edit().text = "%s" % [value]

func _update_slider(value: int, slider: HSlider):
	slider.value = value

func _update_roughness(value: float, slider: bool):
	_roughness = round(value)
	if (slider):
		_update_label(_roughness, _rough_label)
	else:
		_update_slider(_roughness, _rough_slider)

	_update()

func _update_metallic(value: float, slider:bool):
	_metallic = round(value)
	if (slider):
		_update_label(_metallic, _metal_label)
	else:
		_update_slider(_metallic, _metal_slider)
	_update()

func _update_emission(value: float, slider:bool):
	_emission = round(value)
	if (slider):
		_update_label(_emission, _emission_label)
	else:
		_update_slider(_emission, _emission_slider)
	_update()

func _update():
	_color_rect.color = _color
	update.emit(_color, _roughness, _metallic, _emission)
	var mat = Materials.materials[material_id]
	_demo.get_node("Example").set_surface_override_material(0, mat)
	
func _update_name(value:String):
	update_name.emit(value)

func _unhandled_input(event):
	if (event is InputEventMouseButton):
		if (!get_global_rect().has_point(event.position)):
			close.emit()

func _exit_tree():
	_demo.get_node("Example").set_surface_override_material(0, null)
