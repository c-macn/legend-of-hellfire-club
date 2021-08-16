extends KinematicBody2D
class_name Cultist

signal phased_out
signal cleansed(count)

export(NodePath) var SaoirseNode
export(bool) var is_clone = false
export(bool) var is_boss = false

const MAX_SHOTS: int = 3

var InfernalShot: PackedScene = preload("res://Entities/InfernalShot/InfernalShot.tscn")
var is_stunned: bool = false
var is_chasing: bool = false

var debug_line: Line2D
var navigation: Navigation2D
var Saoirse_ref: Saoirse
var cleanse_count := 0

onready var stun_timer: Timer = $StunnedTimer
onready var cast_timeout: Timer = $CastTimeout
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var tween := $Tween
onready var state_machine: Node = $StateMachine
onready var light: Light2D = $Light2D
onready var hit_box: CollisionShape2D = $HitBox
onready var audio_player := $AudioStreamPlayer

func _ready():
	add_to_group("cultists")
	add_to_group("actors")
	
	animated_sprite.material.set_shader_param("dissolve_value", 0)
	light.energy = 0
	
	if not SaoirseNode.is_empty():
		Saoirse_ref = get_node(SaoirseNode)
	
	stun_timer.connect("timeout", self, "phase_out")
	
	if is_clone:
		light.color = Color('#e15858')
	else:
		light.color = Color('#ffffff')


func _physics_process(_delta):
	if is_stunned:
		pass


func stun():
	if not is_stunned:
		is_stunned = true
		stun_timer.start()
		animation_player.play("stunned")
		state_machine._change_state("idle")


func phase_out() -> void:
	animated_sprite.material = load("res://Shaders/Dissolve.tres")
	if is_stunned:
		is_stunned = false
		
	tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 1, 0, 3,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			
	tween.interpolate_property(light, 'energy', 1, 0, 3,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			
	tween.interpolate_callback(self, 2, "_phased_out")
	
	if !tween.is_active():
		tween.start()


func get_is_on_wall() -> bool:
	return is_on_wall()


func phase_in() -> void:
	animated_sprite.material = load("res://Shaders/Dissolve.tres")
	tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
	tween.interpolate_property(light, 'energy', 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
	tween.interpolate_callback(self, 1, "_phased_in")
	
	if !tween.is_active():
		tween.start()


func boss_phase_in(spawn_position: Vector2) -> void:
	animated_sprite.material = load("res://Shaders/Dissolve.tres")
	global_position = spawn_position
	
	tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	if is_clone:
		light.color = Color('#e15858')
	else:
		light.color = Color('#ffffff')
	
	tween.interpolate_property(light, 'energy', 0, 1, 3,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	tween.interpolate_callback(self, 1, "_boss_phased_in")
	
	if !tween.is_active():
		tween.start()


func get_Saoirses_position() -> Vector2:
	if is_instance_valid(Saoirse_ref):
		return Saoirse_ref.global_position
	else:
		return Vector2.ZERO


func cleanse() -> void:
	if not is_clone:
		animated_sprite.material = load("res://Shaders/Hit.tres")
		HitFreeze.freeze()
		$AnimationPlayer.play("hit")
		yield(get_tree().create_timer(0.8), "timeout")
		
		if is_stunned:
			cleanse_count += 1
			hit_box.call_deferred("set_disabled", true)
			emit_signal("cleansed", cleanse_count)
		else:
			if not is_boss:
				phase_out()


func set_to_idle() -> void:
	animated_sprite.play("walk_back")
	stun_timer.disconnect("timeout", self, "phase_out")
	stun_timer.stop()
	state_machine._change_state("idle")


func shoot_target() -> void:
	var shot_spawner = get_node("ShotSpawner")
	var target_position = get_Saoirses_position()
	var shot = InfernalShot.instance()
	
	add_child(shot)
	shot.set_is_lethal(false)
	shot_spawner.look_at(target_position)
	shot.transform = shot_spawner.global_transform
	shot.scale = Vector2(1, 0.5)
	shot.reveal()
	$AudioStreamPlayer.stream = load("res://Audio/cursed_shot.mp3")
	$AudioStreamPlayer.play()


func reveal() -> void:
	animated_sprite.material.set_shader_param("dissolve_value", 1)


func play_animation(animation_name: String) -> void:
	animated_sprite.play(animation_name)


func play_shot_sfx() -> void:
	audio_player.stream = load("res://Audio/cursed_shot.mp3")
	audio_player.play()


func _phase_in_animation() -> void:
	tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
	tween.interpolate_property(light, 'energy', 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	tween.start()


func _phased_out() -> void:
	hit_box.set_disabled(true)
	state_machine._change_state("idle")
	emit_signal("phased_out")


func _phased_in() -> void:
	hit_box.set_disabled(false)
	state_machine._change_state("chasing")


func _boss_phased_in() -> void:
	hit_box.set_disabled(false)
	state_machine._change_state("boss_battle")


func clone_phase_out() -> void:
	animated_sprite.material = load("res://Shaders/Dissolve.tres")
	
	tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 1, 0, 3,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			
	tween.interpolate_property(light, 'energy', 1, 0, 3,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	if !tween.is_active():
		tween.start()
