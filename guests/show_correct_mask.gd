extends Node
@export var masks: Node3D
@export var wearing_target_mask: bool = false

func _ready():

	var masks = masks.get_children()
	for m in masks: m.visible = false
	
	var normalized_index = Mask.target_index % masks.size() # Normalize inside size of array
	var random_index = randi() % masks.size()
	if random_index == normalized_index:
		random_index = (random_index + 1) % masks.size()
	
	if wearing_target_mask: masks[normalized_index].visible = true
	else: masks[random_index].visible = true
	
	for i in range(masks.size()):
		var mask = masks[i]
		if not mask.visible: mask.queue_free()
	


	
