extends Node
@export var target_index: int = -1

func set_random_target():
	target_index = randi()

func _ready():
	set_random_target()
