extends Node3D
@export var masks: Node3D
@export var wearing_target_mask: bool = false
@export var mask_parent: Node3D
@export var mask_scenes: Array[PackedScene] = []
@export var mask_materials: Array[StandardMaterial3D] = [
	preload("res://actors/guests/masks/materials/mask_1.tres"),
	preload("res://actors/guests/masks/materials/mask_2.tres"),
	preload("res://actors/guests/masks/materials/mask_3.tres"),
	preload("res://actors/guests/masks/materials/mask_4.tres"),
	preload("res://actors/guests/masks/materials/mask_5.tres"),
	preload("res://actors/guests/masks/materials/mask_6.tres"),
	preload("res://actors/guests/masks/materials/mask_7.tres"),
	preload("res://actors/guests/masks/materials/mask_8.tres"),
]
var mask

@export var look_at_modifier: LookAtModifier3D
@export var guest: Node

func _ready():
	if look_at_modifier:
		look_at_modifier.influence = 0.0
		
	await get_tree().physics_frame
	await get_tree().physics_frame

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


	if mask_materials.size() > 0:
		if wearing_target_mask:
			var surface_count = mask.mesh.get_surface_count()
			for i in range(surface_count):

				var mat_index = Mask.random_materials[i] % mask_materials.size()
				#print("Surface ", i, " assigned material: ", Mask.random_materials[i])
				#print("Surface ", i, " assigned material: ", mat_index)
				mask.set_surface_override_material(i, mask_materials[mat_index])
			
		else:
			var surface_count = mask.mesh.get_surface_count()
			for i in range(surface_count):
				mask.set_surface_override_material(i, mask_materials[randi() % mask_materials.size()])
	
	if look_at_modifier:
		look_at_modifier.influence = 1.0

	if guest:
		mask.set("blend_shapes/Male", guest.male_blend)




#func _process(delta):
