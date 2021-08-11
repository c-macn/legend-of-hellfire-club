extends "res://Rooms/Room.gd"

onready var Saoirse_spawn_point: Position2D = $SaoirseSpawnPoint
onready var brandy := $Brandy

func _ready() -> void:
	.spawn_Saoirse(Saoirse_spawn_point.position)
	Saoirse.set_remote_transform($Camera2D.get_path())
	_init_brandy_bottle(GameState.get_has_brandy())
	
func _init_brandy_bottle(has_brandy: bool) -> void:
	if has_brandy:
		brandy.queue_free()
