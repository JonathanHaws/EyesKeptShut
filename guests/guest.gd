extends Node3D
@export var mesh: MeshInstance3D
@export var skeleton: Skeleton3D

@export var wearing_target_mask: bool = false
@export var masks_bone_attachment: BoneAttachment3D

#@exportsubgroup
@export var eyes_materials: Array[StandardMaterial3D] = []
@export var skin_materials: Array[StandardMaterial3D] = []
@export var underwear_materials: Array[StandardMaterial3D] = []
@export var undershirt_materials: Array[StandardMaterial3D] = []
@export var socks_materials: Array[StandardMaterial3D] = []

@export var dress_materials: Array[StandardMaterial3D] = []
@export var hair_materials: Array[StandardMaterial3D] = []

@export var random_gender: bool = true
@export var male_blend: float = 0.0 ## 0 is Female 1 is Male

@export var random_hair: bool = true
@export var hair_index: int = -1
@export var female_hair_gltf: Array[PackedScene] = []
@export var male_hair_gltf: Array[PackedScene] = []

@export var female_outfits_gltf: Array[PackedScene] = []
@export var male_outfits_gltf: Array[PackedScene] = []
var hair

func add_skinned_mesh_gltf_to_skeleton(gltf_scene: PackedScene, target_skeleton: Skeleton3D) -> MeshInstance3D:
	if gltf_scene == null: return null
	
	var instance = gltf_scene.instantiate()
	add_child(instance)
	var new_mesh = instance.get_child(0).get_child(0).get_child(0) as MeshInstance3D
	new_mesh.skeleton = target_skeleton.get_path()
	
	new_mesh.mesh = new_mesh.mesh.duplicate()
	
	var old_global_transform = new_mesh.global_transform
	new_mesh.get_parent().remove_child(new_mesh)
	target_skeleton.add_child(new_mesh)
	new_mesh.global_transform = old_global_transform
	instance.queue_free()
	return new_mesh

func set_mesh_material(target_mesh: MeshInstance3D, materials: Array[StandardMaterial3D], slot: int = -1) -> void:
	if target_mesh == null or target_mesh.mesh == null: return
	if materials.size() == 0: return
	var mat = materials[randi() % materials.size()].duplicate()
	if slot >= 0 and slot < target_mesh.mesh.get_surface_count():
		target_mesh.mesh.surface_set_material(slot, mat)
	else:
		for i in range(target_mesh.mesh.get_surface_count()):
			target_mesh.mesh.surface_set_material(i, mat)

func _ready():
	var value := male_blend
	if random_gender:
		value = randi() % 2
	mesh.set("blend_shapes/Male", value)
	male_blend = mesh.get("blend_shapes/Male")
	
	
	set_mesh_material(mesh, eyes_materials, 1)
	set_mesh_material(mesh, skin_materials, 0)
	set_mesh_material(mesh, socks_materials, 2)
	set_mesh_material(mesh, underwear_materials, 2)
	set_mesh_material(mesh, undershirt_materials, 2)
	
	if male_blend == 0.0:
		hair = add_skinned_mesh_gltf_to_skeleton(female_hair_gltf.pick_random(), skeleton)
		
		var female_outfit_mesh = add_skinned_mesh_gltf_to_skeleton(female_outfits_gltf.pick_random(), skeleton)
		set_mesh_material(female_outfit_mesh, dress_materials)
	else:
		#hair = add_skinned_mesh_gltf_to_skeleton(male_hair_gltf.pick_random(), skeleton)
		
		add_skinned_mesh_gltf_to_skeleton(male_outfits_gltf.pick_random(), skeleton)

	if hair: set_mesh_material(hair, hair_materials)
	

	
	var masks = masks_bone_attachment.get_children()
	var normalized_index = Mask.target_index % masks.size() # Normalize inside size of array
	var random_index = randi() % masks.size()
	if random_index == normalized_index:
		random_index = (random_index + 1) % masks.size()
	
	if wearing_target_mask: masks[normalized_index].visible = true
	else: masks[random_index].visible = true
	
	for i in range(masks.size()):
		var mask = masks[i]
		if not mask.visible: mask.queue_free()
	

	for child in masks_bone_attachment.get_children():
		child.set("blend_shapes/Male", male_blend)
	
