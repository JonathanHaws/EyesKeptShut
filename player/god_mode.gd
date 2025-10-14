extends Node
@export var player: Node
@export var cam: Camera3D
@export var speed := 10.0

var god_mode: bool = false
var old_player_position: Vector3

func _ready():
	if not OS.is_debug_build(): queue_free()

func _physics_process(_delta):
	
	if Input.is_action_just_pressed("god_mode") and player:
		god_mode = !god_mode
		if god_mode:
			player.set_collision_layer(0)
			player.set_collision_mask(0)
		else:
			player.set_collision_layer(1)
			player.set_collision_mask(1)
	
	if god_mode:
		player.velocity = Vector3.ZERO
		player.global_position = old_player_position
		
		var movement_vector = Vector3(
			int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),0,
			int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
			)
		
		var fly_dir = cam.global_transform.basis * movement_vector
		player.global_position += fly_dir * speed * _delta
		
		old_player_position = player.global_position
