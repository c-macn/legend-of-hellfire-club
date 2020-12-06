extends Node2D

const MAX_BOUNDS_X: int = 15
const MAX_BOUNDS_Y: int = 10

onready var iris: Sprite = $Iris;
onready var eyeball_tween: Tween = $EyeballTweener

func _ready() -> void:
	animate_iris()

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
		eyeball_tween.interpolate_property(iris, "position", current_position, new_position, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
		eyeball_tween.interpolate_callback(self, 1.0, "animate_iris", new_position)
		eyeball_tween.start()
