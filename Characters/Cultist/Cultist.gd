extends KinematicBody2D
class_name Cultist

#signal spell_limit_reached

const MAX_SHOTS: int = 3

var InfernalShot: PackedScene = preload("res://Entities/InfernalShot/InfernalShot.tscn")
var is_stunned: bool = false
var is_chasing: bool = false

onready var stun_timer: Timer = $StunnedTimer
onready var cast_timeout: Timer = $CastTimeout
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var tween := $Tween
onready var state_machine: Node = $StateMachine
onready var light: Light2D = $Light2D
onready var hit_box: CollisionShape2D = $HitBox
onready var navigation: Navigation2D = get_parent().get_node(get_parent().navigation)
onready var debug_line = navigation.get_node("Line2D")

func _ready():
	add_to_group("cultists")
	add_to_group("actors")
	
	animated_sprite.material.set_shader_param("dissolve_value", 0)
	light.energy = 0
	
	stun_timer.connect("timeout", self, "_on_Stun_timeout")


func _physics_process(_delta):
	if is_stunned:
		pass


func stun():
	if not is_stunned:
		stun_timer.start()
		animation_player.play("stunned")


func phase_out() -> void:
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
	tween.interpolate_property(animated_sprite.material, 'shader_param/dissolve_value', 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
	tween.interpolate_property(light, 'energy', 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
	tween.interpolate_callback(self, 1, "_phased_in")
	
	if !tween.is_active():
		tween.start()


func _phased_out() -> void:
	hit_box.set_disabled(true)
	state_machine._change_state("idle")

func _phased_in() -> void:
	hit_box.set_disabled(false)
	state_machine._change_state("chasing")
