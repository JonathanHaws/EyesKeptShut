extends Node

@export var audio_players: Array[AudioStreamPlayer] = []

func _ready():
	if audio_players.is_empty(): return
	audio_players[randi() % audio_players.size()].play()
