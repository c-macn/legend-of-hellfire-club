extends KinematicBody2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var tween := $Tween
onready var animated_sprite := $Sprite

func _ready() -> void:
	$AnimationPlayer.play("idle")

func set_frames(frames_path: String) -> void:
	var frames = load(frames_path);
	animated_sprite.frames = frames
	animated_sprite.play("default")

func disable_collisions() -> void:
	$CollisionShape2D.disabled = true

func enable_collisions() -> void:
	$CollisionShape2D.disabled = false

func hover_in_position(position_modifier: int) -> void:
	var new_position = Vector2(position.x, position.y + position_modifier)

	tween.interpolate_property(self, "position", position, new_position, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	tween.start()

func play_spook() -> void:
	animated_sprite.play("spook")

func remove_shader() -> void:
	tween.interpolate_property($Fire, "visible", true, false, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	tween.interpolate_callback(self, 0.5, "_destroy_fire")

	tween.start()

func _destroy_fire() -> void:
	$Fire.queue_free()
