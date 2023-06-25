extends StaticBody3D
class_name Voxel

const no_material: int = -10

const _dirs = [
	Vector3(1,0,0),
	Vector3(0,1,0),
	Vector3(0,0,1),
	Vector3(-1,0,0),
	Vector3(0,-1,0),
	Vector3(0,0,-1),
]

@onready
var _shape: CollisionShape3D = CollisionShape3D.new()
@onready
var _mesh: MeshInstance3D = MeshInstance3D.new()

@onready
var _outline: CubeOutline = CubeOutline.new()

var material: int


func _ready():
	_shape.shape = BoxShape3D.new()
	_shape.position += Vector3(0.5,0.5,0.5)
	_mesh.mesh = BoxMesh.new()
	_mesh.position += Vector3(0.5,0.5,0.5)
	_outline.position += Vector3(0.5,0.5,0.5)
	_update_neighbours(false)
	add_child(_shape)
	add_child(_mesh)
	add_child(_outline)
	_outline.visible = get_parent().get_outlines_enabled()
	Materials.material_update.connect(_update_material)
	Materials.material_delete.connect(_delete_material)
	get_parent().toggle_outlines.connect(_toggle_outlines)



func delete():
	_update_neighbours(true)

func set_material(material_index: int):
	material = material_index
	if (material_index == no_material):
		_mesh.set_surface_override_material(0, null)
		_outline.set_color(Color.BLACK)
	else:
		_mesh.set_surface_override_material(0, Materials.materials[material_index])
		var r = Materials.voxel_materials[material_index].color.r
		var g = Materials.voxel_materials[material_index].color.g
		var b = Materials.voxel_materials[material_index].color.b
		var nr = 1
		var ng = 1
		var nb = 1
		if (r > 0.5):
			nr = 0
		if (g > 0.5):
			ng = 0
		if (b >= 0.5):
			nb = 0
		_outline.set_color(Color(nr,ng,nb))

func _update_material(material_index: int):
	if (material_index == material):
		set_material(material_index)

func _delete_material(material_index:int):
	if (material_index == material):
		set_material(Voxel.no_material)

func _update_neighbours(_visible: bool):
	var ray: RayCast3D = RayCast3D.new()
	add_child(ray)
	for dir in _dirs:
		ray.target_position = dir
		if (ray.get_collider() is Voxel):
			ray.get_collider().visible = _visible
	remove_child(ray)

func _toggle_outlines(value: bool):
	_outline.visible = value
