extends State
class_name CultistCasting

export(PackedScene) var infernal_shot

const MAX_SHOTS := 3

var shots_cast := 0
var cast_timeout: Timer

enum FACING_DIRECTIONS {
	RIGHT = 0,
	DIAGONAL_DOWN_RIGHT = 1,
	DOWN = 2,
	DIAGONAL_DOWN_LEFT = 3,
	LEFT = 4
	DIAGONAL_UP_LEFT = 5,
	UP = 6,
	DIAGONAL_UP_RIGHT = 7
}

func enter() -> void:
	cast_timeout = owner.get_node("CastTimeout")
	cast_timeout.connect("timeout", self, "_on_Cast_cooldown")
	
	_cast_spell()

func exit() -> void:
	cast_timeout.disconnect("timeout", self, "_on_Cast_cooldown")

func _cast_spell() -> void:
	shots_cast += 1
	
	if shots_cast <= MAX_SHOTS:
		var facing = owner.get_node("FacingManager")
		var shot = infernal_shot.instance()
		owner.add_child(shot)
		owner.get_node("AnimatedSprite").play(facing.get_animation_from_rotation(owner.get_node("ShotSpawner").rotation))
		shot.transform = owner.get_node("ShotSpawner").global_transform
		shot.scale = Vector2(1, 0.5)
		shot.reveal()
		owner.play_shot_sfx()
		owner.cast_timeout.start()
	else:
		shots_cast = 0
		cast_timeout.stop()
		owner.phase_out()

func _on_Cast_cooldown() -> void:
	emit_signal("transition_to_state", "chasing")
