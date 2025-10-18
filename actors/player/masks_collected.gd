extends Label

func _process(_delta):
	if Save.data.has("Masks_collected"):
		text = str(Save.data["Masks_collected"]) + "/" + str(Mask.masks_needed_for_completion)
