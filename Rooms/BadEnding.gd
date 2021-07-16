extends Node2D

onready var demon_eye := $DemonEye
onready var scene_transition := $CanvasLayer/SceneTransition

func _ready() -> void:
	$CanvasLayer.hide_player_ui()
	$AnimationPlayer.connect("animation_finished", self, "_animation_finished")
	$AudioStreamPlayer2D.play()
	scene_transition.fade_out()
	demon_eye.turn_off_light()
	demon_eye.set_bad_ending_frame()
	yield(get_tree().create_timer(2.0), "timeout")
	$AnimationPlayer.play("bad_ending")


func _animation_finished(animation_name: String) -> void:
	if animation_name == "bad_ending":
		scene_transition.fade_in()
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().call_deferred("change_scene", "res://Interface/MainMenu/MainMenu.tscn")
