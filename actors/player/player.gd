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
@export var gun_audio_anim: AnimationPlayer

@export var max_ammo := 3
@export var shot_speed := 0.2
@export var reload_time := 1.5
@export var bullet_scene: PackedScene
@export var shoot_point: Node3D
var ammo := max_ammo
var reloading := false
var can_shoot := true
var shot_timer := Timer.new()
var reload_timer := Timer.new()

func gun_ready():

	if not Save.data.has("max_ammo"): Save.data["max_ammo"] = max_ammo
	else: max_ammo = Save.data["max_ammo"]
	ammo = max_ammo

	if not Save.data.has("reload_time"): Save.data["reload_time"] = reload_time
	else: reload_time = Save.data["reload_time"]
	
	if not Save.data.has("shot_speed"): Save.data["shot_speed"] = shot_speed
	else: shot_speed = Save.data["shot_speed"]
	
	for t in [shot_timer, reload_timer]: add_child(t); t.one_shot = true
	shot_timer.timeout.connect(func(): can_shoot = true)
	reload_timer.timeout.connect(func(): ammo = max_ammo; reloading = false)

func shoot():
	if not can_shoot or reloading or ammo <= 0: return
	ammo -= 1; can_shoot = false
	var b = bullet_scene.instantiate()
	b.global_transform = shoot_point.global_transform
	get_tree().current_scene.add_child(b)
	gun_audio_anim.play("Shoot")
	shot_timer.start(shot_speed)
	if ammo <= 0:
		reloading = true
		gun_audio_anim.queue("Reload")
		reload_timer.start(reload_time)

var pitch := 0.0
var mouse_delta := Vector2.ZERO


func die():
	if not Save.data.has("Deaths"):
		Save.data["Deaths"] = 0
	if Save: Save.data["Deaths"] += 1
	if not is_inside_tree(): return
	get_tree().reload_current_scene()

func _ready(): 
	gun_ready()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta += event.relative

func _physics_process(_d):
		
	if Input.is_action_just_pressed("shoot"):
		if bullet_scene and shoot_point: shoot()
		
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

	
