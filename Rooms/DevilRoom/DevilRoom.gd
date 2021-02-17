extends Node2D

onready var saoirse := $Saoirse

func _ready() -> void:
	saoirse.turn_off_light()
