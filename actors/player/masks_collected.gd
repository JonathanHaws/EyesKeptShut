extends Label

func _process(_delta):
	if Save.data.has("Masks_collected"):
		text = "Leaders Killed: " + str(Save.data["Masks_collected"]) + "/" + str(Mask.masks_needed_for_completion)
