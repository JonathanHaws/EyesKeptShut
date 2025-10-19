extends Node
@export var ragdoll_scene: PackedScene
@export var skeleton: Skeleton3D
var rag_doll

func _spawn_ragdoll():
	#print('test')
	rag_doll = ragdoll_scene.instantiate()
	#r.global_transform = spawn_transform.global_transform
	get_parent().add_child(rag_doll)
	rag_doll.global_transform = skeleton.global_transform
	rag_doll.physical_bones_start_simulation()
	
	
func _freeze_ragdoll():
	rag_doll.active = false
	#if rag_doll == null: return
	#rag_doll.physical_bones_stop_simulation()
	#for b in rag_doll.get_children():
		#if b is PhysicalBone3D: b.freeze = true
