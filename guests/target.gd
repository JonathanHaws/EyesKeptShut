extends Node3D

func _physics_process(_d):
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0: return
	global_position = players[0].global_position
