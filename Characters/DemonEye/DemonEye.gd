extends Node2D

const MAX_ROTATION_DEGREE := 30.0
const INITIAL_ROTATION_DEGREES := 90.0

var banish_target: KinematicBody2D = null

onready var animated_sprite := $Eyeball
onready var tween := $Tween
onready var light_pivot: Node2D = $LightPivot
onready var banish_time := $BanishTimer

func _ready() -> void:
	animated_sprite.play("default")
	light_pivot.rotation_degrees = INITIAL_ROTATION_DEGREES
	banish_time.connect("timeout", self, "_banish_target")

func _process(_delta: float) -> void:
	if banish_target:
		light_pivot.look_at(banish_target.position)

func get_banish_target(target_path: NodePath) -> Node:
	return get_node(target_path)

func wake_up() -> void:
	animated_sprite.play("open_eye")

func patrol() -> void:
	animated_sprite.play("look")
	tween_light_right()

func tween_light_right() -> void:
	var rotation_result = light_pivot.rotation_degrees - MAX_ROTATION_DEGREE
	tween.interpolate_property(light_pivot, "rotation_degrees", light_pivot.rotation_degrees, rotation_result, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	tween.interpolate_callback(self, 1, "tween_light_center", "tween_light_left")
	
	if !tween.is_active():
		tween.start()

func tween_light_left() -> void:
	var rotation_result = light_pivot.rotation_degrees + MAX_ROTATION_DEGREE
	tween.interpolate_property(light_pivot, "rotation_degrees", light_pivot.rotation_degrees, rotation_result, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	tween.interpolate_callback(self, 1, "tween_light_center", "tween_light_right")
	if !tween.is_active():
		tween.start()
	
func tween_light_center(next_tween_direction: String) -> void:
	
	tween.interpolate_property(light_pivot, "rotation_degrees", light_pivot.rotation_degrees, INITIAL_ROTATION_DEGREES, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	tween.interpolate_callback(self, 1, next_tween_direction)
	
	if !tween.is_active():
		tween.start()

func look_at_target(target_node: NodePath) -> void:
	var target = get_parent().get_node(target_node)
	tween.stop_all()
	
	light_pivot.look_at(target.position)

func set_target(target: KinematicBody2D) -> void:
	banish_target = target
	banish_time.start()


func turn_off_light() -> void:
	light_pivot.get_node("Light2D").enabled = false


func set_bad_ending_frame() -> void:
	animated_sprite.play("bad_ending")
	

func _banish_target() -> void:
	banish_time.stop()
	if banish_target.has_method("banish"):
		banish_target.banish(3, Vector2.ZERO)
