extends KinematicBody2D

const SPEED_PATROLLING: int = 100
const SPEED_CHASING: int = 100

enum FACING_VALUES {
	UP = -90,
	DOWN = 90,
	LEFT = 180,
	RIGHT = 0,
	DIAGONAL_UP_LEFT = -135
	DIAGONAL_UP_RIGHT = -45
	DIAGONAL_DOWN_LEFT = 135
	DIAGONAL_DOWN_RIGHT = 45
}

export(NodePath) var path_to_follow = null

var velocity: Vector2 = Vector2()
var speed: int = SPEED_PATROLLING
var is_stunned: bool = false
var is_chasing: bool = false
var patrol_points: Array = []
var patrol_index: int = 0
var player_position: Vector2 = Vector2.ZERO

onready var stun_timer: Timer = $StunnedTimer
onready var detection_timer: Timer = $DetectionArea/DetectionTimer
onready var detection_radius: Area2D = $DetectionArea
onready var banishment_area: Area2D = $BanishmentArea
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

func _ready():
	add_to_group("cultists")

	stun_timer.connect("timeout", self, "_on_Stun_timeout")
	detection_timer.connect("timeout", self, "_on_Detection_timeout")
	detection_radius.connect("body_entered", self, "_on_Body_entered")
	detection_radius.connect("body_exited", self, "_on_Body_exited")
	banishment_area.connect("body_entered", self, "_on_Banish_entered")

	if path_to_follow:
		patrol_points = get_node(path_to_follow).curve.get_baked_points()

func _physics_process(_delta):
	if !path_to_follow:
		return

	var target = get_target()

	if not is_stunned:
		velocity = lerp(velocity, (target - position).normalized() * speed, 0.1)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.1)

	animated_sprite.play(get_animation())
	velocity = move_and_slide(velocity)

func get_target():
	if is_chasing:
		return get_player_position()
	else:
		return get_path_target(patrol_points)

func stun():
	if not is_stunned:
		stun_timer.start()
		speed = 0
		if is_chasing:
			is_chasing = false
			player_position = Vector2.ZERO
		animation_player.play("stunned")

func get_player_position() -> Vector2:
	return get_parent().get_node("Saoirse").position

func get_path_target(points: Array) -> Vector2:
	var target = points[patrol_index]

	if position.distance_to(target) <= 1:
		var new_index = randi() % points.size() - 1
		target = points[new_index]
		patrol_index = new_index

	return target

func get_animation() -> String:
	# get the degrees of the current velocity
	var facing_angle = rad2deg(velocity.angle())
	# round to the nearest whole int divisble by 45
	var facing_angle_rounded = int(round(facing_angle / 45) * 45)

	match facing_angle_rounded:
		FACING_VALUES.DOWN:
			return "default"
		FACING_VALUES.UP:
			return "walk_forward"
		FACING_VALUES.RIGHT:
			return "walk_right"
		FACING_VALUES.LEFT:
			return "walk_left"
		FACING_VALUES.DIAGONAL_DOWN_LEFT:
			return "walk_down_left"
		FACING_VALUES.DIAGONAL_DOWN_RIGHT:
			return "walk_down_right"
		FACING_VALUES.DIAGONAL_UP_RIGHT:
			return "walk_up_right"
		FACING_VALUES.DIAGONAL_UP_LEFT:
			return "walk_up_left"
		_:
			return "default"

func is_body_Saoirse(name: String) -> bool:
	return name == "Saoirse"

func _on_Stun_timeout() -> void:
	animation_player.stop()
	animated_sprite.visible = true
	speed = SPEED_PATROLLING
	is_stunned = false

# detection radius entered
func _on_Body_entered(body: KinematicBody2D) -> void:
	if not is_chasing:
		if is_body_Saoirse(body.name):
			detection_timer.start()

# detection radius exited
func _on_Body_exited(body: KinematicBody2D) -> void:
	if is_body_Saoirse(body.name):
		if not is_chasing:
			detection_timer.stop()
		else:
			is_chasing = false

func _on_Banish_entered(body: KinematicBody2D) -> void:
	if is_body_Saoirse(body.name):
		body.banish()

func _on_Detection_timeout() -> void:
	is_chasing = true
	detection_timer.stop()
