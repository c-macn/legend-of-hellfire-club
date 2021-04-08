extends "res://Rooms/Room.gd"

onready var Saoirse_spawn_point: Position2D = $SaoirseSpawnPoint
onready var card_piece := $CardPiece
onready var cutscene_trigger := $CutsceneTriggger
onready var tree: AnimationTree = $AnimationTree
onready var servant := $Servant

func _ready() -> void:
	.spawn_Saoirse(Saoirse_spawn_point.position)
	.set_camera_bounds()
	init_card_piece(GameState.CARD_COLLECTION_STATE.BottomLeft)
	
func init_card_piece(has_collected_card: bool) -> void:
	if !has_collected_card:
		cutscene_trigger.monitoring = false
		servant.disable_collisions()
		servant.set_frames("res://Characters/Servant/Animations/ServantSkin.tres")
		card_piece.connect("card_collected", self, "init_cutscene_trigger", ["the_servant"])
	else:
		if GameState.get_has_blessed_shot():
			servant.queue_free()
		else:
			servant.visible = true
			servant.enable_collisions()
			servant.set_frames("res://Characters/Servant/Animations/ServantGhost.tres")
			servant.remove_shader()
			init_cutscene_trigger("ask_brandy")
	
func init_cutscene_trigger(cutscene_to_start: String) -> void:
	cutscene_trigger.monitoring = true
	cutscene_trigger.cutscene_animation_name = cutscene_to_start
	cutscene_trigger.connect("cutscene_start", self, "start_cutscene")
	
func start_cutscene(cutscene_name: String) -> void:
	dialouge_container.connect("dialouge_finished", self, "_on_Dialouge_finished")
	dialouge_container.connect("dialouge_started", self, "_on_Dialouge_started")
	tree.active = true
	tree["parameters/conditions/is_dialouge_finished"] = false	
	tree["parameters/playback"].start(cutscene_name)

func on_Cutscene_begins() -> void:
	get_tree().call_group("actors", "disable_movement")
	
func on_Cutscene_ended() -> void:
	get_tree().call_group("actors", "enable_movement")

func _on_Dialouge_finished() -> void:
	tree["parameters/conditions/has_brandy"] = GameState.get_has_brandy()
	tree["parameters/conditions/is_dialouge_finished"] = true

func _on_Dialouge_started() -> void:
	tree["parameters/conditions/is_dialouge_finished"] = false
	
func has_brandy() -> void:
	if GameState.get_has_brandy():
		.init_dialouge("saoirse", "the_servant_has_brandy")
	else:
		.init_dialouge("saoirse", "the_servant_no_brandy")

func add_blessed_shot_bottle() -> void:
	var Brandybottle = load("res://Objects/BrandyBottle/Brandy.tscn")
	var bottle = Brandybottle.instance()
	bottle.modulate.a = 0
	bottle.position = servant.position
	bottle.is_blessed_bottle = true

	var bottle_modulate = Color(bottle.modulate.r, bottle.modulate.g, bottle.modulate.b, 255)
	servant.queue_free()
	add_child(bottle)

	$Tween.interpolate_property(bottle, "modulate", bottle.modulate, bottle_modulate, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	$Tween.start();
