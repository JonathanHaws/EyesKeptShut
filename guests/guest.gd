extends Node3D
@export var mesh: MeshInstance3D
@export var random_gender: bool = true
@export var male_blend: float = 0.0

func _ready():
	var value := male_blend
	if random_gender:
		value = randi() % 2
	mesh.set("blend_shapes/Male", value)
	
