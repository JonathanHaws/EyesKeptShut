extends Label

func _process(_delta):
	if Save.data.has("play_time"):
		var total_seconds = int(Save.data["play_time"])
		var hours = total_seconds / 3600
		var minutes = (total_seconds % 3600) / 60
		var seconds = total_seconds % 60
		text = "Time taken: %02d:%02d:%02d" % [hours, minutes, seconds]
	else:
		text = "Time taken: 0s"
