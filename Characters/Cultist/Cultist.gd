extends KinematicBody2D

const SPEED_PATROLLING: int = 100
const SPEED_CHASING: int = 400

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

func _ready():
	add_to_group("cultists")
	
	stun_timer.connect("timeout", self, "_on_Stun_timeout")
	detection_timer.connect("timeout", self, "_on_Detection_timeout")
	detection_radius.connect("body_entered", self, "_on_Body_entered")
	detection_radius.connect("body_exited", self, "_on_Body_exited")

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

	velocity = move_and_slide(velocity)

func get_target():
	if is_chasing:
		return player_position
	else:
		return get_path_target(patrol_points, patrol_index)

func stun():
	if not is_stunned:
		stun_timer.start()
		speed = 0
		if is_chasing:
			is_chasing = false
			player_position = Vector2.ZERO
		$AnimationPlayer.play("stunned")

func get_path_target(points: Array, index: int):
	var target = points[index]

	if position.distance_to(target) < 1:
		index = wrapi(index + 1, 0, points.size())
		target = points[index]

	return target
	
func is_body_Saoirse(name: String) -> bool:
	return name == "Saoirse"

func _on_Stun_timeout():
	$AnimationPlayer.stop()
	$AnimatedSprite.visible = true
	speed = SPEED_PATROLLING
	is_stunned = false

func _on_Body_entered(body: KinematicBody2D):
	if not is_chasing:
		if is_body_Saoirse(body.name):
			player_position = body.global_position
			detection_timer.start()
			
func _on_Body_exited(body: KinematicBody2D):
	if not is_chasing:
		if is_body_Saoirse(body.name):
			detection_timer.stop()

func _on_Detection_timeout():
	print("Going to chase Saoirse at position: ", player_position)
	is_chasing = true
