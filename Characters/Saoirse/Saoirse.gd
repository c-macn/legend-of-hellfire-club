extends KinematicBody2D

# Used to tell the parent scene the disquise has been removed, so a box instance should be created
signal disguise_removed(position)

const MAX_BANISHMENTS: int = 3

var BlessedShot: PackedScene = preload("res://Entities/BlessedWaterShot/BlessedShot.tscn")
var banish_count: int = 0
var velocity := Vector2()
var is_banished := false
var default_frames := preload("res://Characters/Saoirse/Animations/Saoirse_Default_Frames.tres")
var box_frames := preload("res://Characters/Saoirse/Animations/Saoirse_Box_Frames.tres")
var cutscene_waypoints: PoolVector2Array
var is_movement_disabled: bool = false

onready var shot_spawner: Node2D = $ShotSpawner
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var state_machine: Node = $StateMachine
onready var tween := $Tween

func _ready():
	add_to_group("actors")
	var active_frames = box_frames if GameState.get_is_Saoirse_disguised() else default_frames
	_set_active_frames(active_frames)

func _process(_delta) -> void:
	$ColorRect.material.set_shader_param("player_position", position)

func _input(_event) -> void:
	if !is_movement_disabled:
		if Input.is_action_just_pressed("fire") and GameState.get_has_blessed_shot():
			fire_water()
		
		if Input.is_action_just_pressed("obj_cancel"):
			if is_disguised():
				take_off_disguise()
		
func fire_water() -> void:
	var shot = BlessedShot.instance()
	shot.transform = shot_spawner.global_transform

	shot_spawner.add_child(shot)

# when hit by cultist, move to spawn point
func banish(banish_increase: int, respawn_position: Vector2) -> void:
	disable_movement()
	if banish_increase:
		banish_count += banish_increase
	else:
		banish_count += 1
	
	if banish_count < MAX_BANISHMENTS:
		tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 1, 0, 1,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

		tween.interpolate_callback(self, 1, "reanimate", respawn_position)
	else:
		tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 1, 0, 1,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		
		tween.interpolate_callback(self, 1, "game_over")

	tween.start()

func reanimate(respawn_point: Vector2) -> void:
	global_position = lerp(global_position, respawn_point, 0.5)

	tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 0, 1, 1,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

	tween.interpolate_property(self, "global_position", global_position, respawn_point, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)

	tween.start()
	enable_movement()

func game_over() -> void:
	get_tree().reload_current_scene() # create game over screen

func move_to_point(target_position: Vector2) -> void:
	tween.interpolate_property(self, "position", position, target_position, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT) 
	tween.start(); # convert to steer behavior

func put_on_disguise() -> void:
	GameState.set_is_Saoirse_disguised(true)	
	_set_active_frames(box_frames)

func take_off_disguise() -> void:
	GameState.set_is_Saoirse_disguised(false)
	_set_active_frames(default_frames)
	emit_signal("disguise_removed", position)

func is_disguised() -> bool:
	return GameState.get_is_Saoirse_disguised()

func scene_start() -> void:
	pause_mode = Node.PAUSE_MODE_STOP;

func scene_end() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS;

func disable_movement() -> void:
	is_movement_disabled = true

func enable_movement() -> void:
	is_movement_disabled = false

func _set_active_frames(frames: SpriteFrames) -> void:
	animated_sprite.frames = frames

func turn_off_light() -> void:
	$Light2D.visible = false
