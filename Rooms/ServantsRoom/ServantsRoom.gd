extends "res://Rooms/Room.gd"

onready var Saoirse_spawn_point: Position2D = $SaoirseSpawnPoint
onready var card_piece := $CardPiece
onready var cutscene_trigger := $CutsceneTriggger
onready var animation_player := $AnimationPlayer
onready var servant := $Servant

func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_animation_finished")
	.spawn_Saoirse(Saoirse_spawn_point.position)
	Saoirse.set_remote_transform($Camera2D.get_path())
	init_card_piece(GameState.CARD_COLLECTION_STATE.BottomLeft)
	$TileMap.saoirse_ref = Saoirse

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
			servant.modulate.a = 1
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
	animation_player.play(cutscene_name)


func on_Cutscene_begins() -> void:
	get_tree().call_group("actors", "disable_movement")


func on_Cutscene_ended() -> void:
	get_tree().call_group("actors", "enable_movement")


func _on_Dialouge_finished() -> void:
	animation_player.play()


func _on_Dialouge_started() -> void:
	animation_player.stop(false)


func has_brandy() -> void:
	if GameState.get_has_brandy():
		.init_dialouge("saoirse", "the_servant_has_brandy")
	else:
		.init_dialouge("saoirse", "the_servant_no_brandy")


func add_blessed_shot_bottle() -> void:
	var Brandybottle = load("res://Objects/BrandyBottle/Brandy.tscn")
	var bottle = Brandybottle.instance()
	bottle.modulate.a = 1
	bottle.position = servant.position
	bottle.is_blessed_bottle = true
	
	servant.queue_free()
	add_child(bottle)


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "the_servant":
		animation_player.play("the_servant_burns")
	
	if animation_name == "the_servant_burns":
		if GameState.get_has_brandy():
			animation_player.play("ask_brandy")
		else:
			animation_player.play("servants_end")
	
	if animation_name == "ask_brandy":
		if GameState.get_has_brandy():
			animation_player.play("servant_ritual")
		else:
			animation_player.play("servants_end")
