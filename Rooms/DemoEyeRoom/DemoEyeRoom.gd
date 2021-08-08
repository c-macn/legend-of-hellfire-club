extends "res://Rooms/Room.gd"

const CUTSCENE_CAMERA_START_POSITION := Vector2(994, 341)

onready var saoirse: KinematicBody2D = $Saoirse
onready var doomed_rat: KinematicBody2D = $DoomedRat
onready var cutscene_manager: AnimationPlayer = $CutsceneManager
onready var cutscene_camera := $Camera2D
onready var tree = $AnimationTree
onready var room_mask := $DemonEyeRoomMask
onready var remove_box :=  $RemoveBox

func _ready() -> void:
	._ready()
	cutscene_camera.position = CUTSCENE_CAMERA_START_POSITION
	room_mask.connect("soairse_detected", self, "set_target")
	$Exits/Area2D.connect("transition_to_scene", self, "_on_scene_transition")
	$RemoveBox.connect("body_entered", self, "_remove_disguise")
	yield(scene_transition, "transition_finished")
	
	if !GameState.get_cutscene_state("doomedRat"):
		init_cutscene()
	else:
		doomed_rat.queue_free()
		cutscene_camera.current = true
		cutscene_camera.zoom = Vector2(1.6, 1.6)
		$DemonEye.patrol()


func init_cutscene() -> void:
	dialouge_container.connect("dialouge_finished", self, "_on_Dialouge_finished")
	dialouge_container.connect("dialouge_started", self, "_on_Dialouge_started")
	tree.active = true
	tree["parameters/conditions/is_dialouge_finished"] = false
	tree["parameters/playback"].start("pan_to_demon")


func set_target() -> void:
	$DemonEye.set_target($Saoirse)


func init_dialouge(character_name: String, dialouge_key: String) -> void:
	dialouge_container.on_DialogReceived(character_name, dialouge_key, saoirse.is_disguised())


func on_Cutscene_begins() -> void:
	get_tree().paused = true
	get_tree().call_group("UI", "hide_player_ui")


func on_Cutscene_ended() -> void:
	var has_met_cultist = GameState.get_has_met_cultist()
	get_tree().paused = false
	get_tree().call_group("UI", "hide_player_ui", has_met_cultist, has_met_cultist, GameState.get_has_brandy() || GameState.get_has_blessed_shot())


func _on_Dialouge_finished() -> void:
	tree["parameters/conditions/is_dialouge_finished"] = true


func _on_Dialouge_started() -> void:
	tree["parameters/conditions/is_dialouge_finished"] = false


func _on_scene_transition(_scene_arg: int) -> void:
	if $Saoirse.is_disguised() && GameState.CARD_COLLECTION_STATE.get('TopLeft'):
		$Saoirse.take_off_disguise()


func _remove_disguise(body: KinematicBody2D) -> void:
	if GameConstants.is_Saoirse(body):
		var s: Saoirse = body
		if GameState.CARD_COLLECTION_STATE.TopLeft && s.is_disguised():
			s.take_off_disguise()
			$RemoveBox.queue_free()
