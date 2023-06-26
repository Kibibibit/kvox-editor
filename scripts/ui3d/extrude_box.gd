extends Node
class_name ExtrudeBox

var _normal: Vector3


func remesh(_normal: Vector3, voxels: Array[Voxel]):
	for voxel in voxels:
		print(voxel)
		# Somehow mesh the new thing?
	pass
