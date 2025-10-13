extends Node3D
@export var area: Area3D ## Used to tell if this room is intersecting with another 
@export var grid_map: GridMap

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
