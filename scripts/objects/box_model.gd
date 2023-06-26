extends Node3D
class_name BoxModel

signal toggle_outlines(value: bool)

const _surrounding: Array[Vector3i] = [
	Vector3i(0,0,1),
	Vector3i(0,1,0),
	Vector3i(1,0,0),
	Vector3i(0,0,-1),
	Vector3i(0,-1,0),
	Vector3i(-1,0,0)
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

var _size: Vector3i = Vector3i(0,0,0)

var _ray_voxel: Voxel

var _extruding = false

func _ready():
	_ui.toggle_outlines.connect(_toggle_outlines)

func get_size() -> Vector3i:
	return _size

func _physics_process(_delta):
	if (_ray.is_colliding()):
		var collider = _ray.get_collider()
		_cube.visible = true
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
				_cube.position+=_ray.get_collision_normal()
	else:
		_cube.visible = false
		_ray_voxel = null
	_tool_texture.visible = _cube.visible
	if (_tool_texture.visible):
		_tool_texture.position = _camera.unproject_position(_cube.position)

func _unhandled_input(event):
	if (event is InputEventMouseButton && !_extruding):
		if (_ui.editor != null):
			return
		if (event.pressed):
				
			if (event.button_index == MOUSE_BUTTON_LEFT):
				match _ui.get_selected_tool_index():
					Tools.PLACE:
						add_voxel(_cube.position-Vector3(0.5,0.5,0.5), _ui.get_selected_material())
					Tools.BREAK:
						if (_ray_voxel != null):
							remove_voxel(_ray_voxel)
					Tools.BRUSH:
						if (_ray_voxel != null):
							_ray_voxel.set_material(_ui.get_selected_material())
					Tools.ERASER:
						if (_ray_voxel != null):
							_ray_voxel.set_material(Voxel.no_material)
					Tools.EYEDROPPER:
						if (_ray_voxel != null):
							_ui.select_material(_ray_voxel.material)
					Tools.BUCKET:
						if (_ray_voxel != null):
							_ray_voxel.flood_fill(_ui.get_selected_material())
					Tools.EXTRUDE:
						if (_ray_voxel != null):
							_extruding = true
					_:
						return
		elif (event.button_index == MOUSE_BUTTON_RIGHT):
			if (_ray_voxel != null):
				_camera_mount.target_position = _ray_voxel.position+Vector3(0.5,0.5,0.5)
			elif(_cube.visible):
				_camera_mount.target_position = _cube.position
	else:
		if (event is InputEventMouseMotion):
			if (event.button_mask == MOUSE_BUTTON_MASK_LEFT):
				print(event.position)
			else:
				_extruding = false

func remove_voxel(voxel: Voxel):
	if (voxel != null):
		voxel.queue_free()
		remove_child(voxel)
		

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
