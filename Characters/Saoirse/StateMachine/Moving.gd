extends "res://Characters/Saoirse/StateMachine/MoveState.gd"

func enter():
	.set_current_speed(speed_walking)
	velocity = Vector2.ZERO
	animated_sprite = owner.owner.get_node("AnimatedSprite")

func exit():
  .exit()

func handle_input(event: InputEvent):
  return .handle_input(event)

func update(_delta: float) -> void:
  var direction: Vector2 = _handle_movement()

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
  
func _handle_movement() -> Vector2:
  var input: Vector2 = Vector2.ZERO

  if Input.is_action_pressed("walk_up"):
    input.y -= 1
  if Input.is_action_pressed("walk_down"):
    input.y += 1
  if Input.is_action_pressed("walk_right"):
    input.x += 1
  if Input.is_action_pressed("walk_left"):
    input.x -= 1

  return input.normalized()
