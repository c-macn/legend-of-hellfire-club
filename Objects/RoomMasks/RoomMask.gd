extends Area2D

# Flag to determine if the room is safe (Cultists will dissapear upon entering)
export(bool) var is_safe_area = false

func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")

func banish_cultist() -> void:
	get_tree().call_group("cultist", "banish")

# Abstract functions that will be handled in inherited scenes
func handle_Saoirse_enter(body: KinematicBody2D):
	if is_safe_area:
		banish_cultist()

func handle_Saoirse_exit(body: KinematicBody2D):
	pass

func handle_Body_enter(body: KinematicBody2D):
	pass

func handle_Body_exit(body: KinematicBody2D):
	pass

func _is_Body_Saoirse(body: KinematicBody2D) -> bool:
	return body and body.name == "Saoirse"

func _on_Body_entered(body: KinematicBody2D) -> void:
	if _is_Body_Saoirse(body):
		handle_Saoirse_enter(body)
	else:
		handle_Body_enter(body)

func _on_Body_exited(body: KinematicBody2D) -> void:
	if _is_Body_Saoirse(body):
		handle_Saoirse_exit(body)
	else:
		handle_Body_exit(body)
