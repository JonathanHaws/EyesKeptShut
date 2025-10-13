extends Node3D
@export var starting_rooms: Array[PackedScene] = [] # Scenes where the only exit is at the origin and has an exit object
@export var middle_rooms: Array[PackedScene] = [] # 1 is the starting scene 
@export var ending_rooms: Array[PackedScene] = [] 
@export var expansions: int = 5

func get_starting_room() -> Node3D:
	return starting_rooms[randi() % starting_rooms.size()].instantiate()

func get_middle_room() -> Node3D:
	return middle_rooms[randi() % middle_rooms.size()].instantiate()
	
func get_ending_room() -> Node3D:
	return ending_rooms[randi() % ending_rooms.size()].instantiate()

func expand():
	var exits := get_tree().get_nodes_in_group("room_exit")
	for exit in exits:
		if not is_instance_valid(exit): continue
		var new_room = get_middle_room()
		add_child(new_room)
		await get_tree().physics_frame

		if is_instance_valid(exit):
			new_room.global_transform = exit.global_transform
			new_room.rotation_degrees.y += 180
		
			if new_room.intersecting_area("room_intersecting"): # Space already taken.
				new_room.queue_free()
			else:
				exit.queue_free()
	
func complete():
	var exits := get_tree().get_nodes_in_group("room_exit")
	for exit in exits:
		if not is_instance_valid(exit): continue
		var room = exit.get_parent()
		if not is_instance_valid(room): continue
		var new_room = get_ending_room()
		add_child(new_room)
		new_room.global_transform = room.global_transform
		room.queue_free()
	
			
func genrate_dungeon(expansions: int = 3, complete: bool = true):
	for child in get_children(): child.queue_free()
	await get_tree().process_frame
	await get_tree().physics_frame
	
	add_child(get_starting_room())
	

	for i in range(expansions):
		#await get_tree().create_timer(1.0).timeout
		await expand()
	
	if complete: complete()

	#var all_exits = get_tree().get_nodes_in_group("room_exit")
	#print("Total exits after generation:", all_exits.size())

func _ready():
	
	genrate_dungeon(expansions)
	
func _process(_delta):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("clear"):
			genrate_dungeon(0, false)
		if Input.is_action_just_pressed("expand"):
			expand()
		if Input.is_action_just_pressed("complete"):
			complete()
		if Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()
