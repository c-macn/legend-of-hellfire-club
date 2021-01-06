extends "res://Characters/StateMachine/State.gd"

func enter() -> void:
	add_to_group("actors")
	owner.owner.get_node("AnimatedSprite").play("default") # bad??

func scene_over() -> void:
	emit_signal("transition_to_state", "idle")
