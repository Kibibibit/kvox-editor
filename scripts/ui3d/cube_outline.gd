extends MeshInstance3D
class_name CubeOutline

@onready
var _material: StandardMaterial3D = StandardMaterial3D.new()

const _faces = [
	Vector3(0,0,0),
	Vector3(0,0,1),
	Vector3(0,0,0),
	Vector3(0,1,0),
	Vector3(0,0,0),
	Vector3(1,0,0),
	Vector3(1,1,1),
	Vector3(1,1,0),
	Vector3(1,1,1),
	Vector3(1,0,1),
	Vector3(1,1,1),
	Vector3(0,1,1),
	Vector3(1,0,0),
	Vector3(1,0,1),
	Vector3(1,0,0),
	Vector3(1,1,0),
	Vector3(1,1,0),
	Vector3(0,1,0),
	Vector3(0,0,1),
	Vector3(1,0,1),
	Vector3(0,0,1),
	Vector3(0,1,1),
	Vector3(0,1,1),
	Vector3(0,1,0)
]

func _ready():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array()
	for f in _faces:
		surface_array[Mesh.ARRAY_VERTEX].append(f-Vector3(0.5,0.5,0.5))
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, surface_array, )
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_material.albedo_color = Color.BLACK
	mesh.surface_set_material(0, _material)
	scale *= 1.0015
	

func set_color(color: Color):
	_material.albedo_color = color


