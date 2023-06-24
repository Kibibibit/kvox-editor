extends MeshInstance3D


@onready
var _ui: UI = $"../../../UI"

@onready
var _material: StandardMaterial3D = StandardMaterial3D.new()

const _faces = [
	Vector3(0,0,0),
	Vector3(0,0,1),
	Vector3(0,0,0),
	Vector3(0,1,0),
	Vector3(0,0,0),
	Vector3(1,0,0),
	Vector3(1,1,1),
	Vector3(1,1,0),
	Vector3(1,1,1),
	Vector3(1,0,1),
	Vector3(1,1,1),
	Vector3(0,1,1),
	Vector3(1,0,0),
	Vector3(1,0,1),
	Vector3(1,0,0),
	Vector3(1,1,0),
	Vector3(1,1,0),
	Vector3(0,1,0),
	Vector3(0,0,1),
	Vector3(1,0,1),
	Vector3(0,0,1),
	Vector3(0,1,1),
	Vector3(0,1,1),
	Vector3(0,1,0)
]

const _colors = {
	UI.Tools.PLACE: Color.BLUE,
	UI.Tools.BREAK: Color.RED,
	UI.Tools.PENCIL: Color.GREEN,
	UI.Tools.ERASER: Color.DEEP_PINK
}

func _ready():
	_ui.tool_change.connect(_tool_change)
	
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array()
	for f in _faces:
		surface_array[Mesh.ARRAY_VERTEX].append(f-Vector3(0.5,0.5,0.5))
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, surface_array, )
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.surface_set_material(0, _material)
	_tool_change(UI.Tools.PLACE)
	


func _tool_change(tool: UI.Tools):
	_material.albedo_color = _colors[tool]
