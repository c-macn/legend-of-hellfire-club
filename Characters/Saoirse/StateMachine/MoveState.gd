"""
	MoveState.gd

	The base state for all common movement needs
"""
extends "res://Characters/StateMachine/State.gd"

enum FACING_VALUES {
	UP = -90,
	DOWN = 90,
	LEFT = 180,
	RIGHT = 0,
	DIAGONAL_UP_LEFT = -135,
	DIAGONAL_UP_RIGHT = -45,
	DIAGONAL_DOWN_LEFT = 135,
	DIAGONAL_DOWN_RIGHT = 45
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

func handle_input(event: InputEvent):
	return .handle_input(event)

# move to subclass
func update(delta: float) -> void:
	.update(delta)

func set_current_speed(speed_value) -> void:
	current_speed = speed_value

func get_animation() -> String:
	var facing_angle = _get_facing_angle()

	# always convert to positive, TODO investigate why this is sometimes NEGATIVE
	if facing_angle == -FACING_VALUES.LEFT:
		facing_angle = FACING_VALUES.LEFT

	match facing_angle:
		FACING_VALUES.DOWN:
			return "walk_back"
		FACING_VALUES.UP:
			return "walk_forward"
		FACING_VALUES.LEFT:
			return "walk_left"
		FACING_VALUES.RIGHT:
			return "walk_right"
		FACING_VALUES.DIAGONAL_DOWN_LEFT:
			return "walk_down_left"
		FACING_VALUES.DIAGONAL_DOWN_RIGHT:
			return "walk_down_right"
		FACING_VALUES.DIAGONAL_UP_LEFT:
			return "walk_up_left"
		FACING_VALUES.DIAGONAL_UP_RIGHT:
			return "walk_up_right"
		_:
			return "default"

func _get_facing_angle() -> int:
	# get the degrees of the current velocity
	var facing_angle = rad2deg(velocity.angle())
	# round to the nearest whole int divisble by 45
	var facing_angle_rounded = int(round(facing_angle / 45) * 45)

	return facing_angle_rounded

func _on_sprite_changed(current_sprite: AnimatedSprite) -> void:
	animated_sprite = current_sprite
