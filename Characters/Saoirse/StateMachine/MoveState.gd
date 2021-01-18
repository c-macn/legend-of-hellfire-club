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
var velocity := Vector2()
var animated_sprite: AnimatedSprite

func enter():
	set_current_speed(speed_walking)
	velocity = Vector2()
	animated_sprite = owner.owner.get_node("AnimatedSprite")

func exit():
	set_current_speed(speed_walking)
	velocity = Vector2()

func handle_input(event: InputEvent):
	return .handle_input(event)

func update(_delta: float) -> void:
	var direction: Vector2 = handle_movement()

	if Input.is_action_pressed("sprint"):
		set_current_speed(speed_running)
	else:
		set_current_speed(speed_walking)

	if not direction == Vector2.ZERO:
		velocity = lerp(velocity, direction * current_speed, acceleration)
		animated_sprite.play(get_animation())
		owner.owner.move_and_slide(velocity)
	else:
		emit_signal("transition_to_state", "idle")

func set_current_speed(speed_value) -> void:
	current_speed = speed_value

func handle_movement() -> Vector2:
	var input: Vector2 = Vector2()

	if Input.is_action_pressed("walk_up"):
		input.y -= 1
	if Input.is_action_pressed("walk_down"):
		input.y += 1
	if Input.is_action_pressed("walk_right"):
		input.x += 1
	if Input.is_action_pressed("walk_left"):
		input.x -= 1

	return input.normalized()

func get_animation() -> String:
	var facing_angle = get_facing_angle()

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

func get_facing_angle() -> int:
	# get the degrees of the current velocity
	var facing_angle = rad2deg(velocity.angle())
	# round to the nearest whole int divisble by 45
	var facing_angle_rounded = int(round(facing_angle / 45) * 45)

	return facing_angle_rounded

func _on_sprite_changed(current_sprite: AnimatedSprite) -> void:
	animated_sprite = current_sprite
