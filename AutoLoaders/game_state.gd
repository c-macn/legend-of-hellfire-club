"""
game_state.gd 

An autoloader script to track state between scenes for easy data sharing between rooms
"""
extends Node

const CUTSCENE_STATE = {
	intro = false,
	theHead = false,
	doomedRat = false,
	theServant = false
}

const CARD_COLLECTION_STATE = {
	TopLeft = false,
	TopRight = false,
	BottomRight = false,
	BottomLeft = false
}

# previous/current scene is used to determine spawn point in certain levels
var _previous_scene: int setget update_current_scene, get_previous_scene
var _current_scene: int setget update_current_scene

# Used to determine if Saoirse should be in the box
var _is_Saoirse_disguised := false setget set_is_Saoirse_disguised, get_is_Saoirse_disguised

# Used to determine if the cultist should follow Saoirse from room to room
var _is_Cultist_chasing := false setget set_is_Cultist_chasing, get_is_Cultist_chasing

# Used to track the state of the box, is this ideal? <shrug>
var _box_state: Dictionary = {
	"current_scene": GameConstants.SCENES.STORAGE_ROOM,
	"position": Vector2(669.883, 97.831)
}

var _has_brandy := false setget set_has_brandy, get_has_brandy

var _has_blessed_shot_ability := false setget set_has_blessed_shot, get_has_blessed_shot

func update_current_scene(updated_scene: int) -> void:
	_previous_scene = _current_scene
	_current_scene = updated_scene

func get_previous_scene() -> int:
	return _previous_scene

func set_is_Saoirse_disguised(is_disguised: bool) -> void:
	_is_Saoirse_disguised = is_disguised
	
func get_is_Saoirse_disguised() -> bool:
	return _is_Saoirse_disguised

func set_is_Cultist_chasing(is_chasing: bool) -> void:
	_is_Cultist_chasing = is_chasing

func get_is_Cultist_chasing() -> bool:
	return _is_Cultist_chasing

func set_box_state(current_scene: int, position: Vector2)  -> void:
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

# returns a boolean value if the cutscene has already been viewed
func get_cutscene_state(cutscene_name: String) -> bool:
	return CUTSCENE_STATE[cutscene_name]

func update_cutscene_state(cutscene_name: String) -> void:
	CUTSCENE_STATE[cutscene_name] = true

func update_card_state(card_piece: String) -> void:
	CARD_COLLECTION_STATE[card_piece] = true
	get_tree().call_group("interface", "reveal", card_piece)

func is_card_piece_collected(card_piece: String) -> bool:
	return CARD_COLLECTION_STATE[card_piece]

func set_has_brandy(has_brandy: bool) -> void:
	_has_brandy = has_brandy
	
func get_has_brandy() -> bool:
	return _has_brandy
	#return true

func set_has_blessed_shot(has_shot: bool) -> void:
	_has_blessed_shot_ability = has_shot

func get_has_blessed_shot() -> bool:
	return _has_blessed_shot_ability