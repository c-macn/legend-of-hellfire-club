extends "res://Rooms/Room.gd"

onready var spawn_point: Position2D = $SpawnPoint

func _ready() -> void:
	.spawn_Saoirse(spawn_point.position)
	Saoirse.set_remote_transform($Camera2D.get_path())
