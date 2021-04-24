"""
	MoveState.gd

	The base state for all common movement needs
"""
extends State
class_name MoveState

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

export(int) var speed_walking = 200
export(int) var speed_running = 250
export(float) var friction = 0.1
export(float) var acceleration = 0.1

var current_speed: int = speed_walking
var velocity := Vector2.ZERO
var animated_sprite: AnimatedSprite

func exit():
	set_current_speed(speed_walking)
	velocity = Vector2.ZERO


func set_current_speed(speed_value) -> void:
	current_speed = speed_value


func get_animation() -> String:
	var facing_direction = get_facing_direction(velocity)
	
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


func get_facing_direction(current_direction: Vector2) -> int:
	var angle = current_direction.angle()
	
	if angle < 0:
		angle += 2 * PI # make the angle positive for simplicity
	
	return int(round(angle / PI * 4)) % 8 # ensure only values between 0 - 7 are returned


func _on_sprite_changed(current_sprite: AnimatedSprite) -> void:
	animated_sprite = current_sprite
