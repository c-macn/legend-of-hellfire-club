extends StaticBody2D

onready var head_sprite := $AnimatedSprite

func _ready() -> void: 
	if GameState.has_card():
		remove_card()

# set the frames to no_card
func remove_card() -> void:
	head_sprite.play("no_card")
