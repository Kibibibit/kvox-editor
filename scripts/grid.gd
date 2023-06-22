extends Node

var show_grid: bool = true

var thickness: float = -1.0
var color: Color = Color.DARK_GRAY
var size: int = 4
var height: int = 0


var lines = []

func _process(_delta):
	_clear_lines()
	var x_a: float = -size-1
	var x_b: float = size
	var z_a = -size-1
	var z_b = size
	for _x in 2*size+2:
		var x_off: float = x_a + (_x/(size as float))*size
		var v_a = Vector3(x_off+0.5, height-0.5, z_a+0.5)
		var v_b = Vector3(x_off+0.5, height-0.5, z_b+0.5)
		lines.append(LineDrawer.add_line(v_a,v_b, color, thickness))
	for _z in 2*size+2:
		var z_off: float = z_a + (_z/(size as float))*size
		var v_a = Vector3(x_a+0.5, height-0.5, z_off+0.5)
		var v_b = Vector3(x_b+0.5, height-0.5, z_off+0.5)
		lines.append(LineDrawer.add_line(v_a,v_b, color, thickness))

func _clear_lines():
	for line in lines:
		LineDrawer.remove_line(line)
	lines = []
