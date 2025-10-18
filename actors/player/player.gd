extends CharacterBody3D
@export var speed := 3.0
@export var speed_multiplier := 1.0
@export var jump_height := 5.0
@export var sprint_multiplier := 2.0
@export var sens := 0.002
@export var cam : Camera3D
@export var gravity := 9.8

var was_on_floor : bool = true
var ignore_first_was_on_floor : bool = true

@export var fov_lerp := Node

@export var audio_anim: AnimationPlayer

var pitch := 0.0
var mouse_delta := Vector2.ZERO

func die():
	if not Save.data.has("Deaths"):
		Save.data["Deaths"] = 0
	if Save: Save.data["Deaths"] += 1
	if not is_inside_tree(): return
	get_tree().reload_current_scene()

func _ready(): 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta += event.relative

func _physics_process(_d):
		
	# Move Camera
	rotate_y(-mouse_delta.x * sens)
	pitch = clamp(pitch - mouse_delta.y * sens, -1.5, 1.5)
	cam.rotation.x = pitch
	mouse_delta = Vector2.ZERO
		
	var movement_vector = Vector3(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),0,
		int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
		)
		
	if not is_on_floor(): velocity.y -= gravity * _d
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		audio_anim.play("Jump")
		velocity.y = jump_height 
	
	var current_speed = speed * speed_multiplier
	if Input.is_action_pressed("sprint"):
		current_speed *= sprint_multiplier

	velocity.x = (cam.global_transform.basis.x * movement_vector.x + cam.global_transform.basis.z * movement_vector.z).normalized().x * current_speed
	velocity.z = (cam.global_transform.basis.x * movement_vector.x + cam.global_transform.basis.z * movement_vector.z).normalized().z * current_speed
	move_and_slide()
	
	if is_on_floor():
		if velocity.length() > 0.2:
			audio_anim.play("Run")
	
	if movement_vector.length() == 0:
		fov_lerp.target_fov = 80 # Idle
	else:
		if Input.is_action_pressed("sprint"): fov_lerp.target_fov = 90 # Sprint
		else: fov_lerp.target_fov = 85 # Walk
	
	var on_floor_now = is_on_floor()
	
	if ignore_first_was_on_floor and not was_on_floor: #bandaid super annoying bug 
		was_on_floor = true
		ignore_first_was_on_floor = false
		
	if not was_on_floor and on_floor_now:
		audio_anim.play("Land")	
	was_on_floor = on_floor_now

	
