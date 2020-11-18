extends KinematicBody2D

signal has_banished

const MAX_BANISHMENTS: int = 3

export var speed_walking: int = 200
export var speed_running: int = 250
export var friction: float = 0.01
export var acceleration: float = 0.1
export var has_blessed_water: bool = true

var BlessedShot: PackedScene = preload("res://Entities/BlessedWaterShot/BlessedShot.tscn")
var velocity: Vector2 = Vector2()
var current_speed: int = speed_walking
var spawn_point: Vector2 = Vector2()
var banish_count: int = 0

var is_banished: bool = false

onready var shot_spawner: Node2D = $ShotSpawner
onready var animated_sprite: AnimatedSprite = $AnimatedSprite;

func _ready():
	spawn_point = global_position # when banished, lerp to this point

func _input(_event) -> void:
	if not is_banished:
			if Input.is_action_pressed("sprint"):
				set_current_speed(speed_running)
			else:
				set_current_speed(speed_walking)
			
			if Input.is_action_just_pressed("fire") and has_blessed_water:
				fire_water()

func _physics_process(_delta) -> void:
	if not is_banished:
		var direction: Vector2 = handle_movement()

		if direction.length() > 0:
			velocity = lerp(velocity, direction.normalized() * current_speed, acceleration)
		else:
			velocity = lerp(velocity, Vector2.ZERO, friction)
	else:
		var distance_to_spawn_point = position.distance_to(spawn_point)

		if distance_to_spawn_point > 1:
			velocity = lerp(velocity, (spawn_point - position).normalized() * current_speed, acceleration)
		else:
			is_banished = false
			animated_sprite.visible = !is_banished
			get_tree().call_group("interface", "add_banishment_token", banish_count)

	shot_spawner.look_at(get_global_mouse_position())
	velocity = move_and_slide(velocity)

func set_current_speed(speed_value) -> void:
	current_speed = speed_value

func fire_water() -> void:
	var shot = BlessedShot.instance()
	shot.transform = shot_spawner.global_transform
	shot_spawner.add_child(shot)

func handle_movement() -> Vector2: 
	var input: Vector2 = Vector2()

	if not is_banished:
		if Input.is_action_pressed("walk_up"):
			input.y -= 1
		elif Input.is_action_pressed("walk_down"):
			input.y += 1
			animated_sprite.play("walking_forward")
		elif Input.is_action_pressed("walk_right"):
			input.x += 1
			animated_sprite.play("walking_left")
			animated_sprite.flip_h = true
		elif Input.is_action_pressed("walk_left"):
			input.x -= 1
			animated_sprite.play("walking_left")
			animated_sprite.flip_h = false
		else:
			animated_sprite.play("default")
	return input

# when hit by cultist, move to spawn point
func banish():
	banish_count += 1
	if banish_count < MAX_BANISHMENTS:
		is_banished = true
		animated_sprite.visible = !is_banished
	else:
		get_tree().reload_current_scene()