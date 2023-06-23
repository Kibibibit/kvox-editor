extends MeshInstance3D
class_name Grid

@export var size:int = 5
@export var height:int = 0
@export var color: Color = Color.RED
var material: StandardMaterial3D
var remesh_queued = true;

@onready
var _collider: CollisionShape3D = $StaticBody3D/CollisionShape3D


func _ready():
	mesh = ArrayMesh.new()
	material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	remesh()

func remesh():
	if (!remesh_queued):
		return
	var verts = PackedVector3Array()
	var x_a = -size
	var x_b = size+1
	var z_a = -size
	var z_b = size+1
	
	for x in range(-size,size+2):
		verts.append(Vector3(x,height,z_a))
		verts.append(Vector3(x,height,z_b))
	for z in range(-size, size+2):
		verts.append(Vector3(x_a,height,z))
		verts.append(Vector3(x_b,height,z))
	if (mesh.get_surface_count() > 0):
		mesh.clear_surfaces()

	var surface_array = []
	surface_array.resize((Mesh.ARRAY_MAX))
	surface_array[Mesh.ARRAY_VERTEX] = verts
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, surface_array, )
	mesh.surface_set_material(0,material)
	remesh_queued = false
	_collider.shape.size = Vector3(2*size+1,0.01,2*size+1)

func set_size(s: int):
	if (s != size):
		size = s
		remesh_queued = true

func set_height(h: int):
	if (h != height):
		height = h
		remesh_queued = true

func set_color(c: Color):
	color = c
	material.albedo_color = c

