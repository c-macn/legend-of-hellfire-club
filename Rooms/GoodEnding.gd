extends Spatial

onready var dialouge_container: Control = $CanvasLayer/DialogContainer
onready var scene_transition := $CanvasLayer/SceneTransition
onready var animation_player := $AnimationPlayer

func _ready() -> void:
	$AudioStreamPlayer3D.play()
	$CanvasLayer.hide_player_ui()
	scene_transition.blink()
	yield(get_tree().create_timer(1.0), "timeout")
	animation_player.connect("animation_finished", self, "_on_animation_changed")
	dialouge_container.connect("dialouge_finished", self, "_on_Dialouge_finished")
	dialouge_container.connect("dialouge_started", self, "_on_Dialouge_started")
	animation_player.play("get_up")


func init_dialouge(character_name: String, dialouge_set: String) -> void:
	dialouge_container.on_DialogReceived(character_name, dialouge_set)


func fade_out() -> void:
	scene_transition.fade_in()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().call_deferred("change_scene", "res://Interface/MainMenu/MainMenu.tscn")


func _on_animation_changed(animation_name: String) -> void:
	if animation_name == "get_up":
		animation_player.play("end_text")


func _on_Dialouge_started() -> void:
	animation_player.stop(false)


func _on_Dialouge_finished() -> void:
	animation_player.play()
