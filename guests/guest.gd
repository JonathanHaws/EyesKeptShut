extends Node3D
@export var mesh: MeshInstance3D
@export var skeleton: Skeleton3D

@export var random_gender: bool = true
@export var male_blend: float = 0.0 ## 0 is Female 1 is Male

@export var random_hair: bool = true
@export var hair_index: int = -1


@export var skin_materials: Array[StandardMaterial3D] = []


@export var dress_materials: Array[StandardMaterial3D] = []
@export var female_dresses_gltf: Array[PackedScene] = []

@export var hair_materials: Array[StandardMaterial3D] = []
@export var female_hair_gltf: Array[PackedScene] = []
@export var male_hair_gltf: Array[PackedScene] = []
var hair

func add_skinned_mesh_gltf_to_skeleton(gltf_scene: PackedScene, skeleton: Skeleton3D) -> MeshInstance3D:
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

func set_mesh_material(mesh: MeshInstance3D, materials: Array[StandardMaterial3D]) -> void:
	if materials.size() == 0:
		return
	for i in mesh.mesh.get_surface_count():
		var mat = materials[randi() % materials.size()].duplicate()
		mesh.mesh.surface_set_material(i, mat)

func _ready():
	var value := male_blend
	if random_gender:
		value = randi() % 2
	mesh.set("blend_shapes/Male", value)
	male_blend = mesh.get("blend_shapes/Male")
	
	set_mesh_material(mesh, skin_materials)
	
	if male_blend == 0.0:
		hair = add_skinned_mesh_gltf_to_skeleton(female_hair_gltf.pick_random(), skeleton)
		
		var dress_mesh = add_skinned_mesh_gltf_to_skeleton(female_dresses_gltf.pick_random(), skeleton)
		set_mesh_material(dress_mesh, dress_materials)

	if hair: set_mesh_material(hair, hair_materials)
	
	
	#hair.queue_free()

	
	#if random_hair:
		#if male_blend == 0.0: hair_index = randi() % female_hair.size()
		#else: hair_index = randi() % male_hair.size()
