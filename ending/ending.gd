extends Node3D
@export var trigger_area: Area3D

func _ready():
	trigger_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"): return
	call_deferred("_reload_scene")

func _reload_scene():
	if not Save.data.has("Masks_collected"): Save.data["Masks_collected"] = 0
	Save.data["Masks_collected"] += 1
	Mask.set_random_target()
	get_tree().reload_current_scene()
