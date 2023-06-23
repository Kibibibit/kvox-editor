extends Control
class_name UI
@onready
var label: Label = $Label
@onready
var slider: HSlider = $HSlider
@onready
var grid: MeshInstance3D = $"../Grid"

var _d: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	label.text = "%s" % slider.value
	var mesh: GridMesh = grid.mesh
	mesh.set_size(round(slider.value))
	mesh.remesh()
	
	_d += _delta
	var r: float = (0.5*sin(_d)) + 0.5
	mesh.set_color(Color(1,1,1,r))

