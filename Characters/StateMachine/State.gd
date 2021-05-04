extends Node
class_name State

signal transition_to_state(next_state_name)

func enter() -> void: 
	pass

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func _on_animation_finished(_anim_name: String) -> void:
	pass
