extends Node2D

const TILE_SIZE: int = 64

onready var map: TileMap = $MainLevel
onready var camera: Camera2D = $Saoirse/Camera2D
onready var animation_player: AnimationPlayer = $CutsceneManager
onready var dialouge_container: Control = $CanvasLayer/DialogContainer
onready var cutscene_triggers: Array = $CutsceneTriggers.get_children()

func _ready() -> void:
	$CanvasModulate.visible = true
	setup_cutscene_triggers()
	#play_cutscene("intro")

"""
func _set_camera_bounds(tilemap_cells) -> void:
	var top_left = map.map_to_world(tilemap_cells[0], false)
	var bottom_right = map.map_to_world(tilemap_cells[tilemap_cells.size() - 1], false)

	#camera.set_bounds(top_left.x, top_left.y, bottom_right.x + TILE_SIZE, bottom_right.y + TILE_SIZE)
"""

func setup_cutscene_triggers() -> void:
	for trigger in cutscene_triggers:
		trigger.connect("cutscene_start", self, "play_cutscene")

func play_cutscene(animation_name: String) -> void:
	animation_player.play(animation_name)

func init_dialoge(character_name: String, dialouge_key: String) -> void:
	dialouge_container.on_DialogReceived(character_name, dialouge_key)
