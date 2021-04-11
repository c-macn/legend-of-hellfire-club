extends KinematicBody2D

const SPEED_PATROLLING: int = 50
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

# export(int) var detection_length = 100
# export(int) var detection_rays_length = 32

var BlessedShot: PackedScene = preload("res://Entities/BlessedWaterShot/BlessedShot.tscn")

var velocity: Vector2 = Vector2()
var speed: int = SPEED_PATROLLING
var is_stunned: bool = false
var is_chasing: bool = true
var player_position: Vector2 = Vector2.ZERO

# steering behaviour
var detection_ray_directions := []
var interest := []
var danger := []
var chosen_direction := Vector2.ZERO
var steer_force := 100.0

onready var stun_timer: Timer = $StunnedTimer
onready var detection_timer: Timer = $DetectionTimer
onready var cast_timeout: Timer = $CastTimeout
onready var banishment_area: Area2D = $BanishmentArea
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite

func _ready():
	add_to_group("cultists")
	#init_ai_context()

	stun_timer.connect("timeout", self, "_on_Stun_timeout")
	detection_timer.connect("timeout", self, "_on_Detection_timeout")
	cast_timeout.connect("timeout", self, "_on_Cast_cooldown")
	banishment_area.connect("body_entered", self, "_on_Banish_entered")

func _physics_process(delta):
	if is_stunned:
		pass

	if is_chasing:
		velocity += seek_Saoirse() * delta
		velocity = velocity.clamped(speed)
		position += velocity * delta
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	# set_interest()
	# set_danger()
	# choose_direction()

	# var desired_velocity = chosen_direction * speed
	# velocity = velocity.linear_interpolate(desired_velocity, steer_force)

	move_and_slide(velocity)

func stun():
	if not is_stunned:
		stun_timer.start()
		# speed = 0
		# if is_chasing:
		# 	is_chasing = false
		# 	player_position = Vector2.ZERO
		animation_player.play("stunned")

func get_player_position() -> Vector2:
	return get_parent().get_node("Saoirse").position

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

func _on_Stun_timeout() -> void:
	animation_player.stop()
	animated_sprite.visible = true
	speed = SPEED_PATROLLING
	is_stunned = false

func _on_Banish_entered(body: KinematicBody2D) -> void:
	if body:
		detection_timer.start()

func _on_Detection_timeout() -> void:
	# fire magic shiz
	cast_spell()
	detection_timer.stop()

func cast_spell() -> void:
	#var shot = BlessedShot.instance()
	print("CAST")
	is_chasing = false
	cast_timeout.start()

func seek_Saoirse() -> Vector2:
	var steer = Vector2.ZERO
	var target_position = get_player_position()

	if target_position:
		var desired_direction = (target_position - position).normalized() * speed
		steer = (desired_direction - velocity).normalized() * steer_force
	
	return steer
	
func _on_Cast_cooldown() -> void:
	is_chasing = true
	cast_timeout.stop()
	
############### CONTEXT STEERING CODE #############################

# sets up the detection raycast, interest, and danger value arrays
# func init_ai_context() -> void:
# 	interest.resize(detection_rays_length)
# 	danger.resize(detection_rays_length)
# 	detection_ray_directions.resize(detection_rays_length)

# 	# create rays starting from rotation 0 (right facing)
# 	for i in detection_rays_length:
# 		var angle = i * 2 * PI / detection_rays_length
# 		detection_ray_directions[i] = Vector2.RIGHT.rotated(angle)

# func set_interest() -> void:
# 	var Saoirse_position = get_player_position()
# 	for i in detection_rays_length:
# 		var direction = detection_ray_directions[i].dot(Saoirse_position)
# 		interest[i] = direction

# func set_danger() -> void:
# 	var space_state = get_world_2d().direct_space_state
# 	for i in detection_rays_length:
# 		var ray_length = detection_ray_directions[i] * detection_length 
# 		var result = space_state.intersect_ray(position, position + ray_length, [self])

# 		danger[i] = 1.0 if result else 0.0

# func choose_direction() -> void:
# 	for i in detection_rays_length:
# 		if danger[i] > 0.0:
# 			interest[i] = 0.0;

# 	chosen_direction = Vector2.ZERO
# 	for i in detection_rays_length:
# 		chosen_direction += detection_ray_directions[i] * interest[i]

# 	chosen_direction = chosen_direction.normalized()
