"""
game_state.gd 

An autoloader script to track state between scenes for easy data sharing between rooms
"""
extends Node

enum WORLD_STATE {
	INTRO = 0,
	ACT_1 = 1,
	ACT_2 = 2
}

var _current_world_state = WORLD_STATE.INTRO setget set_world_state, get_world_state

# previous/current scene is used to determine spawn point in certain levels
var _previous_scene: String setget update_current_scene, get_previous_scene
var _current_scene: String = GameConstants.get_scene(GameConstants.SCENES.MAIN_ROOM) setget update_current_scene

# Used to determine if Saoirse should be in the box
var _is_Saoirse_disguised := false setget set_is_Saoirse_disguised, get_is_Saoirse_disguised

# Used to determine if the cultist should follow Saoirse from room to room
var _is_Cultist_chasing := false setget set_is_Cultist_chasing, get_is_Cultist_chasing

# Used to track the state of the box, is this ideal? <shrug>
var _box_state: Dictionary = {
	"current_scene": GameConstants.get_scene(GameConstants.SCENES.STORAGE_ROOM),
	"position": Vector2(669.883, 97.831)
}

func set_world_state(new_world_state: int) -> void:
	_current_world_state = new_world_state

func get_world_state() -> int:
	return _current_world_state

func update_current_scene(updated_scene: String) -> void:
	_previous_scene = _current_scene
	_current_scene = updated_scene

func get_previous_scene() -> String:
	return _previous_scene

func set_is_Saoirse_disguised(is_disguised: bool) -> void:
	_is_Saoirse_disguised = is_disguised
	
func get_is_Saoirse_disguised() -> bool:
	return _is_Saoirse_disguised

func set_is_Cultist_chasing(is_chasing: bool) -> void:
	_is_Cultist_chasing = is_chasing

func get_is_Cultist_chasing() -> bool:
	return _is_Cultist_chasing

func set_box_state(current_scene: String, position: Vector2)  -> void:
	_box_state.clear()
	_box_state = {
		"current_scene": current_scene,
		"position": position
	}

func get_box_position() -> Vector2:
	if _box_state.get("current_scene") == _current_scene:
		return _box_state.get("position")
	else:
		return Vector2.ZERO

func is_world_state_intro() -> bool:
	return _current_world_state == WORLD_STATE.INTRO

func is_world_state_act_1() -> bool:
	return _current_world_state == WORLD_STATE.ACT_1

func is_world_state_act_2() -> bool:
	return _current_world_state == WORLD_STATE.ACT_2