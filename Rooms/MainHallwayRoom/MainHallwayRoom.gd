extends "res://Rooms/Room.gd"

enum SPAWN_POINTS {
	SERVANTS_ROOM = 0,
	GAME_ROOM = 1,
	ENTRANCE = 2
}

onready var spawn_points: Array = $SpawnPoints.get_children()

func _ready() -> void:
	._ready()
	.spawn_Saoirse(determine_spawn_point(GameState.get_previous_scene()))
	Saoirse.set_remote_transform($Camera2D.get_path()) 

func determine_spawn_point(previous_scene: int) -> Vector2:	
	if previous_scene == GameConstants.SCENES.MAIN_ROOM:
		return spawn_points[SPAWN_POINTS.ENTRANCE].position
	if previous_scene == GameConstants.SCENES.GAME_ROOM:
		return spawn_points[SPAWN_POINTS.GAME_ROOM].position
	if previous_scene == GameConstants.SCENES.SERVANTS_ROOM:
		return spawn_points[SPAWN_POINTS.SERVANTS_ROOM].position
	
	return spawn_points[SPAWN_POINTS.ENTRANCE].position
