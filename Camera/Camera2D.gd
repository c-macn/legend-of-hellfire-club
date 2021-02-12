extends Camera2D

# set the boundries of the camera based on a given input e.g TileMap constraints
func set_bounds(map_limits, tile_size) -> void:
	limit_left = map_limits.position.x * tile_size.x
	limit_top = map_limits.position.y * tile_size.y
	limit_right = map_limits.end.x * tile_size.x 
	limit_bottom = map_limits.end.y * tile_size.y
