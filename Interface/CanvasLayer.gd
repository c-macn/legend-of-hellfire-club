extends CanvasLayer

onready var devil_card := $DevilCard/TextureRect
onready var tween := $DevilCard/Tween

func _ready() -> void:
	var has_met_cultist = GameState.get_has_met_cultist()
	var has_brandy_or_shot = GameState.get_has_brandy() or GameState.get_has_blessed_shot()
	hide_player_ui(has_met_cultist, has_brandy_or_shot)


func reveal_card() -> void:
	var visible_modulate = Color(devil_card.self_modulate.r, devil_card.self_modulate.g, devil_card.self_modulate.b, 1.0)
	
	tween.interpolate_property(devil_card, "self_modulate", devil_card.self_modulate, visible_modulate, 0.5,
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
	$UIPanel/TextureRect.visible = hide_brandy
