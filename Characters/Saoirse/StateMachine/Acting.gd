extends "res://Characters/StateMachine/State.gd"

func enter() -> void:
	add_to_group("actors")

func scene_over() -> void:
	emit_signal("transition_to_state", "idle")
