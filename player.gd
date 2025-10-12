extends CharacterBody3D

@export var speed := 5.0
@export var jump_height := 5.0
@export var sprint_multiplier := 2.0
@export var sens := 0.002
@export var cam : Camera3D
var pitch := 0.0

func _ready(): 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sens)
		pitch = clamp(pitch - event.relative.y * sens, -1.5, 1.5)
		$Camera3D.rotation.x = pitch

func _physics_process(_d):
		
	if Input.is_action_just_pressed("ui_cancel"): get_tree().quit()	
		
	var movement_vector = Vector3(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),0,
		int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
		)
		
	velocity.y -= 9.8 * _d
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height 
			
	var current_speed = speed
	if Input.is_action_pressed("sprint"):
		current_speed *= sprint_multiplier

	velocity.x = (cam.global_transform.basis.x * movement_vector.x + cam.global_transform.basis.z * movement_vector.z).normalized().x * current_speed
	velocity.z = (cam.global_transform.basis.x * movement_vector.x + cam.global_transform.basis.z * movement_vector.z).normalized().z * current_speed
	move_and_slide()
