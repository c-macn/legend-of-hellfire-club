"""
game_state.gd 

An autoloader script to track state between scenes for easy data sharing between rooms
"""
extends Node

# previous/current scene is used to determine spawn point in certain levels
var _previous_scene = null setget update_current_scene, get_previous_scene
var _current_scene =  GameConstants.get_scene(GameConstants.SCENES.MAIN_ROOM) setget update_current_scene

# Used to determine if Saoirse should be in the box
var _is_Saoirse_disguised := false setget set_is_Saoirse_disguised, get_is_Saoirse_disguised

# Used to determine if the cultist should follow Saoirse from room to room
var _is_Cultist_chasing := false setget set_is_Cultist_chasing, get_is_Cultist_chasing

# Used to track the state of the box
var _box_state: Dictionary = {
	"current_scene": GameConstants.get_scene(GameConstants.SCENES.STORAGE_ROOM),
	"position": Vector2(669.883, 97.831)
}

func update_current_scene(updated_scene) -> void:
	_previous_scene = _current_scene
	_current_scene = updated_scene

func get_previous_scene():
	print(typeof(_previous_scene))
	return _previous_scene

func set_is_Saoirse_disguised(is_disguised: bool) -> void:
	_is_Saoirse_disguised = is_disguised
	
func get_is_Saoirse_disguised() -> bool:
	return _is_Saoirse_disguised

func set_is_Cultist_chasing(is_chasing: bool) -> void:
	_is_Cultist_chasing = is_chasing

func get_is_Cultist_chasing() -> bool:
	return _is_Cultist_chasing
