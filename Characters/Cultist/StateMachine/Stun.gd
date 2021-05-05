extends State
class_name Stun

func enter() -> void:
	print("STUNNAH")
	owner.get_node("AnimationPlayer").play("stunned")
	yield(get_tree().create_timer(3,0), "timeout")
	owner.phase_out()
	emit_signal("change_state", "idle")
