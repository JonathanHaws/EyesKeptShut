extends Button
@export_file("*.tscn") var mansion_scene_file: String

@export var anim: AnimationPlayer
@export var anim_name: String = "fade_out"

func _ready():
	pressed.connect(Callable(self, "_on_pressed"))

func _on_pressed():
	if anim and anim_name != "":
		anim.play(anim_name)

func _change_scene_to_mansion():
	get_tree().change_scene_to_file(mansion_scene_file)
