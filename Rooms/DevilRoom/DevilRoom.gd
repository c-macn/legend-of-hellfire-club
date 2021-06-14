extends Node2D

onready var saoirse := $Saoirse
onready var dialouge_container: Control = $CanvasLayer/DialogContainer
onready var scene_transition := $CanvasLayer/SceneTransition
onready var cultist := $Cultists

func _ready() -> void:
	_init_scene()
	scene_transition.fade_out()
	$AnimationPlayer.play("pre_puzzle")


func start_dialouge(character_name: String, dialouge_key: String) -> void:
	dialouge_container.on_DialogReceived(character_name, dialouge_key)


func _init_scene() -> void:
	$AnimationPlayer.connect("animation_finished", self, "_on_Animation_finsihed")
	dialouge_container.connect("dialouge_started", self, "_on_Dialouge_started")
	dialouge_container.connect("dialouge_finished", self, "_on_Dialouge_finished")
	get_tree().call_group("actors", "disable_movement")
	
	saoirse.turn_off_light()
	cultist.reveal()
	cultist.play_animation("walk_forward")
	yield(get_tree().create_timer(0.5), "timeout")


func _on_Animation_finsihed(animation_name: String) -> void:
	get_tree().call_group("actors", "enable_movement")


func _on_Dialouge_started() -> void:
	$AnimationPlayer.stop(false)


func _on_Dialouge_finished() -> void:
	$AnimationPlayer.play()
