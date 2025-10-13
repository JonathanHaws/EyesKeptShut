extends Node3D
@export var starting_room: PackedScene
@export var random_rooms: Array[PackedScene] = [] # 1 is the starting scene 

func get_random_room() -> Node3D:
	return random_rooms[randi() % random_rooms.size()].instantiate()

func expand():
	var exits := get_tree().get_nodes_in_group("room_exit")
	
	for exit in exits:
		var new_room = get_random_room()
		add_child(new_room)

		new_room.global_transform = exit.global_transform
		new_room.rotation_degrees.y += 180
		
		var valid = not new_room.intersecting_area("room_intersecting"); #print(valid)
		

		if valid:
			
			exit.remove_from_group("room_exit")
			
			for child in new_room.get_children():
				if child.is_in_group("room_exit"):
					child.remove_from_group("room_exit")
					break  
			
		else:
			new_room.queue_free()
			
			
func genrate_dungeon():
	for child in get_children(): child.queue_free()
	await get_tree().process_frame
	await get_tree().physics_frame
	
	var new_room = get_random_room()
	add_child(new_room)
	
	
	
	for i in range(3):
		await get_tree().create_timer(1.0).timeout
		await expand()

	#var all_exits = get_tree().get_nodes_in_group("room_exit")
	#print("Total exits after generation:", all_exits.size())

func _ready():
	genrate_dungeon()
	
func _process(_delta):
	if OS.is_debug_build() and Input.is_action_just_pressed("restart"):
		genrate_dungeon()
