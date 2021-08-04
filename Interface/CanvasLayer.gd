extends CanvasLayer

onready var devil_card := $DevilCard/TextureRect
onready var tween := $DevilCard/Tween

func _ready() -> void:
	var has_met_cultist = GameState.get_has_met_cultist()
	hide_player_ui(has_met_cultist, has_met_cultist, GameState.get_has_brandy() || GameState.get_has_blessed_shot())


func reveal_card() -> void:
	var visible_modulate = Color(devil_card.self_modulate.r, devil_card.self_modulate.g, devil_card.self_modulate.b, 1.0)
	
	tween.interpolate_property(devil_card, "self_modulate", devil_card.self_modulate, visible_modulate, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		
	tween.interpolate_callback(self, 0.6, "play_break_away")
	
	tween.start()


func play_break_away() -> void:
	$AudioStreamPlayer.play()
	devil_card.play("break-away")
	yield(devil_card, "animation_finished")
	$AudioStreamPlayer.stop()


func reveal_puzzle() -> void:
	$CardPuzzle.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	$CardPuzzle.reveal_cards()


func hide_player_ui(show_lives = false, show_cards = false, show_brandy = false) -> void:
	$LivesCounter.visible = show_lives
	$CardPieces.visible = show_cards
	$TextureRect.visible = show_brandy
