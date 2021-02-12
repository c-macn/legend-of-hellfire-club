extends "res://Objects/interactable_object.gd"

func _ready() -> void:
	position = GameState.get_box_position()

func _input(_event) -> void:
	._input(_event)

func interact() -> void:
	if player:
		if player.has_method("put_on_disguise"):
			player.put_on_disguise()
			queue_free()
