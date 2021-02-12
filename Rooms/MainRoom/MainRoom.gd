extends "res://Rooms/Room.gd"

enum SPAWN_POINTS {
	STORAGE_ROOM = 0
	MAIN_HALLWAY = 1
	DEMON_ROOM = 2
}

# pulled this value out of me hole
const DEFAULT_SPAWN_POINT := Vector2(546, 1107)

onready var dialouge_container: Control = $CanvasLayer/DialogContainer
onready var spawn_points: Array = $SpawnPoints.get_children()
onready var animation_player: AnimationPlayer = $CutsceneManager
onready var cutscene_triggers: Array = $CutsceneTriggers.get_children()
onready var saoirse: KinematicBody2D = $Saoirse
onready var camera: Camera2D = $Saoirse/Camera2D

func _ready() -> void:
	$CanvasModulate.visible = true
	._ready()
	#.set_camera_bounds()
	setup_cutscene_triggers()

	if GameState.is_world_state_intro():
		play_cutscene("intro")

func determine_spawn_location() -> Vector2:
	var previous_scene = GameState.get_previous_scene()
	
	if previous_scene == GameConstants.get_scene(GameConstants.SCENES.DEMON_ROOM):
		return spawn_points[SPAWN_POINTS.DEMON_ROOM].position
	if previous_scene == GameConstants.get_scene(GameConstants.SCENES.STORAGE_ROOM):
		return spawn_points[SPAWN_POINTS.STORAGE_ROOM].position
	if previous_scene == GameConstants.get_scene(GameConstants.SCENES.HALLWAY_ROOM):
		return spawn_points[SPAWN_POINTS.MAIN_HALLWAY].position
	else:
		return DEFAULT_SPAWN_POINT

func setup_cutscene_triggers() -> void:
	animation_player.connect("animation_finished", self, "_on_Cutscene_finished")
	for trigger in cutscene_triggers:
		trigger.connect("cutscene_start", self, "play_cutscene")

		# For more scalable solution maybe implement feature flag or create custom connect message that take in required parameters and boolean flag
		if trigger.name == "TheHead" && GameState.is_world_state_act_1():
			trigger.disconnect("cutscene_start", self, "play_cutscene")

func play_cutscene(animation_name: String) -> void:
	animation_player.play(animation_name)

func init_dialoge(character_name: String, dialouge_key: String) -> void:
	dialouge_container.on_DialogReceived(character_name, dialouge_key)

func _on_Cutscene_finished(_scene_name: String) -> void:
	get_tree().call_group("actors", "scene_over")

func update_world_state(new_state: int) -> void:
	.update_world_state(new_state)
