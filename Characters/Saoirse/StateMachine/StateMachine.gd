extends "res://Characters/StateMachine/StateMachine.gd"

func _ready() -> void:
	state_map = {
		"idle": $Idle,
		"move": $Move,
		"acting": $Acting
	}

func _change_state(state_name):
	if not _active:
		return
	._change_state(state_name)

func _input(event: InputEvent) -> void:
	current_state.handle_input(event)
