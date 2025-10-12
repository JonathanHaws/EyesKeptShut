extends Node3D
@export var rooms: Array[PackedScene] = [] # 1 is the starting scene 

func get_random_room() -> Node3D:
	return rooms[randi() % rooms.size()].instantiate()

func expand():
	var exits := get_tree().get_nodes_in_group("exit")
	#print("Found exits:", exits)
	
	for exit in exits:
		var new_room = get_random_room()
		add_child(new_room)

		new_room.global_transform.origin = exit.global_transform.origin
		new_room.rotation_degrees.y += 180

func _ready():

	add_child(get_random_room())
	
	expand()	
