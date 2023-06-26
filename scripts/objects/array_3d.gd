extends Object
class_name Array3D

const PLANE_XY = 0
const PLANE_XZ = 1
const PLANE_YZ = 2

const _size_vectors = {
	PLANE_XY: Vector3i(0,0,1),
	PLANE_XZ: Vector3i(0,1,0),
	PLANE_YZ: Vector3i(1,0,0)
}

var size: Vector3i
var default_value

var width: int:
	get:
		return size.x
	set(value):
		size.x = value

var height: int:
	get:
		return size.y
	set(value):
		size.y = value

var depth:int:
	get:
		return size.z
	set(value):
		size.z = value

var _data: Array = []


func _init(w:int=0, h:int=0, d:int=0, default = null):
	size = Vector3i(w,h,d)
	default_value = default
	_data = _make_array(w,h,d, default)

func _make_array(w:int, h:int, d:int, default):
	var out: Array = []
	for i in w*h*d:
		out.append(default)
	return out

func contains_point(p:Vector3i ):
	return (
		p.x >= 0 && p.x < size.x &&
		p.y >= 0 && p.y < size.y &&
		p.z >= 0 && p.z < size.z
	)

func _index_sized(x:int,y:int,z:int, _size:Vector3i):
	assert(
		x >= 0 && x < _size.x &&
		y >= 0 && y < _size.y &&
		z >= 0 && z < _size.z,
		"(%s,%s,%s) is out of range for Array3D of size (%s,%s,%s)" % [x,y,z,_size.x,_size.y,_size.z]
	)
	var xy_slice = (y*_size.x) + x
	return xy_slice+(_size.x*_size.y*z)

func _index(x:int, y:int, z:int) -> int:
	return _index_sized(x,y,z,size)

func get_at(x:int, y:int, z:int):
	return _data[_index(x,y,z)]

func get_at_v(pos: Vector3i):
	return _data[_index(pos.x,pos.y,pos.z)]

func set_at(x:int,y:int,z:int,value) -> void:
	_data[_index(x,y,z)] = value

func set_at_v(pos:Vector3i, value) -> void:
	_data[_index(pos.x,pos.y,pos.z)] = value

func insert_slice(plane: int, index:int, count: int = 1) -> void:
	var size_vector = _size_vectors[plane]
	var dim = size*size_vector
	assert(
		dim.x >= 0 && dim.x <= size.x &&
		dim.y >= 0 && dim.y <= size.y &&
		dim.z >= 0 && dim.z <= size.z,
		"Trying to insert at index %s which is outside array" % index
	)
	
	var new_size = size + size_vector*count
	var new_data = _make_array(new_size.x,new_size.y,new_size.z, default_value)
	
	for x in size.x:
		for y in size.y:
			for z in size.z:
				var pos: Vector3i = Vector3i(x,y,z)
				var plane_progress = round((pos*size_vector).length())
				var mapped_pos = pos
				if (plane_progress >= index):
					mapped_pos += size_vector*count
				new_data[_index_sized(mapped_pos.x,mapped_pos.y,mapped_pos.z,new_size)] = get_at_v(pos)
	size = new_size
	_data = new_data

