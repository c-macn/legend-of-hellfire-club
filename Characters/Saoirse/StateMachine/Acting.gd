extends "res://Characters/Saoirse/StateMachine/MoveState.gd"

var _current_destination = null setget move_to_point, get_current_destination
var _animated_sprite: AnimatedSprite
var _current_animation: String;

func enter() -> void:
	add_to_group("actors")
	_animated_sprite = owner.owner.get_node("AnimatedSprite")

func exit() -> void:
	remove_from_group("actors")
	_current_animation = ""

func scene_over() -> void:
	emit_signal("transition_to_state", "idle")

func update(delta: float) -> void:
	.update(delta)
	var target = get_current_destination()
	if target != null:
		if _has_reached_destination(owner.owner.global_position, target):
			_destination_reached()
			velocity = Vector2.ZERO

			if _current_animation.length() > 0:
				_animated_sprite.play("idle_" + _current_animation)

		else:
			velocity = lerp(velocity, (target - owner.owner.global_position).normalized() * speed_walking, 0.1)
			_current_animation = get_animation()
			_animated_sprite.play(_current_animation)
		
	owner.owner.move_and_slide(velocity)

func move_to_point(position: Vector2) -> void:
	_current_destination = position

func get_current_destination() -> Vector2:
	return _current_destination

func _has_reached_destination(parents_position: Vector2, current_destination: Vector2) -> bool:
	return parents_position.distance_to(current_destination) < 1

func _destination_reached() -> void:
	_current_destination = null
