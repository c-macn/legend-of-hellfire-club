extends Node

var Saoirse_scene = preload("res://Characters/Saoirse/Saoirse.tscn")

func spawn_Saoirse(spawn_point) -> void:
	var Saoirse = Saoirse_scene.instance()
	Saoirse.position = spawn_point
	add_child(Saoirse)
