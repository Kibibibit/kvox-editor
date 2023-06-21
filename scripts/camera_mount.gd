extends Node3D

@export
var rotate_speed:float = 0.005
@export
var pan_speed:float = 0.01
@export
var zoom_speed:float = 2.0
@export
var inital_zoom:float = 30.0
@export
var zoom:float = 30.0
@export
var max_zoom:float = 60.0
@export
var return_to_origin_speed:float = 50.0

@onready var camera: Camera3D = $Camera3D
@onready var _origin_pos = position
@onready var _origin_rotation = rotation

var _click_pos: Vector2
var _returning_to_origin: bool = false


func _process(delta):
	camera.position = Vector3(0,0,zoom)
	camera.rotation = Vector3(0,0,0)
	if (_returning_to_origin):
		if (
			_origin_pos.distance_to(position) < 0.001 && 
			_origin_rotation.distance_to(rotation) < 0.001 &&
			abs(inital_zoom-zoom) < 0.001
		):
			_returning_to_origin = false
		else:
			position = position.lerp(_origin_pos, delta*return_to_origin_speed)
			rotation = rotation.lerp(_origin_rotation, delta*return_to_origin_speed)
			zoom = lerp(zoom, inital_zoom, delta*return_to_origin_speed)

func _zoom(direction: int):
	zoom += direction*(zoom/max_zoom)*zoom_speed
	if (zoom < 0):
		zoom = 0
	if (zoom > 60):
		zoom = 60

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
				position.y += diff.y*pan_speed
				
				var pan: Vector2 = Vector2(cos(rotation.y),-sin(rotation.y))*diff.x
				position -= Vector3(pan.x,0,pan.y)*pan_speed
				
			else:
				rotation += Vector3(-diff.y, -diff.x, 0)*rotate_speed
		_click_pos = event.position
	if (event is InputEventKey):
		if (event.pressed && event.keycode == KEY_O):
			_returning_to_origin = true
