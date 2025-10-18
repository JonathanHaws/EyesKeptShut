extends Node
@export var target_index: int = -1
@export var random_materials: Array[int] = [1,2,3,4]

@export var masks_needed_for_completion: int = 20

func set_random_target():
	target_index = randi()
	for i in range(4):
		random_materials.append(randi())

func _ready():
	Save.data["venge"] = 0
	Save.data["Masks_collected"] = 0
	set_random_target()
