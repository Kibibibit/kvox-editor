extends HBoxContainer
class_name MaterialButton

signal rename
signal delete
signal toggle(material_id: int,value:bool)


@onready
var _select: CheckBox = CheckBox.new()

@onready
var _edit: Button = Button.new()

@onready
var _delete: Button = Button.new()

var material_id: int
var _init_select: bool

func _init(_material_id: int, selected:bool):
	material_id = _material_id
	_init_select = selected


func _ready():
	_select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_select.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	_select.focus_mode = Control.FOCUS_NONE
	_select.button_pressed = _init_select
	
	_edit.icon = Icons.gear
	_edit.tooltip_text = "Edit this material"
	_edit.focus_mode = Control.FOCUS_NONE
	
	_delete.icon = Icons.bin
	_delete.tooltip_text = "Delete this material"
	_delete.focus_mode = Control.FOCUS_NONE
	
	add_child(_select)
	add_child(_edit)
	add_child(_delete)
	
	_select.toggled.connect(_toggle)
	_edit.button_up.connect(_edit_click)
	_delete.button_up.connect(_delete_material)
	
	update()
func get_material_id()->int:
	return material_id

func is_pressed()->bool:
	return _select.button_pressed

func select():
	_select.set_pressed_no_signal(true)

func deselect():
	_select.set_pressed_no_signal(false)

func _toggle(value: bool):
	if (value):
		toggle.emit(material_id, value)
	else:
		toggle.emit(Voxel.no_material, true)

func _edit_click():
	var ui: UI = find_parent("UI")

	if (ui.editor == null):
		_create_editor(ui)
	else:
		ui.remove_child(ui.editor)
		ui.editor.queue_free()
		if (ui.editor.material_id != material_id):
			_create_editor(ui)
		else:
			ui.editor = null
func _create_editor(ui: UI):
	ui.editor = load("res://scenes/material_editor.tscn").instantiate()
	var pos: Vector2 = get_screen_position()-Vector2(ui.editor.size.x,0)
	if (pos.y + ui.editor.size.y > ui.size.y):
		pos.y -= (pos.y+ui.editor.size.y) - ui.size.y
	ui.add_child(ui.editor)
	ui.editor.set_material_id(material_id)
	ui.editor.global_position = Vector2(pos)
	ui.editor.close.connect(_edit_click)
	ui.editor.update.connect(_update_material)
	ui.editor.update_name.connect(_update_name)

func _update_material(color:Color, roughness:int, metallic:int, emission:int):
	Materials.update_material(material_id, color, roughness, metallic, emission)
	update()
func _update_name(new_name:String):
	if (new_name.replace(" ","").is_empty()):
		_update_name("Material")
		return
	_select.text = new_name
	Materials.material_names[material_id] = new_name

func update():
	_select.text = Materials.material_names[material_id]
	_select.tooltip_text = "Use material: %s" % Materials.material_names[material_id]
	var icon: Image = preload("res://assets/material_icon.png").get_image()
	var shine: Image = preload("res://assets/material_shine.png").get_image()
	var halo: Image = preload("res://assets/material_halo.png").get_image()
	var mat = Materials.materials[material_id]

	for x in icon.get_size().x:
		for y in icon.get_size().y:
			var icon_c = icon.get_pixel(x,y)
			var halo_c = halo.get_pixel(x,y)
			var shine_c = shine.get_pixel(x,y)
			var shine_factor = (1-mat.roughness) * shine_c.a
			var r = (icon_c.r*mat.albedo_color.r) + (halo_c.r*halo_c.a*mat.emission.r) + (shine_c.r*shine_factor)
			var g = (icon_c.g*mat.albedo_color.g) + (halo_c.g*halo_c.a*mat.emission.g) + (shine_c.g*shine_factor)
			var b = (icon_c.b*mat.albedo_color.b) + (halo_c.b*halo_c.a*mat.emission.b) + (shine_c.b*shine_factor)
			var new_c = Color(r,g,b,icon_c.a)
			icon.set_pixel(x,y, new_c)
				
	_select.icon = ImageTexture.create_from_image(icon)

func _delete_material():
	Materials.delete_material(material_id)
