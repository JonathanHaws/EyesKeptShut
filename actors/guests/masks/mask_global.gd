extends Node
@export var target_index: int = -1
@export var masks_needed_for_completion: int = 20

func set_random_target():
	target_index = randi()

func _ready():
	Save.data["venge"] = 0
	Save.data["Masks_collected"] = 0
	set_random_target()
