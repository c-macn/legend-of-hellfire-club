extends KinematicBody2D

var rat_gore = preload("res://Audio/rat_gore.mp3")
var rat_squeak = preload("res://Audio/rat_squeak.wav")
var glass_hitting_obstacle = preload("res://Audio/glass_hitting_obstacle.mp3")
var glass_rolling_floor = preload("res://Audio/glass_rolling_floor.mp3")
var glass_break = preload("res://Audio/bottle_breaks.mp3")

onready var glass_sfx := $GlassSfx
onready var rat_sfx := $RatSfx
onready var bottle_sprite: AnimatedSprite = $Bottle;
onready var rat_sprite: AnimatedSprite = $Rat
onready var tween := $Tween
onready var bottle_explode: Particles2D = $BottleExplode

func _ready() -> void:
	_play_glass_sfx(glass_hitting_obstacle, -5.0)


func explode() -> void:
	_play_rat_sfx(rat_gore)
	_play_glass_sfx(glass_break, -5.0)
	_explode_bottle()
	_explode_rat()
	yield(get_tree().create_timer(0.5), "timeout")
	kill_scene()


func kill_scene() -> void:
	bottle_explode.emitting = false
	$RatExplode.emitting = false


func play_bottle_animation(should_play: bool) -> void:
	if should_play:
		_play_glass_sfx(glass_rolling_floor)
		bottle_sprite.play()
	else:
		glass_sfx.stop()
		bottle_sprite.stop()


func rat_emerge() -> void:
	_play_rat_sfx(rat_squeak)
	var target_position = Vector2(rat_sprite.position.x - 24,  rat_sprite.position.y)
	tween.interpolate_property(rat_sprite, 'position', rat_sprite.position, target_position, 1.0)
	tween.start()


func _explode_bottle() -> void:
	bottle_sprite.visible = false
	bottle_explode.emitting = true


func _explode_rat() -> void:
	rat_sprite.visible = false
	$RatExplode.emitting = true


func _play_glass_sfx(sound: AudioStream, volume: float = 0.0) -> void:
	if glass_sfx.is_playing():
		glass_sfx.stop()
		
	glass_sfx.stream = sound
	glass_sfx.volume_db = volume
	glass_sfx.play()


func _play_rat_sfx(sound: AudioStream, volume: float = 0.0) -> void:
	if rat_sfx.is_playing():
		rat_sfx.stop()
	
	rat_sfx.stream = sound
	rat_sfx.volume_db = volume
	rat_sfx.play()
