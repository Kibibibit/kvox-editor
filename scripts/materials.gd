extends Node


var materials: Array[StandardMaterial3D] = [
]
var material_names: Array[String] = [
]

var _emissions_enabled = true

func _ready():
	var material: VoxelMaterial = VoxelMaterial.new()
	material.color = Color.GRAY
	material.emission_energy = 0
	material.metallic = 255
	material.roughness = 30
	materials.append(material.to_standard_material())
	material_names.append("Material 1")
	material.emission_energy = 0
	material.color = Color.DARK_SLATE_GRAY
	material.metallic = 255
	material.roughness = 0
	materials.append(material.to_standard_material())
	material_names.append("Material 2")


func set_emissions_enabled(emissions: bool):
	_emissions_enabled = emissions
	for m in materials:
		m.emission_enabled = emissions
	
func get_emissions_enabled() -> bool:
	return _emissions_enabled
