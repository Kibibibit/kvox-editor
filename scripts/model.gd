extends Node3D

var width = 0
var height = 0
var depth = 0

var data = [[[]]]
var lines = []

var _line_defs = {
	VoxelMesh.Faces.X:[
		Vector3(0.5,-0.5,-0.5), 
		Vector3(0.5, -0.5, 0.5), 
		Vector3(0.5, 0.5, 0.5), 
		Vector3(0.5, 0.5, -0.5)
	],
	VoxelMesh.Faces.NEG_X:[
		Vector3(-0.5,-0.5,-0.5), 
		Vector3(-0.5, -0.5, 0.5), 
		Vector3(-0.5, 0.5, 0.5), 
		Vector3(-0.5, 0.5, -0.5)
	],
	VoxelMesh.Faces.Y:[
		Vector3(-0.5,0.5,-0.5), 
		Vector3(-0.5,0.5, 0.5), 
		Vector3(0.5, 0.5, 0.5), 
		Vector3(0.5, 0.5, -0.5)
	],
	VoxelMesh.Faces.NEG_Y:[
		Vector3(-0.5,-0.5,-0.5), 
		Vector3(-0.5,-0.5, 0.5), 
		Vector3(0.5, -0.5, 0.5), 
		Vector3(0.5, -0.5, -0.5)
	],
	VoxelMesh.Faces.Z:[
		Vector3(-0.5,-0.5,0.5), 
		Vector3(-0.5,0.5, 0.5), 
		Vector3(0.5, 0.5, 0.5), 
		Vector3(0.5, -0.5, 0.5)
	],
	VoxelMesh.Faces.NEG_Z:[
		Vector3(-0.5,-0.5,-0.5), 
		Vector3(-0.5,0.5, -0.5), 
		Vector3(0.5, 0.5, -0.5), 
		Vector3(0.5, -0.5, -0.5)
	],
	
}


func _process(_delta):
	_clear_lines()
	_draw_square(VoxelMesh.Faces.X)
	_draw_square(VoxelMesh.Faces.NEG_X)
	_draw_square(VoxelMesh.Faces.Z)
	_draw_square(VoxelMesh.Faces.NEG_Z)
	


func _clear_lines():
	for line in lines:
		LineDrawer.remove_line(line)
	lines = []
	

func _draw_square(face: VoxelMesh.Faces):
	for i in 4:
		var a = _line_defs[face][i]
		var b
		if (i + 1 >= 4):
			b = _line_defs[face][0]
		else:
			b = _line_defs[face][i+1]
		lines.append(LineDrawer.add_line(a,b, Color.BLUE))

