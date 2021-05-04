extends StateMachine
class_name CultistStateMachine

func _ready() -> void:
	state_map = {
		"idle": $Idle,
		"chasing": $Chasing,
		"casting": $Casting,
		"boss_battle": $BossBattle,
		"stun": $Stun
	}

func _change_state(state_name):
	if not _active:
		return
	._change_state(state_name)
