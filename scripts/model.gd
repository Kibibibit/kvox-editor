class_name Model
extends MeshInstance3D

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


var _mouse_pos: Vector3 = Vector3(0,0,0)

@onready
var _ray: RayCast3D = $"../CameraMount/Camera3D/RayCast3D"


@onready
var _cube: MeshInstance3D = $Cube

@onready
var _collider: ModelCollider = ModelCollider.new()

func _ready():
	add_child(_collider)

func _physics_process(_delta):
	if (_ray.is_colliding()):
		var collider = _ray.get_collider()
		_cube.visible = true
		_cube.position = collider.shape_owner_get_owner(_ray.get_collider_shape()).position+_ray.get_collision_normal()
		
	else:
		_cube.visible = false


func _process(_delta):
	pass
