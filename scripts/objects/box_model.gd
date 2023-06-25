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
	if (event is InputEventMouseButton):
		if (_ui.editor != null):
			return
		if (event.pressed):
				
			if (event.button_index == MOUSE_BUTTON_LEFT):
				if (_extruding):
					pass
				else:
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
						_:
							return
			elif (event.button_index == MOUSE_BUTTON_RIGHT):
				if (_ray_voxel != null):
					_camera_mount.target_position = _ray_voxel.position+Vector3(0.5,0.5,0.5)
				elif(_cube.visible):
					_camera_mount.target_position = _cube.position

func remove_voxel(voxel: Voxel):
	if (voxel != null):
		voxel.delete()
		voxel.queue_free()
		remove_child(voxel)
		

func add_voxel(pos: Vector3i,material_idx: int):
	var new_voxel: Voxel = Voxel.new()
	new_voxel.position = pos
	add_child(new_voxel)
	new_voxel.set_material(material_idx)

func get_outlines_enabled():
	return _ui.get_outlines_enabled()

func _toggle_outlines(value: bool):
	toggle_outlines.emit(value)
