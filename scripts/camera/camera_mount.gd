extends Node3D
class_name CameraMount

@export
var rotate_speed:float = 0.005
@export
var pan_speed:float = 0.1
@export
var zoom_speed:float = 2.0
@export
var initial_zoom:float = 30.0
@export
var zoom:float = 30.0
@export
var max_zoom:float = 60.0
@export
var camera_speed: float = 30.0

@onready var camera: Camera3D = $Camera3D
@onready var _origin_pos = position
@onready var _origin_rotation = rotation
@onready var ray: RayCast3D = $Camera3D/RayCast3D
@onready var light: DirectionalLight3D = $"../DirectionalLight3D"

var target_position: Vector3 = position
var target_rotation: Vector3 = rotation
var target_zoom: float = initial_zoom

var _click_pos: Vector2


func _process(delta):
	camera.position = Vector3(0,0,zoom)
	camera.rotation = Vector3(0,0,0)
	light.rotation.y = rotation.y

	
	position = position.lerp(target_position, delta*camera_speed)
	rotation = rotation.lerp(target_rotation, delta*camera_speed)
	zoom = lerp(zoom, target_zoom, delta*camera_speed)
	
	
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera.project_ray_normal(get_viewport().get_mouse_position())
	ray.look_at_from_position(from,to)
	

func _zoom(direction: int):
	target_zoom += direction*(_zoom_factor()*2)*zoom_speed
	if (target_zoom < 0):
		target_zoom = 0
	if (target_zoom > 60):
		target_zoom = 60
	

func _unhandled_input(event):
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_WHEEL_UP):
			_zoom(-1)
			return
		if (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			_zoom(1)
			return
		if (event.pressed):
			_click_pos = event.position
	if (event is InputEventMouseMotion):
		var diff: Vector2 = event.position - _click_pos
		if (event.button_mask == MOUSE_BUTTON_MASK_MIDDLE):
			if (event.shift_pressed):
				var pan: Vector3 = Vector3(-diff.x, diff.y, 0)*pan_speed*_zoom_factor()
				target_position = to_global(pan)
			else:
				target_rotation += Vector3(-diff.y, -diff.x, 0)*rotate_speed
		_click_pos = event.position
	if (event is InputEventKey):
		if (event.pressed && event.keycode == KEY_O):
			target_position = _origin_pos
			target_rotation = _origin_rotation
			target_zoom = initial_zoom

func _zoom_factor() -> float:
	return (target_zoom/max_zoom)
