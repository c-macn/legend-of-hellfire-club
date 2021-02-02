extends "res://Rooms/Room.gd"

onready var Saoirse_spawn_point: Position2D = $SaoirseSpawnPoint

func _ready() -> void:
	.spawn_Saoirse(Saoirse_spawn_point.position)
