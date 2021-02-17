extends "res://Objects/RoomMasks/RoomMask.gd"

signal soairse_detected

func handle_Saoirse_enter(body: KinematicBody2D) -> void:
	.handle_Saoirse_enter(body)

	if not body.is_disguised():
		emit_signal("soairse_detected")
