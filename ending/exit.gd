extends Node3D
@export var trigger_area: Area3D
@export var anim: AnimationPlayer
@export var animation: String = "exit"

@export_file("*.tscn") var skill_tree_scene_file: String
@export_file("*.tscn") var ending_scene_file: String

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
	
	if Save.data["Masks_collected"] >= Mask.masks_needed_for_completion:
		get_tree().change_scene_to_file(ending_scene_file)
	else:
		get_tree().change_scene_to_file(skill_tree_scene_file)
	
