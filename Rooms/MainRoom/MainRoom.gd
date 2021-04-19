extends "res://Rooms/Room.gd"

enum SPAWN_POINTS {
	STORAGE_ROOM = 0
	MAIN_HALLWAY = 1
	DEMON_ROOM = 2
}

# pulled this value out of me hole
const DEFAULT_SPAWN_POINT := Vector2(546, 1107)

onready var spawn_points: Array = $SpawnPoints.get_children()
onready var animation_player: AnimationPlayer = $CutsceneManager
onready var the_head_cutscene_trigger: Area2D  = $CutsceneTriggers/TheHead
onready var saoirse: KinematicBody2D = $Saoirse
onready var camera: Camera2D = $Saoirse/Camera2D
onready var animtion_tree := $AnimationTree

func _ready() -> void:
	._ready()
	yield(scene_transition, "transition_finished")
	#setup_cutscene_triggers()
	dialouge_container.connect("dialouge_finished", self, "_on_Dialouge_finished")
	saoirse.position = determine_spawn_location()
	
	if !saoirse.is_connected("disguise_removed", self, "_on_disguise_removed"): 
		saoirse.connect("disguise_removed", self, "_on_disguise_removed")
		
	if !saoirse.is_connected("banished", self, "_on_banishment"):
		saoirse.connect("banished", self, "_on_banishment")

	# if !GameState.get_cutscene_state("intro"):
	# 	play_cutscene("intro")
	# else:
	saoirse.get_node("Light2D").enabled = true
	saoirse.get_node("Light2D").energy = 1
	$CanvasModulate.modulate = Color(30, 150, 80, 255)

func determine_spawn_location() -> Vector2:
	var previous_scene = GameState.get_previous_scene()
	
	if previous_scene == GameConstants.SCENES.DEMON_ROOM:
		return spawn_points[SPAWN_POINTS.DEMON_ROOM].position
	if previous_scene == GameConstants.SCENES.STORAGE_ROOM:
		return spawn_points[SPAWN_POINTS.STORAGE_ROOM].position
	if previous_scene == GameConstants.SCENES.HALLWAY_ROOM:
		return spawn_points[SPAWN_POINTS.MAIN_HALLWAY].position
	else:
		return DEFAULT_SPAWN_POINT

func setup_cutscene_triggers() -> void:
	if !GameState.get_cutscene_state("theHead"):
		the_head_cutscene_trigger.connect("cutscene_start", self, "play_cutscene")

func play_cutscene(animation_name: String) -> void:
	animtion_tree.active = true
	animtion_tree["parameters/conditions/is_dialouge_finished"] = false
	animtion_tree["parameters/playback"].start(animation_name)

func on_Cutscene_begins() -> void:
	get_tree().call_group("actors", "disable_movement")
	
func on_Cutscene_ended() -> void:
	get_tree().call_group("actors", "enable_movement")

func _on_Dialouge_finished() -> void:
	animtion_tree["parameters/conditions/is_dialouge_finished"] = true
	
func _on_banishment() -> void:
	$CultistSpawner.despawn_cultitst()
