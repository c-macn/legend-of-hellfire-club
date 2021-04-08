extends "res://Characters/StateMachine/State.gd"

func enter() -> void:
	var animation_player = owner.owner.get_node("AnimatedSprite")
	var current_animation = animation_player.get_animation()
	
	if current_animation != "default":
		animation_player.play("idle_" + current_animation)
	else:
		animation_player.play("default")

func handle_input(event: InputEvent):
	return .handle_input(event)

func update(_delta: float) -> void:
	if is_moving():
		emit_signal("transition_to_state", "move")

func is_moving() -> bool:
	return Input.is_action_just_pressed("walk_left") or Input.is_action_just_pressed("walk_right") or Input.is_action_just_pressed("walk_up") or Input.is_action_just_pressed("walk_down")

