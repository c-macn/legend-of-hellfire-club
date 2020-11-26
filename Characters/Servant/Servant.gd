extends KinematicBody2D

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$AnimationPlayer.play("idle")
