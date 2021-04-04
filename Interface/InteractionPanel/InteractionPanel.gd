extends Control

const DISPLAY_POSITION := Vector2(0, 0)
const HIDDEN_POSITION := Vector2(0, 100)

onready var interaction_label := $NinePatchRect/interactionlabel
onready var tween := $Tween

func _ready() -> void:
	add_to_group("interface")

func reveal_panel(display_label: String) -> void:
	if !tween.is_active():
		_set_text(display_label)

		tween.interpolate_property(self, "rect_position", HIDDEN_POSITION, DISPLAY_POSITION, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

func hide_panel() -> void:
	if !tween.is_active():
		tween.interpolate_property(self, "rect_position", DISPLAY_POSITION, HIDDEN_POSITION, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		tween.interpolate_callback(self, 0.5, "_set_text", "")

func _set_text(display_label: String) -> void:
	interaction_label.bbcode_text = display_label
