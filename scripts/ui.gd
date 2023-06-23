extends Control
class_name UI
@onready
var label: Label = $Label
@onready
var slider: HSlider = $HSlider
@onready
var grid: Grid = $"../Grid"

func _ready():
	slider.set_value_no_signal(grid.size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	label.text = "%s" % slider.value
	grid.set_size(round(slider.value))
	grid.remesh()

