extends Node

signal material_update(material_id: int)
signal material_delete(material_id: int)

var materials= {
}
var voxel_materials = {
}
var material_names = {
}

func update_material(material_id: int, color:Color, roughness:int, metallic:int, emission:int):
	if (materials.has(material_id)):
		var voxel_mat = voxel_materials[material_id]
		voxel_mat.color = color
		voxel_mat.metallic = metallic
		voxel_mat.roughness = roughness
		voxel_mat.emission_energy = emission
		materials[material_id] = voxel_mat.to_standard_material()
		material_update.emit(material_id)

func add_material():
	var new_id: int = 0
	while (materials.has(new_id)):
		new_id += 1
	voxel_materials[new_id] = VoxelMaterial.new()
	materials[new_id] = voxel_materials[new_id].to_standard_material()
	material_names[new_id] = "Material %s" % new_id

func delete_material(material_id: int):
	if (materials.has(material_id)):
		
		voxel_materials.erase(material_id)
		materials.erase(material_id)
		material_names.erase(material_id)
		material_delete.emit(material_id)
