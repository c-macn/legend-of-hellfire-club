extends Area2D

signal card_collected

export(String) var card_piece_name
export(Texture) var card_piece_texture

onready var card_sprite := $Sprite

func _ready() -> void:
	if GameState.is_card_piece_collected(card_piece_name):
		queue_free()
	else:
		card_sprite.texture = card_piece_texture
		connect("body_entered", self, "_on_Saoirse_entered")

func _on_Saoirse_entered(body: KinematicBody2D) -> void:
	if body and body.name == "Saoirse":
		GameState.update_card_state(card_piece_name)
		queue_free()
		emit_signal("card_collected")
