extends Label

func _process(_delta):
	if Save.data.has("play_time"):
		var total_seconds = int(Save.data["play_time"])
		var hours = int(total_seconds / 3600.0)
		var minutes = int((total_seconds % 3600) / 60.0)
		var seconds = total_seconds % 60
		text = "%02d:%02d:%02d" % [hours, minutes, seconds]
	else:
		text = "00:00:00"
