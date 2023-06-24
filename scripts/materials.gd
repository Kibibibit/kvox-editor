extends Node

signal material_update(material_id: int)

var materials: Array[StandardMaterial3D] = [
]
var voxel_materials: Array[VoxelMaterial] = [
	
]
var material_names: Array[String] = [
]

var _emissions_enabled = true

func update_material(material_id: int, color:Color, roughness:int, metallic:int, emission:int):
	if (material_id < materials.size()):
		var voxel_mat = voxel_materials[material_id]
		voxel_mat.color = color
		voxel_mat.metallic = metallic
		voxel_mat.roughness = roughness
		voxel_mat.emission_energy = emission
		materials[material_id] = voxel_mat.to_standard_material()
		material_update.emit(material_id)

func set_emissions_enabled(emissions: bool):
	_emissions_enabled = emissions
	for m in materials:
		m.emission_enabled = emissions
	
func get_emissions_enabled() -> bool:
	return _emissions_enabled

func add_material():
	voxel_materials.append(VoxelMaterial.new())
	materials.append(voxel_materials.back().to_standard_material())
	material_names.append("New Material")
