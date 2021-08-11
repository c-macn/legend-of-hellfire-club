extends KinematicBody2D
class_name Saoirse

# Used to tell the parent scene the disquise has been removed, so a box instance should be created
signal disguise_removed(position)

# used to tell the parent scene that Saoirse has been banished so the cultist can de-spawn
signal banished

export(NodePath) var tilemap

const MAX_BANISHMENTS := 3
const DEFAULT_FRAME_COUNT = 19
const BOX_FRAME_COUNT = 16
const BOX_FORWARD_FRAME = 4
const DEFAULT_FORWARD_FRAME = 10

var lives_count = load("res://CustomerResources/player_lives.tres")
var BlessedShot: PackedScene = preload("res://Entities/BlessedWaterShot/BlessedShot.tscn")
var banish_count: int = 0
var velocity := Vector2()
var is_banished := false
var default_frames := preload("res://Characters/Saoirse/Sprites/Saoirse Full Animation.png")
var box_frames := preload("res://Characters/Saoirse/Sprites/Saoirse_inBOX Full Animation.png")
var cutscene_waypoints: PoolVector2Array
var is_movement_disabled: bool = false
var spawn_point: Vector2
var tilemap_node: TileMap

onready var shot_spawner: Node2D = $ShotSpawner
onready var animated_sprite: AnimationPlayer = $AnimationPlayer
onready var state_machine: Node = $StateMachine
onready var tween := $Tween
onready var audio_player := $AudioStreamPlayer

func _ready():
	if tilemap:
		tilemap_node = get_node(tilemap)
	add_to_group("actors")
	enable_movement()
	spawn_point = global_position
	var active_frames = box_frames if GameState.get_is_Saoirse_disguised() else default_frames
	var frame_count = BOX_FRAME_COUNT if GameState.get_is_Saoirse_disguised() else DEFAULT_FRAME_COUNT
	_set_active_frames(active_frames, frame_count)


func _input(_event) -> void:
	if !is_movement_disabled:
		if Input.is_action_just_pressed("fire") and _can_fire() and GameState.get_has_blessed_shot():
			fire_water()


func fire_water() -> void:
	var shot = BlessedShot.instance()
	shot_spawner.look_at(get_global_mouse_position())
	$Sprite.frame = $FacingDirectionManager.get_frame(shot_spawner.rotation)
	shot.transform = shot_spawner.global_transform
	shot_spawner.add_child(shot)
	$ShootDelay.start()
	play_shot_sfx()


# when hit by cultist, move to spawn point
func banish(banish_increase: int = 1, respawn_position: Vector2 = spawn_point) -> void:
	disable_movement()
	
	if banish_increase:
		banish_count += banish_increase
	else:
		banish_count += 1
	
	if banish_count < MAX_BANISHMENTS:
		tween.interpolate_callback(self, 1, "reanimate", respawn_position)
		emit_signal("banished")
	else:
		tween.interpolate_callback(self, 1, "game_over")
		tween.interpolate_callback(self, 1, "reanimate", respawn_position)
		
	tween.start()


func on_hit() -> void:
	HitFreeze.freeze()
	disable_movement()
	lives_count.reduce_lives_count()
	
	$AnimationPlayer.play("hit")
	yield(get_tree().create_timer(0.5), "timeout")
	
	if lives_count.get_lives_count() > 0:
		enable_movement()
	else:
		insta_death()


func mark() -> void:
	$AnimationPlayer.play("hit")


func insta_death() -> void:
	$AnimationPlayer.play("hit")
	get_tree().call_deferred("UI", "fade_in")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().call_deferred("change_scene", "res://Rooms/BadEnding.tscn")


func reanimate(respawn_point: Vector2) -> void:
	global_position = lerp(global_position, respawn_point, 0.5)
	
	tween.interpolate_property(self, "global_position", global_position, respawn_point, 1,
		Tween.TRANS_SINE, Tween.EASE_OUT)
		
	tween.start()
	enable_movement()


func game_over() -> void:
	get_tree().reload_current_scene() # create game over screen


func move_to_point(target_position: Vector2) -> void:
	var destination = (target_position - position).normalized()
	var time = round(position.distance_to(target_position) / 100 * 1)
	tween.connect("tween_completed", self, "has_reached_point")
	tween.interpolate_property(self, "position", position, target_position, time, Tween.TRANS_SINE, Tween.EASE_OUT) 
	tween.start();
	animated_sprite.play($FacingDirectionManager.get_animation(destination))
	yield(tween, "tween_completed")
	animated_sprite.stop()
	set_forward_frame() # looking forward


func put_on_disguise() -> void:
	play_cardboard_sound()
	fade_in_disguise()
	yield(get_tree().create_timer(1.5), "timeout")
	GameState.set_is_Saoirse_disguised(true)
	_set_active_frames(box_frames, BOX_FRAME_COUNT)
	fade_out_disguise()


func take_off_disguise() -> void:
	disable_movement()
	play_cardboard_sound()
	fade_in_disguise()
	GameState.set_is_Saoirse_disguised(false)
	_set_active_frames(default_frames, DEFAULT_FRAME_COUNT)
	emit_signal("disguise_removed")
	


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


func _set_active_frames(frames: StreamTexture, h_count: int) -> void:
	$Sprite.texture = frames
	$Sprite.hframes = h_count


func turn_off_light() -> void:
	$Light2D.visible = false


func _can_fire() -> bool:
	return $ShootDelay.is_stopped()


func play_animation(animation_name: String) -> void:
	animated_sprite.play(animation_name)


func set_remote_transform(node_path: NodePath) -> void:
	$RemoteTransform2D.remote_path = node_path


func has_reached_point(_object, _key) -> void:
	tween.disconnect("tween_completed", self, "has_reached_point")
	#animated_sprite.frame = 10 # idle frame forward


func fade_out_disguise() -> void:
	enable_movement()
	get_tree().call_group("canvas_layer", "fade_out")


func fade_in_disguise() -> void:
	disable_movement()
	get_tree().call_group("canvas_layer", "fade_in")

func play_cardboard_sound() -> void:
	audio_player.stream = load("res://Audio/disguise.mp3")
	audio_player.play()


func play_shot_sfx() -> void:
	audio_player.stream = load("res://Audio/blessed_shot.mp3")
	audio_player.play()


func play_footsteps() -> void:
	$Sfx.play()



func set_forward_frame() -> void:
	if not is_disguised():
		$Sprite.frame = DEFAULT_FORWARD_FRAME
	else:
		$Sprite.frame = BOX_FORWARD_FRAME
