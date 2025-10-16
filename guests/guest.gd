extends Node3D
@export var mesh: MeshInstance3D
@export var skeleton: Skeleton3D

@export var random_gender: bool = true
@export var male_blend: float = 0.0 ## 0 is Female 1 is Male

@export var random_hair: bool = true
@export var hair_index: int = -1

@export var dress_colors: Array[Color] = [Color(1,1,1), Color(1,0,0), Color(0,1,0), Color(0,0,1)]
@export var female_dresses_gltf: Array[PackedScene] = []

@export var female_hair_gltf: Array[PackedScene] = []
@export var male_hair_gltf: Array[PackedScene] = []

func add_skinned_mesh_gltf_to_skeleton(gltf_scene: PackedScene, skeleton: Skeleton3D) -> MeshInstance3D:
	var instance = gltf_scene.instantiate()
	add_child(instance)
	var mesh = instance.get_child(0).get_child(0).get_child(0) as MeshInstance3D
	mesh.skeleton = skeleton.get_path()
	
	var old_global_transform = mesh.global_transform
	mesh.get_parent().remove_child(mesh)
	skeleton.add_child(mesh)
	mesh.global_transform = old_global_transform
	instance.queue_free()
	return mesh


func _ready():
	var value := male_blend
	if random_gender:
		value = randi() % 2
	mesh.set("blend_shapes/Male", value)
	male_blend = mesh.get("blend_shapes/Male")
	
	if male_blend == 0.0:
		add_skinned_mesh_gltf_to_skeleton(female_hair_gltf.pick_random(), skeleton)
		var dress_mesh = add_skinned_mesh_gltf_to_skeleton(female_dresses_gltf.pick_random(), skeleton)
		#dress_mesh.modulate = dress_colors[randi() % dress_colors.size()]

	
	#hair.queue_free()

	
	#if random_hair:
		#if male_blend == 0.0: hair_index = randi() % female_hair.size()
		#else: hair_index = randi() % male_hair.size()
