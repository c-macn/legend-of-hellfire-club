extends "res://Objects/interactable_object.gd"

export(String) var scene_name

func _input(_event) -> void:
	._input(_event)

func interact() -> void:
	get_tree().change_scene("res://Rooms/" + scene_name + "/" + scene_name + ".tscn")
