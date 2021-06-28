extends Node2D

onready var demon_eye := $DemonEye

func _ready() -> void:
	demon_eye.turn_off_light()
	demon_eye.set_bad_ending_frame()
