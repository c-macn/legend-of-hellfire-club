extends Node2D

const MAX_BOUNDS_X: int = 15
const MAX_BOUNDS_Y: int = 10

var banish_target: KinematicBody2D = null

onready var iris: Sprite = $Iris;
onready var eyeball_tween: Tween = $EyeballTweener

func _ready() -> void:
	animate_iris()

func _process(delta: float) -> void:
	if banish_target:
		print("I banish ye, ya auld cunt")
	pass

func animate_iris(current_position = null) -> void:
	randomize()

	if current_position == null:
		current_position = iris.position

	var x_position: int = randi() % MAX_BOUNDS_X
	var y_position: int = randi() % MAX_BOUNDS_Y
	var rand: int = randi() % 20;

	if rand % 2 == 0:
		x_position = x_position * -1
		y_position = y_position * -1

	var new_position: Vector2 = Vector2(x_position, y_position)

	if current_position.distance_to(new_position) <= 1:
		animate_iris(new_position)
	else:
		_tween_iris_position(current_position, new_position, "animate_iris")

func set_iris_position(target_position: Vector2) -> void:
	var current_position := iris.position
	eyeball_tween.stop_all()
	_tween_iris_position(current_position, target_position)

func _tween_iris_position(current_position: Vector2, new_position: Vector2, callback_function = null) -> void:
	eyeball_tween.interpolate_property(iris, "position", current_position, new_position, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)

	if callback_function != null:
		eyeball_tween.interpolate_callback(self, 1.0, callback_function, new_position)

	eyeball_tween.start()

func banish_target(target_path: NodePath) -> void:
	banish_target = get_node(target_path)
