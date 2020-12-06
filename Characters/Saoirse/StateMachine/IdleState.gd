extends "res://Characters/StateMachine/State.gd"

func enter() -> void:
	owner.owner.get_node("AnimatedSprite").play("default")

func handle_input(event: InputEvent):
	return .handle_input(event)

func update(_delta: float) -> void:
	if is_moving():
		emit_signal("transition_to_state", "move")

func is_moving() -> bool:
	return Input.is_action_just_pressed("walk_left") or Input.is_action_just_pressed("walk_right") or Input.is_action_just_pressed("walk_up") or Input.is_action_just_pressed("walk_down")

