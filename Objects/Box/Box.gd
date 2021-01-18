extends "res://Objects/interactable_object.gd"

const X_POSITION_OFFSET: int = 50
var is_active := false

func _input(_event) -> void:
	._input(_event)
	if Input.is_action_just_pressed("obj_interact") and is_active:
		_reset_box()
		player.take_off_disguise()

func interact() -> void:
	if player:
		if player.has_method("put_on_disguise"):
			player.put_on_disguise()
			visible = false
			is_active = true

func _reset_box() -> void:
	position = player.global_position
	position.x = position.x + X_POSITION_OFFSET
	visible = true
