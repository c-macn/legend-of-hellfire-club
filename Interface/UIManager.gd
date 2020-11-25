extends CanvasLayer

var is_CardPuzzle_visible: bool = false

onready var card_puzzle: Control = $CardPuzzle

func _ready():
	add_to_group("interface")

func show_cards(card_a_texture: String, card_b_texture: String, winning_card_name: String) -> void:
	if not is_CardPuzzle_visible:
		_set_card_puzzle_visibility(true)
		card_puzzle.set_cards(card_a_texture, card_b_texture, winning_card_name)
	else:
		_set_card_puzzle_visibility(false)

func _set_card_puzzle_visibility(is_visible: bool) -> void:
	card_puzzle.visible = is_visible
	is_CardPuzzle_visible = is_visible
