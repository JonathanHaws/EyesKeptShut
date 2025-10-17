extends Node
@export var masks: Node3D
@export var wearing_target_mask: bool = false

func _ready():

	var mask_list = masks.get_children()
	for m in mask_list: m.visible = false
	
	var normalized_index = Mask.target_index % mask_list.size() # Normalize inside size of array
	var random_index = randi() % mask_list.size()
	if random_index == normalized_index:
		random_index = (random_index + 1) % mask_list.size()
	
	if wearing_target_mask: mask_list[normalized_index].visible = true
	else: mask_list[random_index].visible = true
	
	for i in range(mask_list.size()):
		var mask = mask_list[i]
		if not mask.visible: mask.queue_free()
	


	
