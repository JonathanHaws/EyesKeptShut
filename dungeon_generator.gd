extends Node3D
@export var starting_rooms: Array[PackedScene] = [] # Scenes where the origin specifies players spawn. 
@export var middle_rooms: Array[PackedScene] = [] # Scenes where origin is a doorway from a previous scene
@export var expansions: int = 5

func get_starting_room() -> Node3D: return starting_rooms[randi() % starting_rooms.size()].instantiate()

func get_middle_room() -> Node3D: return middle_rooms[randi() % middle_rooms.size()].instantiate()
	
func areas_overlap(a: Area3D, b: Area3D) -> bool: # manually check if areas are colliding without waiting 
	var space = PhysicsServer3D.space_create()
	PhysicsServer3D.area_set_space(a.get_rid(), space)
	PhysicsServer3D.area_set_space(b.get_rid(), space)
	var state = PhysicsServer3D.space_get_direct_state(space)

	var params = PhysicsShapeQueryParameters3D.new()
	params.shape_rid = PhysicsServer3D.area_get_shape(a.get_rid(), 0)
	params.transform = a.global_transform
	params.collide_with_areas = true
	params.exclude = [a]

	var intersect = state.intersect_shape(params, 32)
	PhysicsServer3D.free_rid(space)
	#print(intersect)
	return intersect.size() > 0

func is_bounds_occupied(area: Area3D, bounds_group: String = "room_bounds") -> bool:
	for existing_area in get_tree().get_nodes_in_group(bounds_group) as Array[Area3D]:
		if existing_area == area: continue
		if areas_overlap(area, existing_area): return true
	return false
	
func expand():
	var exits = get_tree().get_nodes_in_group("room_exit")
	if exits.size() == 0: return
	var exit = exits[randi() % exits.size()]
	exit.remove_from_group("room_exit")
		
	var new_room = get_middle_room()
	add_child(new_room)
	new_room.global_transform = exit.global_transform
	new_room.rotation_degrees.y += 180

	if is_bounds_occupied(new_room.get_node("Area3D")): # Space already taken.
		new_room.queue_free()
	else:
		exit.queue_free()
	
			
func genrate(expansions: int = 3, complete: bool = true):
	for child in get_children(): child.queue_free()
	add_child(get_starting_room())
	for i in range(expansions): #await get_tree().create_timer(1.0).timeout
		expand()	

func _ready():
	#pass
	genrate(expansions)
	
func _process(_delta):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("clear"):
			genrate(0, false)
		if Input.is_action_just_pressed("expand"):
			expand()
		if Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()
