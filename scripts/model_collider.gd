class_name ModelCollider
extends StaticBody3D

const _surrounding: Array[Vector3i] = [
	Vector3i(0,0,1),
	Vector3i(0,1,0),
	Vector3i(1,0,0),
	Vector3i(0,0,-1),
	Vector3i(0,-1,0),
	Vector3i(-1,0,0)
]

@onready
var _model: VoxelMesh = $"..".mesh

var _children: Array[CollisionShape3D] = []


func _ready():
	_update()

func _make_shape(pos:Vector3i) -> CollisionShape3D:
	var shape = CollisionShape3D.new()
	shape.shape = BoxShape3D.new()
	shape.position = Vector3(pos)+Vector3(0.5,0.5,0.5)
	return shape

func _update():
	var i = 0
	for x in _model.get_size().x:
		for y in _model.get_size().y:
			for z in _model.get_size().z:
				var pos: Vector3i = Vector3i(x,y,z)
				if (_model.voxel_at(pos) > 0):
					var do_shape: bool = false
					for neighbour in _surrounding:
						if (_model.voxel_at(pos+neighbour) <= 0):
							do_shape = true
							break
					if do_shape:
						if (i < _children.size()):
							_children[i].shape.position = pos
						else:
							_children.append(_make_shape(pos))
							add_child(_children.back())
						i += 1
	var orphans: Array[int] = []
	while(i < _children.size()):
		orphans.append(i)
		i += 1
	for orphan in orphans:
		var child = _children[orphan]
		remove_child(child)
		_children.remove_at(orphan)
