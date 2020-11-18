extends Control

onready var banishment_token_sprite: Resource = preload("res://Interface/banishment_token.png")
onready var banishment_token_containers: Array = $BanishmentTokenContainer.get_children()

func _ready():
	add_to_group("interface")

func add_banishment_token(index: int):
	var banishment_token: TextureRect = banishment_token_containers[index - 1]
	banishment_token.texture = banishment_token_sprite
