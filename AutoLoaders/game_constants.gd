extends Node

enum SCENES {
	MAIN_ROOM = 0,
	STORAGE_ROOM = 1,
	HALLWAY_ROOM = 2,
	DEMON_ROOM = 3,
	SERVANTS_ROOM = 4,
	GAME_ROOM = 5
}

var _scenes = ["main_room", "storage_room", "main_hallway_room", "demon_eye_room", "servants_room", "game_room"]

func get_scene_name(scene_index: int) -> String:
	return _scenes[scene_index]
