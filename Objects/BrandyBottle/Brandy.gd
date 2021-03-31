extends Area2D

signal brandy_collected

func _ready() -> void:
	connect("body_entered", self, "_collected_brandy")
	
func _collected_brandy(body: KinematicBody2D) -> void:
	if (body):
		if GameConstants.is_Saoirse(body):
			emit_signal("brandy_collected")
			queue_free()