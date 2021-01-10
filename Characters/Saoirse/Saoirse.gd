extends KinematicBody2D

const MAX_BANISHMENTS: int = 3

export var has_blessed_water: bool = true

var BlessedShot: PackedScene = preload("res://Entities/BlessedWaterShot/BlessedShot.tscn")
var velocity: Vector2 = Vector2()
var spawn_point: Vector2 = Vector2()
var banish_count: int = 0

var is_banished: bool = false

onready var shot_spawner: Node2D = $ShotSpawner
onready var animated_sprite: AnimatedSprite = $AnimatedSprite;
onready var state_machine: Node = $StateMachine;
onready var interaction_range: RayCast2D = $InteractionRange

func _ready():
	# TODO create a path node every time saoirse walks so the path can be retraced
	spawn_point = global_position # when banished, lerp to this point

func _input(event) -> void:
	if Input.is_action_just_pressed("fire") and has_blessed_water:
		fire_water()

func _physics_process(delta: float) -> void:
	interaction_range.rotation_degrees
	if interaction_range.is_colliding():
		var obj = interaction_range.get_collider();
		obj.highlight();

func fire_water() -> void:
	var shot = BlessedShot.instance()
	shot.transform = shot_spawner.global_transform

	shot_spawner.add_child(shot)

# when hit by cultist, move to spawn point
func banish() -> void:
	banish_count += 1
	if banish_count < MAX_BANISHMENTS:
		is_banished = true
		animated_sprite.visible = !is_banished
	else:
		get_tree().reload_current_scene()

# maybe not the best
func start_acting() -> void:
	state_machine._change_state("acting")
