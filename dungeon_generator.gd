extends Node3D
@export var starting_rooms: Array[PackedScene] = [] # Scenes where the origin specifies players spawn. 
@export var middle_rooms: Array[PackedScene] = [] # Scenes where origin is a doorway from a previous scene
@export var expansions: int = 5

func get_starting_room() -> Node3D: return starting_rooms[randi() % starting_rooms.size()].instantiate()

func get_middle_room() -> Node3D: return middle_rooms[randi() % middle_rooms.size()].instantiate()
	
func is_area_occupied(area: Area3D) -> bool: #Crucial its instant not relying on awaiting another physics frame
	for a in get_tree().get_nodes_in_group("room_intersecting"):
		if a != area and a.overlaps_area(area):
			return true
	return false
	
func expand():
	for exit in get_tree().get_nodes_in_group("room_exit"):
		
		var new_room = get_middle_room()
		add_child(new_room)
		new_room.global_transform = exit.global_transform
		new_room.rotation_degrees.y += 180
	
		if is_area_occupied(new_room.get_node("Area3D")): # Space already taken.
			new_room.queue_free()	
		else:
			exit.queue_free()
			
func genrate(expansions: int = 3, complete: bool = true):
	for child in get_children(): child.queue_free()
	add_child(get_starting_room())
	for i in range(expansions): #await get_tree().create_timer(1.0).timeout
		expand()	

func _ready():
	genrate(expansions)
	
func _process(_delta):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("clear"):
			genrate(0, false)
		if Input.is_action_just_pressed("expand"):
			expand()
		if Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()
