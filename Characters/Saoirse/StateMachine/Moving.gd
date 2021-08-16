extends MoveState

func enter():
	.set_current_speed(speed_walking)
	velocity = Vector2.ZERO
	animated_sprite = owner.owner.get_node("AnimationPlayer")


func exit():
	.exit()


func handle_input(event: InputEvent):
	return .handle_input(event)


func update(_delta: float) -> void:
	var direction: Vector2 = _handle_movement()
	
	if Input.is_action_pressed("sprint"):
		set_current_speed(speed_running)
		animated_sprite.playback_speed = 1.5
	else:
		set_current_speed(speed_walking)
		animated_sprite.playback_speed = 1.0
		 
	if not direction == Vector2.ZERO:
		var animation_name = "box_" + get_animation() if GameState.get_is_Saoirse_disguised() else get_animation()
		velocity = lerp(velocity, direction * current_speed, acceleration)
		animated_sprite.play(animation_name)
		owner.owner.move_and_slide(velocity)
	else:
		emit_signal("transition_to_state", "idle")


func _handle_movement() -> Vector2:
	var input: Vector2 = Vector2.ZERO
	
	if !owner.owner.is_movement_disabled:
		if Input.is_action_pressed("walk_up"):
			input.y -= 1
		if Input.is_action_pressed("walk_down"):
			input.y += 1
		if Input.is_action_pressed("walk_right"):
			input.x += 1
		if Input.is_action_pressed("walk_left"):
			input.x -= 1
	return input.normalized()
