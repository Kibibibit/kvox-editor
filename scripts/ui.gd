extends Control
class_name UI
@onready
var label: Label = $Label
@onready
var slider: HSlider = $HSlider

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	label.text = "%s" % slider.value
	Grid.size = slider.value as int

