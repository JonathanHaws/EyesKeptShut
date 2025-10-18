extends Label

func _process(_delta):
	if Save.data.has("venge"):
		text = "VENGE: " + str(Save.data["venge"]) 
