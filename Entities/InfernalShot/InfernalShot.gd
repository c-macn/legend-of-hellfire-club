extends Area2D
class_name InfernalShot

var is_ready_to_fire = false
var speed: int = 600
var velocity: Vector2 = Vector2()

onready var visibility_notifier: VisibilityNotifier2D = $VisibilityNotifier2D
onready var sprite: Sprite = $Sprite
onready var collision_poly: CollisionPolygon2D = $CollisionShape2D
onready var tween := $Tween
onready var shoot_timer := $Timer

func _ready() -> void:
	sprite.self_modulate = Color(1, 1, 1, 0)
	self.connect("body_entered", self, "_on_InfernalShot_body_entered")
	shoot_timer.connect("timeout", self, "_on_Shot_ready")
	visibility_notifier.connect("screen_exited", self, "_on_left_bounds")

	set_as_toplevel(true)
	
func _physics_process(delta) -> void:
	if is_ready_to_fire:
		position += transform.x * speed * delta

func reveal() -> void:
	tween.interpolate_property(sprite, "self_modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	tween.start()
	shoot_timer.start()

func shoot() -> void:
	is_ready_to_fire = true
	monitoring = true
	
func _on_InfernalShot_body_entered(body: KinematicBody2D) -> void:
	if body and body.has_method("banish"):
		body.banish()
	
		queue_free()

func _on_Shot_ready() -> void:
	shoot()

func _on_left_bounds() -> void:
	queue_free()
