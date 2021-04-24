extends State
class_name CultistCasting

export(PackedScene) var infernal_shot

const MAX_SHOTS := 3

var shots_cast := 0
var cast_timeout: Timer

func enter() -> void:
	cast_timeout = owner.get_node("CastTimeout")
	cast_timeout.connect("timeout", self, "_on_Cast_cooldown")
	
	_cast_spell()

func exit() -> void:
	cast_timeout.disconnect("timeout", self, "_on_Cast_cooldown")

func _cast_spell() -> void:
	shots_cast += 1
	
	if shots_cast <= MAX_SHOTS:
		var shot = infernal_shot.instance()
		owner.add_child(shot)
		shot.transform = owner.get_node("ShotSpawner").global_transform
		shot.scale = Vector2(1, 0.5)
		shot.reveal()
		owner.cast_timeout.start()
	else:
		shots_cast = 0
		cast_timeout.stop()
		owner.phase_out()

func _on_Cast_cooldown() -> void:
	emit_signal("transition_to_state", "chasing")
