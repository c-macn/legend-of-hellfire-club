extends Area2D

var speed: int = 700
var target: Vector2 = Vector2()
var velocity: Vector2 = Vector2()

onready var visibility_notifier: VisibilityNotifier2D = $VisibilityNotifier2D
onready var sprite: Sprite = $Sprite
onready var collision_poly: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
	self.connect("body_entered", self, "_on_BlessedShot_body_entered")
	visibility_notifier.connect("screen_exited", self, "_on_left_bounds")

	set_as_toplevel(true)
	lock_rotation(90) # ensure the shot is always facing forward

func _physics_process(delta) -> void:
	position += transform.x * speed * delta

func lock_rotation(degrees: float) -> void:
	sprite.rotation_degrees = degrees
	collision_poly.rotation_degrees = sprite.rotation_degrees

func _on_BlessedShot_body_entered(body: KinematicBody2D) -> void:
	if body != null:
		if body.is_in_group("cultists"):
			body.stun()
	queue_free()

func _on_left_bounds() -> void:
	queue_free()
