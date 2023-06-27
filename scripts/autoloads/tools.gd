extends Node

const NONE: int = -1
const PLACE: int = 0
const BREAK: int = 1
const BRUSH: int = 2
const WAND: int = 3
const PENCIL: int = 4
const ERASER: int = 5
const BUCKET: int =  6
const EXTRUDE: int = 7
const EYEDROPPER: int = 8

@onready
var _tools = {
	PLACE: Tool.new(
		"Place", Icons.place,
		"Place new voxels",
		Color.GREEN,
		KEY_D
	),
	BREAK: Tool.new(
		"Break", Icons.hammer,
		"Break voxels",
		Color.RED,
		KEY_E
	),
	BRUSH: Tool.new(
		"Brush", Icons.brush,
		"Recolour voxels",
		Color.WHITE,
		KEY_B
	),
	WAND: Tool.new(
		"Wand", Icons.wand,
		"Unimplemented!",
		Color.PINK,
		KEY_W
	),
	PENCIL: Tool.new(
		"Pencil", Icons.pencil,
		"Unimplemented!"
	),
	ERASER: Tool.new(
		"Eraser", Icons.eraser,
		"Remove material from voxels",
		Color.DEEP_PINK,
		KEY_C
	),
	BUCKET: Tool.new(
		"Bucket", Icons.bucket,
		"Recolour adjacent voxels",
		Color.BLUE,
		KEY_G
	),
	EXTRUDE: Tool.new(
		"Extrude", Icons.extrude,
		"Extrude a voxel face",
		Color.LIME,
		KEY_F
	),
	EYEDROPPER: Tool.new(
		"Eyedropper", Icons.eyedropper,
		"Select a material from a voxel",
		Color.CYAN,
		KEY_J
	)
}

func get_tools()->Array:
	return _tools.keys()

func get_tool(tool:int)->Tool:
	return _tools[tool]
