"""
game_constants.gd

An autoloader script to contain common values for the game in order to avoid human created errors
"""
extends Node

enum SCENES {
	MAIN_ROOM = 0,
	STORAGE_ROOM = 1,
	HALLWAY_ROOM = 2,
	DEMON_ROOM = 3,
	SERVANTS_ROOM = 4,
	GAME_ROOM = 5,
	FINAL_ROOM = 6
}

var _scenes = [
	"res://Rooms/MainRoom/MainRoom.tscn", 
	"res://Rooms/StockRoom/StockRoom.tscn", 
	"res://Rooms/MainHallwayRoom/MainHallwayRoom.tscn", 
	"res://Rooms/DemoEyeRoom/DemoEyeRoom.tscn", 
	"res://Rooms/ServantsRoom/ServantsRoom.tscn", 
	"res://Rooms/GameRoom/GameRoom.tscn"
]

func get_scene(scene_index: int) -> String:
	return _scenes[scene_index]
