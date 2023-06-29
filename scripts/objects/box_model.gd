extends Node3D
class_name BoxModel

const version = 1

signal toggle_outlines(value: bool)

const _surrounding: Array[Vector3] = [
	Vector3(0,0,1),
	Vector3(0,1,0),
	Vector3(1,0,0),
	Vector3(0,0,-1),
	Vector3(0,-1,0),
	Vector3(-1,0,0)
]

const _normal_tools: Array[int] = [
	Tools.PLACE,
	Tools.EXTRUDE
]

@onready
var _ray: RayCast3D = $"../CameraMount/Camera3D/RayCast3D"

@onready
var _camera: Camera3D = $"../CameraMount/Camera3D"

@onready
var _camera_mount: CameraMount = $"../CameraMount"

@onready
var _cube: MeshInstance3D = $Cube

@onready
var _ui: UI = $"../UI"

@onready
var _tool_texture: Sprite2D = $"../Tool"

@onready
var _voxels: Array3D = Array3D.new(0,0,0)

var _array_offset:Vector3i = Vector3i(0,0,0)

var _normal: Vector3 = Vector3(0,0,0)

var _size: Vector3i = Vector3i(0,0,0)

var _ray_voxel: Voxel

func _ready():
	_ui.toggle_outlines.connect(_toggle_outlines)

func get_size() -> Vector3i:
	return _size

func _physics_process(_delta):
	if (_ray.is_colliding()):
		var collider = _ray.get_collider()
		_cube.visible = true
		
		_normal = _ray.get_collision_normal()
		if (collider.get_parent() is Grid):
			var collide_point = _ray.get_collision_point() - Vector3(0.5,0,0.5)
			collide_point = round(collide_point) + Vector3(0.5,0,0.5)
			collide_point.y = 0.5
			_cube.global_position = collide_point
			_ray_voxel = null
		else:
			_ray_voxel = collider
			_cube.position = collider.position+Vector3(0.5,0.5,0.5)
			
			if (_normal_tools.has(_ui.get_selected_tool_index())):
				_cube.position += _normal
	else:
		_cube.visible = false
		_ray_voxel = null
	_tool_texture.visible = _cube.visible
	if (_tool_texture.visible):
		_tool_texture.position = _camera.unproject_position(_cube.position)

func _unhandled_input(event):
	if (event is InputEventMouseButton):
		if (_ui.editor != null):
			return
		if (event.pressed):
			if (event.button_index == MOUSE_BUTTON_RIGHT && event.shift_pressed):
				if (_ray_voxel != null):
					_camera_mount.target_position = _ray_voxel.position+Vector3(0.5,0.5,0.5)
				elif(_cube.visible):
					_camera_mount.target_position = _cube.position
			elif (event.button_index == MOUSE_BUTTON_LEFT && event.alt_pressed):
				_eyedropper_tool()
			else:
				_use_tool(event)

func remove_voxel(voxel: Voxel):
	if (voxel != null):
		_voxels.set_at_v(voxel.grid_pos+_array_offset, null)
		voxel.queue_free()
		remove_child(voxel)

func remove_voxel_at(pos: Vector3i):
	var voxel: Voxel = _voxels.get_at_v(pos+_array_offset)
	if (voxel != null):
		remove_voxel(voxel)

func add_voxel(pos: Vector3i,material_idx: int):
	var new_voxel: Voxel = Voxel.new(pos)
	var array_pos = pos+_array_offset
	
	if (!_voxels.contains_point(array_pos)):
		var size_increase = Vector3i(0,0,0)
		var xy_index = 0
		var xz_index = 0
		var yz_index = 0
		if (array_pos.x < 0):
			_array_offset.x -= array_pos.x
			size_increase.x = abs(array_pos.x)
		elif(array_pos.x >= _voxels.width):
			size_increase.x = (array_pos.x-_voxels.width)+1
			yz_index = _voxels.width

		if (array_pos.y < 0):
			_array_offset.y -= array_pos.y
			size_increase.y = abs(array_pos.y)
		elif(array_pos.y >= _voxels.height):
			size_increase.y = (array_pos.y-_voxels.height)+1
			xz_index = _voxels.height
		
		if (array_pos.z < 0):
			_array_offset.z -= array_pos.z
			size_increase.z = abs(array_pos.z)
		elif(array_pos.z >= _voxels.depth):
			size_increase.z = (array_pos.z-_voxels.depth)+1
			xy_index = _voxels.depth
			
		_voxels.insert_slice(Array3D.PLANE_YZ, yz_index, size_increase.x)
		_voxels.insert_slice(Array3D.PLANE_XZ, xz_index, size_increase.y)
		_voxels.insert_slice(Array3D.PLANE_XY, xy_index, size_increase.z)
		array_pos = pos+_array_offset
	elif (_voxels.get_at_v(array_pos) != null):
		return
	_voxels.set_at_v(array_pos, new_voxel)
			
	new_voxel.position = pos
	add_child(new_voxel)
	new_voxel.set_material(material_idx)

