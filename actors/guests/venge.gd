extends Node

@export var venge_increase := 5

func increase_venge():

	Save.data["venge"] += venge_increase
