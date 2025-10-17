extends Node3D
@export var trigger_area: Area3D
@export var anim: AnimationPlayer
@export var animation: String = "exit"

@export_file("*.tscn") var scene_file: String

func _ready():
	trigger_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"): return
	anim.play(animation)
	
	
func _go_to_next_level():
	call_deferred("_reload_scene")

func _reload_scene():
	if not Save.data.has("Masks_collected"): Save.data["Masks_collected"] = 0
	Save.data["Masks_collected"] += 1
	Mask.set_random_target()
	
	if Save.data["Masks_collected"] >= 1:
		get_tree().change_scene_to_file(scene_file)
	else:
		get_tree().reload_current_scene()
	
