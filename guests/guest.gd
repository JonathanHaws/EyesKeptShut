extends Node3D
@export var mesh: MeshInstance3D
@export var skeleton: Skeleton3D

@export var random_gender: bool = true
@export var male_blend: float = 0.0 ## 0 is Female 1 is Male

@export var random_hair: bool = true
@export var hair_index: int = -1
@export var female_hair_gltf: Array[PackedScene] = []
@export var male_hair_gltf: Array[PackedScene] = []

func add_skinned_mesh_gltf_to_skeleton(gltf_scene: PackedScene, skeleton: Skeleton3D) -> void:
	var instance = gltf_scene.instantiate()
	add_child(instance)
	var mesh = instance.get_child(0).get_child(0).get_child(0) as MeshInstance3D
	mesh.skeleton = skeleton.get_path()
	
	var old_global_transform = mesh.global_transform
	mesh.get_parent().remove_child(mesh)
	skeleton.add_child(mesh)
	mesh.global_transform = old_global_transform
	instance.queue_free()


func _ready():
	var value := male_blend
	if random_gender:
		value = randi() % 2
	mesh.set("blend_shapes/Male", value)
	
	add_skinned_mesh_gltf_to_skeleton(female_hair_gltf.pick_random(), skeleton)

	
	#hair.queue_free()

	
	#if random_hair:
		#if male_blend == 0.0: hair_index = randi() % female_hair.size()
		#else: hair_index = randi() % male_hair.size()