func get_voxel_at(pos: Vector3i):
	if (_voxels.contains_point(pos+_array_offset)):
		return _voxels.get_at_v(pos+_array_offset)
	else:
		return null

func get_outlines_enabled():
	return _ui.get_outlines_enabled()

func _toggle_outlines(value: bool):
	toggle_outlines.emit(value)

func _get_extrude_face(normal:Vector3, visited: Array[Vector3], output: Array[Vector3], material_index: int = 0):
	
	if (visited.is_empty()):
		return output
	var base_pos = visited.pop_back()
	if (output.is_empty()):
		material_index = _voxels.get_at_v(Vector3i(base_pos)+_array_offset).material
	output.append(base_pos)
	var inverse_normal = Vector3(1,1,1)-normal
	for dir in _surrounding:
		if ((dir*inverse_normal).length() > 0):
			var n_pos = base_pos+dir
			if (output.has(n_pos) || visited.has(n_pos)):
				continue

			var array_point = _array_offset + Vector3i(n_pos)
			if (_voxels.contains_point(array_point)):
				if (_voxels.get_at_v(array_point) == null):
					continue
				else:
					if (_voxels.get_at_v(array_point).material != material_index):
						continue
				var normal_point = array_point+Vector3i(normal)
				var can_add = true
				if (_voxels.contains_point(normal_point)):
					can_add = _voxels.get_at_v(normal_point) == null
				if (can_add):
					visited.append(n_pos)


	return _get_extrude_face( normal, visited, output, material_index)

func _use_tool(event: InputEventMouseButton):
	match _ui.get_selected_tool_index():
		Tools.PLACE:
			_place_tool(event.button_index)
		Tools.BREAK:
			_break_tool()
		Tools.BRUSH:
			_brush_tool(event.button_index)
		Tools.ERASER:
			_eraser_tool()
		Tools.EYEDROPPER:
			_eyedropper_tool()
		Tools.BUCKET:
			_bucket_tool(event.button_index)
		Tools.EXTRUDE:
			_extrude_tool(event.button_index)
		_:
			return

func _place_tool(mouse_button: int):
	if (mouse_button == MOUSE_BUTTON_LEFT):
		add_voxel(_cube.position-Vector3(0.5,0.5,0.5), _ui.get_selected_material())
	elif (mouse_button == MOUSE_BUTTON_RIGHT):
		_break_tool()

func _break_tool():
	if (_ray_voxel != null):
		remove_voxel(_ray_voxel)

func _brush_tool(mouse_button: int):
	if (_ray_voxel != null):
		if (mouse_button == MOUSE_BUTTON_LEFT):
			_ray_voxel.set_material(_ui.get_selected_material())
		elif(mouse_button == MOUSE_BUTTON_RIGHT):
			_eraser_tool()

func _eraser_tool():
	if (_ray_voxel != null):
		_ray_voxel.set_material(Voxel.no_material)

func _eyedropper_tool():
	if (_ray_voxel != null):
		_ui.select_material(_ray_voxel.material)

func _bucket_tool(mouse_button: int):
	if (_ray_voxel != null):
		if (mouse_button == MOUSE_BUTTON_LEFT):
			_ray_voxel.flood_fill(_ui.get_selected_material())
		elif (mouse_button == MOUSE_BUTTON_RIGHT):
			_ray_voxel.flood_fill(Voxel.no_material)

