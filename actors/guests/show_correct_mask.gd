extends Node3D
@export var masks: Node3D
@export var wearing_target_mask: bool = false
@export var mask_parent: Node3D
@export var mask_scenes: Array[PackedScene] = []
@export var mask_materials: Array[StandardMaterial3D] = []
var mask

func _ready():

	if not mask_scenes.size() > 0: return

	var normalized_index = Mask.target_index % mask_scenes.size() # Normalize inside size of array
	var random_index = randi() % mask_scenes.size()
	if random_index == normalized_index:
		random_index = (random_index + 1) % mask_scenes.size()
		
	var final_index
	if wearing_target_mask: final_index = normalized_index
	else: final_index = random_index	

	var mask_gltf = mask_scenes[final_index].instantiate() # Extract mask from gltf scene
	mask = mask_gltf.get_child(0)
	mask_gltf.remove_child(mask)
	mask_gltf.queue_free()
	mask.owner = null
	add_child(mask)
	mask.global_transform = mask_parent.global_transform
	mask.global_transform.basis = global_transform.basis

	if mask_materials.size() > 0:
		if wearing_target_mask:
			var surface_count = mask.mesh.get_surface_count()
			for i in range(surface_count):
				var mat_index = Mask.random_materials[i] % mask_materials.size()
				mask.set_surface_override_material(i, mask_materials[mat_index])
			
		else:
			var surface_count = mask.mesh.get_surface_count()
			for i in range(surface_count):
				mask.set_surface_override_material(i, mask_materials[randi() % mask_materials.size()])
	
