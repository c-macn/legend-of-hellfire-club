extends Area2D

var is_blessed_bottle = false

signal brandy_collected

func _ready() -> void:
	connect("body_entered", self, "_collected_brandy")
	
func _collected_brandy(body: KinematicBody2D) -> void:
	if (body):
		if GameConstants.is_Saoirse(body):
			if is_blessed_bottle:
				GameState.set_has_blessed_shot(true)

			emit_signal("brandy_collected")
			queue_free()
