extends Control

func _on_Play_clicked() -> void:
	load_scene(GameConstants.SCENES.MAIN_ROOM)

func _on_Story_clicked() -> void:
	load_scene(GameConstants.SCENES.MAIN_ROOM)

func _on_Credits_clicked() -> void:
	load_scene(GameConstants.SCENES.MAIN_ROOM)

func load_scene(scene_index: int) -> void:
	get_tree().change_scene(GameConstants.get_scene(scene_index))
