extends Node2D

@onready
var camera: Camera3D = get_viewport().get_camera_3d()

@onready
var lines: Dictionary = {}


func _draw():
	for i in lines.keys():
		var line: Line3D = lines[i]
		if (!camera.is_position_behind(line.a) && !camera.is_position_behind(line.b)):
			var a = camera.unproject_position(line.a)
			var b = camera.unproject_position(line.b)
			draw_line(a,b,line.color,line.thickness)

func add_line(a:Vector3, b:Vector3, color: Color = Color.RED, thickness:float = -1.0) -> int:
	var id:int = 0
	while (lines.keys().find(id) != -1):
		id += 1
	lines[id] = Line3D.new(a,b,color,thickness)
	return id

func _process(_delta):
	queue_redraw()

func remove_line(id:int):
	lines.erase(id)
