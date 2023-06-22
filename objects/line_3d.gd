extends Object
class_name Line3D

var a: Vector3
var b: Vector3
var thickness: float
var color: Color

func _init(_a: Vector3, _b: Vector3, _color: Color = Color.RED, _thickness:float = -1.0):
	a = _a
	b = _b
	thickness = _thickness
	color = _color
