extends ArrayMesh
class_name GridMesh

@export var size:int = 5
@export var height:int = 0
@export var color: Color = Color.RED

var material: StandardMaterial3D
var remesh_queued = true;

func _init():
	material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	set_color(color)
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
		verts.append(_grid_v(x,height,z_a))
		verts.append(_grid_v(x,height,z_b))
	for z in range(-size, size+2):
		verts.append(_grid_v(x_a,height,z))
		verts.append(_grid_v(x_b,height,z))
	if (get_surface_count() > 0):
		clear_surfaces()

	var surface_array = []
	surface_array.resize((Mesh.ARRAY_MAX))
	surface_array[Mesh.ARRAY_VERTEX] = verts
	add_surface_from_arrays(Mesh.PRIMITIVE_LINES, surface_array, )
	surface_set_material(0,material)
	remesh_queued = false


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

func _grid_v(x:float, y:float, z:float) -> Vector3:
	return Vector3(x-0.5, y-0.5, z-0.5)
