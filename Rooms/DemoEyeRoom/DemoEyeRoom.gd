extends "res://Rooms/Room.gd"

onready var saoirse: KinematicBody2D = $Saoirse
onready var doomed_rat: KinematicBody2D = $DoomedRat
onready var cutscene_manager: AnimationPlayer = $CutsceneManager
onready var cutscene_camera := $Camera2D
onready var tree = $AnimationTree
onready var room_mask := $DemonEyeRoomMask

func _ready() -> void:
	._ready()
	room_mask.connect("soairse_detected", self, "set_target")
	yield(scene_transition, "transition_finished")
	
	if !GameState.get_cutscene_state("doomedRat"):
		init_cutscene()
	else:
		doomed_rat.queue_free()
		cutscene_camera.current = true
		cutscene_camera.zoom = Vector2(1.6, 1.6)

func init_cutscene() -> void:
	dialouge_container.connect("dialouge_finished", self, "_on_Dialouge_finished")
	dialouge_container.connect("dialouge_started", self, "_on_Dialouge_started")
	tree.active = true
	tree["parameters/conditions/is_dialouge_finished"] = false
	tree["parameters/playback"].start("pan_to_demon")

func set_target() -> void:
	$DemonEye.set_target($Saoirse)

func init_dialouge(character_name: String, dialouge_key: String) -> void:
	dialouge_container.on_DialogReceived(character_name, dialouge_key, saoirse.is_disguised()) # probably shouldn't reference like this

func on_Cutscene_begins() -> void:
	get_tree().paused = true

func on_Cutscene_ended() -> void:
	get_tree().paused = false

func _on_Dialouge_finished() -> void:
	tree["parameters/conditions/is_dialouge_finished"] = true

func _on_Dialouge_started() -> void:
	tree["parameters/conditions/is_dialouge_finished"] = false
