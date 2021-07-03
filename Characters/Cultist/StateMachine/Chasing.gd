extends State
class_name CultistChasing

const SPEED := 100
const STEER_FORCE := 20.0

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
var animated_sprite: AnimatedSprite
var shot_spawner: Position2D
var detection_timer: Timer
var banishment_area: Area2D
var is_navigating := false
var path_to_Saoirse: PoolVector2Array

func enter() -> void:
	animated_sprite = owner.get_node("AnimatedSprite")
	shot_spawner = owner.get_node("ShotSpawner")
	banishment_area = owner.get_node("BanishmentArea")
	detection_timer = owner.get_node("DetectionTimer")
	
	banishment_area.connect("body_entered", self, "_on_Banish_entered")
	banishment_area.connect("body_exited", self, "_on_Banish_exited")
	detection_timer.connect("timeout", self, "_on_Detection_timeout")


func exit() -> void:
	velocity = Vector2.ZERO
	is_navigating = false
	path_to_Saoirse = []
	banishment_area.disconnect("body_entered", self, "_on_Banish_entered")
	banishment_area.disconnect("body_exited", self, "_on_Banish_exited")
	detection_timer.disconnect("timeout", self, "_on_Detection_timeout")


func update(delta: float) -> void:
	if owner.get_parent().has_method("get_Saoirses_position"):
		var Saoirse_current_position = owner.get_parent().get_Saoirses_position()
		_navigate_to_Saoirse(delta, Saoirse_current_position)
		_target_Saoirse(Saoirse_current_position)
	animated_sprite.play(_get_animation())

func _navigate_to_Saoirse(delta: float, Saoirse_position: Vector2) -> void:
	if owner.get_is_on_wall() or is_navigating:
		var distance_to_Saoirse = owner.global_position.distance_to(Saoirse_position)
		
		if path_to_Saoirse.size() == 0:
			is_navigating = true
			if distance_to_Saoirse <= 2:
				emit_signal("transition_to_state", "casting")
			else:
				path_to_Saoirse = _get_path_to_Saoirse(Saoirse_position)
			
		var distance_to_point = owner.global_position.distance_to(path_to_Saoirse[0])
		
		velocity = (path_to_Saoirse[0] - owner.global_position).normalized() * SPEED
		
		if distance_to_Saoirse <= 10:
			is_navigating = false
			path_to_Saoirse = []
		else:
			if distance_to_point < 5:
				path_to_Saoirse.remove(0)
				if path_to_Saoirse.size() == 1:
					is_navigating = false
					path_to_Saoirse = []
					
	else:
		velocity += _seek_Saoirse(Saoirse_position) * delta
		
	velocity = velocity.clamped(SPEED)
	owner.move_and_slide(velocity)


func _get_path_to_Saoirse(Saoirse_position: Vector2) -> PoolVector2Array:
	var path = owner.navigation.get_simple_path(owner.global_position, Saoirse_position, false)
	owner.debug_line.points = path
	return path


func _seek_Saoirse(Saoirse_position: Vector2) -> Vector2:
	var steer = Vector2.ZERO
	
	var desired_direction = (Saoirse_position - owner.position).normalized() * SPEED
	steer = (desired_direction - velocity).normalized() * STEER_FORCE
	
	return steer


func _target_Saoirse(Saoirse_position: Vector2) -> void:
	owner.get_node("ShotSpawner").look_at(Saoirse_position)

func _get_animation() -> String:
	var facing_direction = _get_facing_direction(velocity)
	
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


func _on_Banish_entered(body: KinematicBody2D) -> void:
	if body:
		detection_timer.start()


func _on_Banish_exited(body: KinematicBody2D) -> void:
	if body:
		detection_timer.stop()


func _on_Detection_timeout() -> void:
	detection_timer.stop()
	emit_signal("transition_to_state", "casting")
