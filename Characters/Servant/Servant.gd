extends KinematicBody2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var tween := $Tween

func _ready() -> void:
	pass
	$AnimationPlayer.play("idle")

func hover_in_position(position_modifier: int) -> void:
	var new_position = Vector2(position.x, position.y + position_modifier)
	tween.interpolate_property(self, "position", position, new_position, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
