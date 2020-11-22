extends Control

var is_visible: bool = false
var winning_card_name: String = ""

onready var cards: Array = $CardContainer.get_children()
onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	add_to_group("interface")
	_set_cards_to_opaque()

func set_cards(CardA_texture: String, CardB_texture: String, WinningCard_name: String) -> void:
	winning_card_name = WinningCard_name
  _set_cards_to_opaque(cards)
	_set_card_texture(cards[0], CardA_texture)
	_set_card_texture(cards[1], CardB_texture)
	animation_player.play("AnimateCards")

# make an attempt at solving the puzzle
func attempt_card(WinningCard_texture: String) -> void:
	var card_name = WinningCard_texture.split('.')[0];
	_set_card_texture(cards[2], WinningCard_texture)
	animation_player.play("AnimateMissing")

	if _has_solved(winning_card_name, card_name):
		print("You are winnah")

func _set_cards_to_opaque() -> void:
	for card in cards:
		card.modulate.a = 0

func _set_card_texture(card_node: TextureRect, texture: String) -> void: 
	card_node.texture = load("res://Puzzles/Cards/" + texture + ".png")

func _has_solved(winning_name: String, attempt_name: String) -> bool: 
  return winning_name == attempt_name