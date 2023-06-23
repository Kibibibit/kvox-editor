extends StaticBody3D
class_name Voxel

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



func _ready():
	_shape.shape = BoxShape3D.new()
	_shape.position += Vector3(0.5,0.5,0.5)
	_mesh.mesh = BoxMesh.new()
	_mesh.position += Vector3(0.5,0.5,0.5)
	_update_neighbours(false)
	add_child(_shape)
	add_child(_mesh)



func delete():
	_update_neighbours(true)

func set_material(material_index: int):
	_mesh.set_surface_override_material(0, Materials.materials[material_index-1])

func _update_neighbours(_visible: bool):
	var ray: RayCast3D = RayCast3D.new()
	add_child(ray)
	for dir in _dirs:
		ray.target_position = dir
		if (ray.get_collider() is Voxel):
			ray.get_collider().visible = _visible
	remove_child(ray)
		
