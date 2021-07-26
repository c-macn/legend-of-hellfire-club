extends Control

onready var scene_transition = $SceneTransition

func _ready() -> void:
	scene_transition.fade_out()
	yield(scene_transition, "transition_finished")
	$AnimationPlayer.play("play_credits")


func _on_NextButton_pressed():
	scene_transition.transition_to_new_scene("res://Interface/MainMenu/MainMenu.tscn")
