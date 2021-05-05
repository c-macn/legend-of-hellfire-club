extends State

export(PackedScene) var infernal_shot

const MAX_SHOTS = 3
const SPEED = 3000

enum BATTLE_STATE {
	INITIAL = 0,
	MIDDLE = 1,
	FINAL = 2
}

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

var velocity := Vector2.ZERO
var timer: Timer
var shot_spawner: Position2D
var shot_count := 0

func enter() -> void:
	shot_spawner = owner.get_node("ShotSpawner")
	timer = owner.get_node("SpellTimer")
	timer.start()
	
	if !timer.is_connected("timeout", self, "_cast_spell"):
		timer.connect("timeout", self, "_cast_spell")


func update(_delta: float) -> void:
	var Saoirse_position = owner.get_Saoirses_position()
	
	if Saoirse_position != Vector2.ZERO:
		shot_spawner.look_at(Saoirse_position)
#		var direction = (Saoirse_position - owner.position).normalized() * 200
#		owner.animated_sprite.play(_get_animation(direction))


func _cast_spell() -> void:
	var shot = infernal_shot.instance()
	owner.add_child(shot)
	shot.transform = shot_spawner.global_transform
	shot.scale = Vector2(1, 0.5)
	shot.reveal()
	
	shot_count += 1
	
	if shot_count % 3 == 0:
		owner.stun() # can't transition to state for some reason
	else:
		owner.phase_out()


func _get_animation(target_velocity: Vector2) -> String:
	var facing_direction = _get_facing_direction(target_velocity)
	
	match facing_direction:
		FACING_DIRECTIONS.DOWN:
			return "walk_back"
		FACING_DIRECTIONS.UP:
			return "walk_forward"
		FACING_DIRECTIONS.LEFT:
			return "walk_left"
		FACING_DIRECTIONS.RIGHT:
			return "walk_right"
		FACING_DIRECTIONS.DIAGONAL_DOWN_LEFT:
			return "walk_down_left"
		FACING_DIRECTIONS.DIAGONAL_DOWN_RIGHT:
			return "walk_down_right"
		FACING_DIRECTIONS.DIAGONAL_UP_LEFT:
			return "walk_up_left"
		FACING_DIRECTIONS.DIAGONAL_UP_RIGHT:
			return "walk_up_right"
		_:
			return "default"


func _get_facing_direction(current_direction: Vector2) -> int:
	var angle = current_direction.angle()
	
	if angle < 0:
		angle += TAU # make the angle positive for simplicity
	
	return int(round(angle / PI * 4)) % 8 # ensure only values between 0 - 7 are returned
