#TODO make base AREA2D scene
extends Area2D

# The integer value of the scene to transition to. Values are defined in GameConstants
export(int) var scene_to

func _ready() -> void:
	connect("body_entered", self, "_on_Saoirse_entered")
	
func _on_Saoirse_entered(body: KinematicBody2D) -> void:
	if _is_Body_Saoirse(body):
		GameState.update_current_scene(GameConstants.get_scene(scene_to))
		get_tree().change_scene(GameConstants.get_scene(scene_to))

func _is_Body_Saoirse(body: KinematicBody2D) -> bool:
	return body and body.name == "Saoirse"
