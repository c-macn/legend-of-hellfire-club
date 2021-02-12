extends Light2D

export(float) var increment_cycle = 0.5

const MAX_VALUE: int = 100000000

var initial_value: float = 0.0
var value: float = initial_value

onready var noise = OpenSimplexNoise.new()

func _ready() -> void:
	randomize()
	value = randi() % MAX_VALUE
	noise.period = 12

func _physics_process(_delta: float) -> void:
	value += increment_cycle

	if value > MAX_VALUE:
		value = initial_value

	var alpha = get_alpha_from_value(value)
	color = Color(color.r, color.g, color.b, alpha)

func get_alpha_from_value(current_value) -> float:
	var noise_value = noise.get_noise_1d(current_value) + 1
	return (noise_value / 4.0) + 0.5
