extends Control

func _on_Play_clicked() -> void:
	load_scene("Level")

func _on_Story_clicked() -> void:
	load_scene("Level")

func _on_Credits_clicked() -> void:
	load_scene("Level")

func load_scene(scene_name: String) -> void:
	var scene_url= "res://" + scene_name + ".tscn"
	var res = get_tree().change_scene(scene_url)
