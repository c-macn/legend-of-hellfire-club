extends CanvasLayer

var outline_texture = preload("res://Objects/BrandyBottle/BrandyOutline.png")
var brandy_texture = preload("res://Objects/BrandyBottle/BrandyBottle.png")
var blessed_texture = preload("res://Objects/BrandyBottle/BlessedBottle.png")

onready var devil_card := $DevilCard/TextureRect
onready var tween := $DevilCard/Tween

func _ready() -> void:
	var has_met_cultist = GameState.get_has_met_cultist()
	var has_brandy_or_shot = GameState.get_has_brandy() or GameState.get_has_blessed_shot()
#	hide_player_ui(has_met_cultist, has_brandy_or_shot)
	hide_player_ui(false, false)
	$SceneTransition.connect("transition_started", self, "_trigger_dialouge")


func reveal_card() -> void:
	var visible_modulate = Color(devil_card.modulate.r, devil_card.modulate.g, devil_card.modulate.b, 1.0)
	
	tween.interpolate_property(devil_card, "modulate", devil_card.modulate, visible_modulate, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		
	tween.interpolate_callback(self, 0.6, "play_break_away")
	
	tween.start()


func play_break_away() -> void:
	devil_card.play("break-away")


func reveal_puzzle() -> void:
	$CardPuzzle.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$CardPuzzle.reveal_cards()


func hide_player_ui(hide_panel = false, hide_brandy = false) -> void:
	$UIPanel.visible = hide_panel
	
	if GameState.get_has_blessed_shot():
		$UIPanel/TextureRect.texture = blessed_texture
		
	elif GameState.get_has_brandy():
		$UIPanel/TextureRect.texture = brandy_texture
		
	else:
		$UIPanel/TextureRect.texture = outline_texture


func _trigger_dialouge() -> void:
	if GameState._current_scene == GameConstants.SCENES.BOSS_BATTLE:
		$DialogContainer.on_DialogReceived("saoirse", "pre_boss")


func _on_Button_pressed():
	get_tree().reload_scene_from_path("res://Rooms/MainRoom/MainRoom.tscn")
