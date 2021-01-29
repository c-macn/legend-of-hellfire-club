extends Node2D

const MAX_BOUNDS_X: int = 15
const MAX_BOUNDS_Y: int = 10

var banish_target: KinematicBody2D = null

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if banish_target:
		print("I banish ye, ya auld cunt")
	pass

func banish_target(target_path: NodePath) -> void:
	banish_target = get_node(target_path)
