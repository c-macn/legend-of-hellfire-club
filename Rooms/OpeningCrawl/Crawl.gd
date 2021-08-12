extends Control

func _ready() -> void:
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("crawl")


func _on_Skip_pressed():
	get_tree().change_scene("res://Rooms/MainRoom/MainRoom.tscn")
