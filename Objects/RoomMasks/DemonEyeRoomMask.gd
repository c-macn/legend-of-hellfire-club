extends "res://Objects/RoomMasks/RoomMask.gd"

func handle_Saoirse_enter(body: KinematicBody2D) -> void:
	.handle_Saoirse_enter(body)

	if body.is_disguised():
		print("Safe")
	else:
		print("Danger")
