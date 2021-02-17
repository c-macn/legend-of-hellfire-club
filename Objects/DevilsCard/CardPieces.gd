extends Control

var modulate_opaque := Color(modulate.r, modulate.g, modulate.b, 1)

onready var tween_manager := $Tween
onready var card_container: Sprite = $HBoxContainer/CardContainer

func _ready() -> void:
	add_to_group("interface")
	render_existing_cards(GameState.CARD_COLLECTION_STATE)

func reveal(card_piece_name: String) -> void:
	var card_piece_to_reveal = _get_card_piece(card_piece_name)
	var initial_modulate_value = Color(modulate.r, modulate.g, modulate.b, 0)

	if card_piece_to_reveal != null:
		tween_manager.interpolate_property(card_piece_to_reveal, 'self_modulate', initial_modulate_value, modulate_opaque, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween_manager.start()

func render_existing_cards(card_state: Dictionary) -> void:
	for card in card_state.keys():
		if card_state[card]:
			_set_card_piece_alpha(card)

func _get_card_piece(card_piece_name: String) -> Node:
	if card_piece_name.length() == 0:
		return card_container
	else:
		return card_container.get_node(card_piece_name)

func _set_card_piece_alpha(card_piece_name: String) -> void:
	var card_piece = _get_card_piece(card_piece_name)
	card_piece.self_modulate = modulate_opaque