func _extrude_tool(mouse_button:int):
	if (_ray_voxel != null):
		if (mouse_button == MOUSE_BUTTON_LEFT || mouse_button == MOUSE_BUTTON_RIGHT):
			var faces = _get_extrude_face(_normal, [_ray_voxel.position],[])
			for f in faces:
				if (mouse_button == MOUSE_BUTTON_LEFT):
					add_voxel(f+_normal, _ray_voxel.material)
				elif (mouse_button == MOUSE_BUTTON_RIGHT):
					remove_voxel_at(f)

func save_model(path: String):
	
	var width = _voxels.width
	var height = _voxels.height
	var depth = _voxels.depth
	var color_depth = Materials.materials.size()
	
	var orderings = [0b00000110, 0b00100001, 0b00100100, 0b00001001, 0b00010010, 0b00011000]
	
	var data_layout = 0
	var compressed = false
	var voxel_data = _gen_voxels(0b00000110, width, height, depth)
	var smallest_size = voxel_data.size()
	
	for o in orderings:
		var d = _rle(_gen_voxels(o, width,height,depth))
		if (d.size() < smallest_size):
			smallest_size = d.size()
			voxel_data = d
			data_layout = o
			compressed = true
	if compressed:
		data_layout += 0b10000000
	
	var output: Array[int] = VoxelMesh.header
	var meta_chunk = [version]
	meta_chunk.append_array(_encode_16(width))
	meta_chunk.append_array(_encode_16(height))
	meta_chunk.append_array(_encode_16(depth))
	meta_chunk.append(color_depth)
	meta_chunk.append(data_layout)
	output.append_array(_make_chunk(
		VoxelMesh.meta_chunk_header,
		meta_chunk
	))
	
	# Generate materials
	
	output.append_array(_make_chunk(
		VoxelMesh.voxel_chunk_header,
		voxel_data
	))
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	if (file == null):
		return FileAccess.get_open_error()
	
	for byte in output:
		file.store_8(byte)
	file.flush()
	file.close()

func _encode_16(value: int) -> Array[int]:
	return [
		(value & 0x00FF),
		(value & 0xFF00) >> 8
	]


func _make_chunk(chunk_header: Array[int], data: Array[int]) -> Array[int]:
	var out = VoxelMesh.chunk_header
	out.append_array(chunk_header)
	out.append_array(data)
	out.append_array(VoxelMesh.chunk_end)
	return out

func _get_dim_from_flag(a:int, b:int, c:int, a_flag:int, b_flag:int,c_flag:int, dim_flag:int):
	match dim_flag:
		a_flag:
			return a
		b_flag:
			return b
		c_flag:
			return c
		_:
			return 0

func _get_pos(a:int,b:int,c:int,a_flag:int,b_flag:int,c_flag:int):
	var x = _get_dim_from_flag(a,b,c,a_flag,b_flag,c_flag,VoxelMesh.x_flag)
	var y = _get_dim_from_flag(a,b,c,a_flag,b_flag,c_flag,VoxelMesh.y_flag)
	var z = _get_dim_from_flag(a,b,c,a_flag,b_flag,c_flag,VoxelMesh.z_flag)
	return Vector3i(x,y,z)

func _gen_voxels(order:int, width:int, height:int, depth:int) -> Array[int]:
	var a_flag = (order & 0b00110000) >> 4
	var b_flag = (order & 0b00001100) >> 2
	var c_flag = (order & 0b00000011)
	var ordering = {
		VoxelMesh.x_flag: width,
		VoxelMesh.y_flag: height,
		VoxelMesh.z_flag: depth,
	}
	
	var out: Array[int] = []
	
	for a in ordering[a_flag]:
		for b in ordering[b_flag]:
			for c in ordering[c_flag]:
				var pos = _get_pos(a,b,c,a_flag,b_flag,c_flag)
				out.append(_voxels.get_at_v(pos))
	return out

func _rle(input: Array[int]) -> Array[int]:
	var output:Array[int] = []
	var current_value: int = -1
	var count: int = 0
	for value in input:
		if ((current_value != value || count >= 255) && current_value != -1):
			output.append(count)
			output.append(current_value)
			count = 0
		count += 1
		current_value = value
	output.append(count)
	output.append(current_value)
	return output
