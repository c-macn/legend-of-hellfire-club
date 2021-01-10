extends StaticBody2D

onready var sprite: Sprite = $Sprite

func _ready() -> void:
	pass

func highlight() -> void:
	sprite.material.set_shader_param("outline_color", "#ffffff")

func interact() -> void:
	print("I have been interacted with")
	pass
