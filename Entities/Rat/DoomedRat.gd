extends KinematicBody2D

export(NodePath) var cutscene_waypoints
export(float) var SPEED = 100.0

var waypoints: Array
var velocity: Vector2
var target_position: Position2D

onready var bottle_sprite: AnimatedSprite = $Bottle;

func _ready() -> void:
	var waypoints_node = get_node(cutscene_waypoints)
	if waypoints_node != null:
		waypoints = waypoints_node.get_children()

func _process(delta: float) -> void:
	if _is_valid_target(target_position):
		velocity = lerp(velocity, (target_position.position - position).normalized() * SPEED, 0.1)
		bottle_sprite.play()
	else:
		velocity = Vector2.ZERO
		bottle_sprite.stop()

	move_and_slide(velocity)

func move_to_point(point_name: String) -> void:
	target_position =  _get_waypoint(point_name)

func _get_waypoint(point_name: String) -> Position2D:
	var desired_waypoint = null

	for point in waypoints:
		if point.name == point_name:
			desired_waypoint = point

	return desired_waypoint

func _is_valid_target(target: Position2D) -> bool:
	return target != null and position.distance_to(target.position) > 3
