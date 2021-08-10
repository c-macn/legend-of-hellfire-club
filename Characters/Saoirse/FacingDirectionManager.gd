extends Node2D

enum FACING_DIRECTIONS {
	RIGHT = 0,
	DIAGONAL_DOWN_RIGHT = 1,
	DOWN = 2,
	DIAGONAL_DOWN_LEFT = 3,
	LEFT = 4
	DIAGONAL_UP_LEFT = 5,
	UP = 6,
	DIAGONAL_UP_RIGHT = 7
}

func get_animation(target_vector: Vector2) -> String:
	var facing_direction = get_facing_direction(target_vector)
	
	match facing_direction:
		FACING_DIRECTIONS.DOWN:
			return "walk_back"
		FACING_DIRECTIONS.UP:
			return "walk_forward"
		FACING_DIRECTIONS.LEFT:
			return "walk_left"
		FACING_DIRECTIONS.RIGHT:
			return "walk_right"
		FACING_DIRECTIONS.DIAGONAL_DOWN_LEFT:
			return "walk_down_left"
		FACING_DIRECTIONS.DIAGONAL_DOWN_RIGHT:
			return "walk_down_right"
		FACING_DIRECTIONS.DIAGONAL_UP_LEFT:
			return "walk_up_left"
		FACING_DIRECTIONS.DIAGONAL_UP_RIGHT:
			return "walk_up_right"
		_:
			return "default"


func get_frame(target_rotation: float) -> int:
	var facing_direction = get_facing_direction_from_rotation(target_rotation)
	
	print("Angle", facing_direction)
	match facing_direction:
		FACING_DIRECTIONS.DOWN:
			return 0
		FACING_DIRECTIONS.UP:
			return 10
		FACING_DIRECTIONS.LEFT:
			return 3
		FACING_DIRECTIONS.RIGHT:
			return 7
		FACING_DIRECTIONS.DIAGONAL_DOWN_LEFT:
			return 3
		FACING_DIRECTIONS.DIAGONAL_DOWN_RIGHT:
			return 7
		FACING_DIRECTIONS.DIAGONAL_UP_LEFT:
			return 13
		FACING_DIRECTIONS.DIAGONAL_UP_RIGHT:
			return 16
		_:
			return 0


func get_facing_direction(target_vector: Vector2) -> int:
	var angle = target_vector.angle()
	
	if angle < 0:
		angle += TAU # make the angle positive for simplicity
	
	return int(round(angle / PI * 4)) % 8 # ensure only values between 0 - 7 are returned


func get_facing_direction_from_rotation(rotation: float) -> int:
	if rotation < 0:
		rotation += TAU
		
	return int(round(rotation / PI * 4)) % 8
