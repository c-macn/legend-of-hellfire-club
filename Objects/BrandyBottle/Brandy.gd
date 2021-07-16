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
			else:
				GameState.set_has_brandy(true)
				
			emit_signal("brandy_collected")
			get_tree().call_group("UI", "hide_player_ui", GameState.get_has_met_cultist(), GameState.get_has_met_cultist(), true)
			queue_free()
