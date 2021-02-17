extends Control

var _is_open: bool = false

onready var tween := $Tween

func _input(_event) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):    
		if !tween.is_active():
			if toggle_inventory_open():
				reveal_inventory()
			else:
				hide_inventory()

func reveal_inventory() -> void:
	var intial_position = rect_position
	var display_position = Vector2(intial_position.x + 100, intial_position.y)

	tween.interpolate_property(self, "rect_position", intial_position, display_position, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

func hide_inventory() -> void:
	var intial_position = rect_position
	var hidden_position = Vector2(intial_position.x - 100, intial_position.y)

	tween.interpolate_property(self, "rect_position", intial_position, hidden_position, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

func toggle_inventory_open() -> bool:
	_is_open = !_is_open
	return _is_open
