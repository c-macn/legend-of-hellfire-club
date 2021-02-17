extends KinematicBody2D

onready var bottle_sprite: AnimatedSprite = $Bottle;
onready var rat_sprite: AnimatedSprite = $Rat
onready var tween := $Tween
onready var bottle_explode: Particles2D = $BottleExplode

func play_bottle_animation(should_play: bool) -> void:
	if should_play:
		bottle_sprite.play()
	else:
		bottle_sprite.stop()

func rat_emerge() -> void:
	var target_position = Vector2(rat_sprite.position.x - 24,  rat_sprite.position.y)
	tween.interpolate_property(rat_sprite, 'position', rat_sprite.position, target_position, 1.0)
	tween.start()

func explode_bottle() -> void:
	bottle_sprite.queue_free()
	bottle_explode.emitting = true

func explode_rat() -> void:
	# also blow up rat with particles
	rat_sprite.queue_free()

func kill_scene() -> void:
	queue_free()
