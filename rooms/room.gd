extends Node3D
@export var area: Area3D ## Used to tell if this room is intersecting with another 
@export var grid_map: GridMap
@export var entry: Node
@export var door_tile_id: int = 0
@export var wall_tile_id: int = 2

func intersecting_area(area_group_name: String) -> bool:
	var params = PhysicsShapeQueryParameters3D.new()
	params.shape = area.shape_owner_get_shape(0, 0)
	params.transform = area.global_transform
	params.collide_with_areas = true
	params.collide_with_bodies = false
	var space = get_world_3d().direct_space_state
	
	for r in space.intersect_shape(params, 32): 
		if r.collider.is_in_group(area_group_name):
			return true
	return false

func turn_into_dead_end():
	pass
	
	#var exit_count = 0
	#for child in get_children():
		#if child.is_in_group("room_exit"):
			#exit_count += 1
	#
	#
	#for cell in grid_map.get_used_cells_by_item(door_tile_id):
		#var ori = grid_map.get_cell_item_orientation(cell)
		#grid_map.set_cell_item(cell, wall_tile_id, ori)
		#
	#for child in get_children():
		#if child.is_in_group("room_exit"):
			#child.queue_free()
