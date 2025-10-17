extends Button
@export_file("*.tscn") var start_scene: String

func _ready() -> void:
	connect("pressed", Callable(self, "_on_game_restart_pressed"))

func _on_game_restart_pressed() -> void:
	Save.data.clear()  # clear save data
	get_tree().change_scene_to_file(start_scene)
