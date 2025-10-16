extends Node

@export var auto_play: bool = false
@export var audio_players: Array[AudioStreamPlayer] = []

func _ready():
	if auto_play:
		if audio_players.is_empty(): return
		audio_players[randi() % audio_players.size()].play()
		
func _play() -> void:
	audio_players[randi() % audio_players.size()].play()
