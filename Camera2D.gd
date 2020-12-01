extends Camera2D

# set the boundries of the camera based on a given input e.g TileMap constraints
func set_bounds(left: int, top: int, right: int, bottom: int) -> void:
	limit_top = top
	limit_bottom = bottom
	limit_right = right
	limit_left = left
