extends Node

@export var ragdoll_scene: PackedScene
@export var skeleton: Skeleton3D

func _spawn_ragdoll():
	#print('test')
	var r = ragdoll_scene.instantiate()
	#r.global_transform = spawn_transform.global_transform
	get_parent().add_child(r)
	r.global_transform = skeleton.global_transform
	r.physical_bones_start_simulation()
	
