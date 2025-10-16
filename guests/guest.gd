extends Node3D
@export var mesh: MeshInstance3D
@export var skeleton: Skeleton3D

#@exportsubgroup
@export var skin_materials: Array[StandardMaterial3D] = []
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

func add_skinned_mesh_gltf_to_skeleton(gltf_scene: PackedScene, skeleton: Skeleton3D) -> MeshInstance3D:
	if gltf_scene == null: return null
	
	var instance = gltf_scene.instantiate()
	add_child(instance)
	var mesh = instance.get_child(0).get_child(0).get_child(0) as MeshInstance3D
	mesh.skeleton = skeleton.get_path()
	
	mesh.mesh = mesh.mesh.duplicate()
	
	var old_global_transform = mesh.global_transform
	mesh.get_parent().remove_child(mesh)
	skeleton.add_child(mesh)
	mesh.global_transform = old_global_transform
	instance.queue_free()
	return mesh

func set_mesh_material(mesh: MeshInstance3D, materials: Array[StandardMaterial3D], slot: int = -1) -> void:
	if mesh == null or mesh.mesh == null: return
	if materials.size() == 0: return
	var mat = materials[randi() % materials.size()].duplicate()
	if slot >= 0 and slot < mesh.mesh.get_surface_count():
		mesh.mesh.surface_set_material(slot, mat)
	else:
		for i in range(mesh.mesh.get_surface_count()):
			mesh.mesh.surface_set_material(i, mat)

func _ready():
	var value := male_blend
	if random_gender:
		value = randi() % 2
	mesh.set("blend_shapes/Male", value)
	male_blend = mesh.get("blend_shapes/Male")
	
	set_mesh_material(mesh, skin_materials, 0)
	
	if male_blend == 0.0:
		hair = add_skinned_mesh_gltf_to_skeleton(female_hair_gltf.pick_random(), skeleton)
		
		var female_outfit_mesh = add_skinned_mesh_gltf_to_skeleton(female_outfits_gltf.pick_random(), skeleton)
		set_mesh_material(female_outfit_mesh, dress_materials)
	else:
		hair = add_skinned_mesh_gltf_to_skeleton(male_hair_gltf.pick_random(), skeleton)
		
		add_skinned_mesh_gltf_to_skeleton(male_outfits_gltf.pick_random(), skeleton)

	if hair: set_mesh_material(hair, hair_materials)
	
	
