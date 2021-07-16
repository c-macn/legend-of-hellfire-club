extends Control

var losing_card_texture = load("res://Interface/CardPuzzle/seven-diamonds.png")
var original_module_value: Color

onready var card_tween := $CardRevealTween
onready var card_a: TextureRect = $CenterContainer/CardMat/GridContainer/CardA
onready var card_b: TextureRect = $CenterContainer/CardMat/GridContainer/CardB
onready var card_c: AnimatedSprite = $CenterContainer/CardMat/GridContainer/CardC
onready var has_collected_card_pieces = GameState.has_collected_all_cards()
onready var winning_audio := $WinngSound

func _ready() -> void:
	original_module_value = card_a.self_modulate
	card_a.self_modulate = Color.transparent
	card_b.self_modulate = Color.transparent
	card_c.self_modulate = Color.transparent


func reveal_cards() -> void:
	_reveal_card(card_a)
	winning_audio.play()
	yield(card_tween, "tween_completed")
	
	_reveal_card(card_b)
	winning_audio.play()
	yield(card_tween, "tween_completed")
	
	if has_collected_card_pieces:
		_reveal_winning_card()
		winning_audio.play()
		yield(get_tree().create_timer(10), "timeout") # bit of a hack because I'm very tired right now
	else:
		_reveal_losing_card()
		$LosingSound.play()
		yield(get_tree().create_timer(2), "timeout")
	
	self.visible = false
	GameState.has_won_card_came()


func _reveal_card(card) -> void:
	card_tween.interpolate_property(card, "self_modulate", card.self_modulate, original_module_value, 2.0, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	card_tween.start()


func _reveal_losing_card() -> void:
	card_c.play("losing")
	yield(card_c, "animation_finished")
	_reveal_card(card_c)
	yield(card_tween, "tween_completed")


func _reveal_winning_card() -> void:
	card_c.play("default")
	_reveal_card(card_c)
	yield(card_tween, "tween_completed")
	card_c.play("reveal")
