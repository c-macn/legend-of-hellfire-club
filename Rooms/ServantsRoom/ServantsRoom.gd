extends "res://Rooms/Room.gd"

onready var Saoirse_spawn_point: Position2D = $SaoirseSpawnPoint
onready var card_piece := $CardPiece
onready var cutscene_trigger := $CutsceneTriggger

func _ready() -> void:
	._ready()
	.spawn_Saoirse(Saoirse_spawn_point.position)
	.set_camera_bounds()
	init_card_piece(GameState.CARD_COLLECTION_STATE.BottomLeft)

func init_card_piece(has_collected_card: bool) -> void:
	if not has_collected_card:
		card_piece.connect("card_collected", self, "init_cutscene_trigger")

func init_cutscene_trigger() -> void:
	#cutscene_trigger.connect("cutscene_start", self, "start_cutscene")
	pass
	
func start_cutscene() -> void:
	pass
