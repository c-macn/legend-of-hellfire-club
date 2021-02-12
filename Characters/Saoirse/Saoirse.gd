extends KinematicBody2D

# Used to tell the parent scene the disquise has been removed, so a box instance should be created
signal disguise_removed(position)

const MAX_BANISHMENTS: int = 3

export var has_blessed_water: bool = false

var BlessedShot: PackedScene = preload("res://Entities/BlessedWaterShot/BlessedShot.tscn")
var banish_count: int = 0
var velocity := Vector2()
var spawn_point := Vector2()
var is_banished := false
var default_frames := preload("res://Characters/Saoirse/Animations/Saoirse_Default_Frames.tres")
var box_frames := preload("res://Characters/Saoirse/Animations/Saoirse_Box_Frames.tres")
var cutscene_waypoints: PoolVector2Array

onready var shot_spawner: Node2D = $ShotSpawner
onready var animated_sprite: AnimatedSprite = $AnimatedSprite;
onready var state_machine: Node = $StateMachine;

func _ready():
	# TODO create a path node every time saoirse walks so the path can be retraced
	spawn_point = global_position # when banished, lerp to this point
	var active_frames = box_frames if GameState.get_is_Saoirse_disguised() else default_frames
	_set_active_frames(active_frames)

func _input(_event) -> void:
	if Input.is_action_just_pressed("fire") and has_blessed_water:
		fire_water()
		
	if Input.is_action_just_pressed("obj_interact") and GameState.get_is_Saoirse_disguised():
		take_off_disguise()
		
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


func start_acting() -> void:
	state_machine._change_state("acting")

func move_to_point(target_position: Vector2) -> void:
	state_machine.current_state.move_to_point(target_position)

func put_on_disguise() -> void:
	GameState.set_is_Saoirse_disguised(true)
	_set_active_frames(box_frames)

func take_off_disguise() -> void:
	GameState.set_is_Saoirse_disguised(false)
	_set_active_frames(default_frames)
	emit_signal("disguise_removed", position)

func is_disguised() -> bool:
	return animated_sprite.frames == box_frames

func _set_active_frames(frames: SpriteFrames) -> void:
	animated_sprite.frames = frames
