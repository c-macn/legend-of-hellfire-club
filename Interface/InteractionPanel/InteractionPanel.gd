extends Control

onready var interaction_label := $NinePatchRect/interactionlabel
onready var tween := $Tween

func _ready() -> void:
  add_to_group("interface")

func reveal_panel(display_label: String) -> void:
  if !tween.is_active():
    var intial_position = rect_position
    var display_position = Vector2(intial_position.x, intial_position.y  - 100)
    _set_text(display_label)

    tween.interpolate_property(self, "rect_position", intial_position, display_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()

func hide_panel() -> void:
  if !tween.is_active():
    var intial_position = rect_position
    var hidden_position = Vector2(intial_position.x, intial_position.y  + 100)

    tween.interpolate_property(self, "rect_position", intial_position, hidden_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()
    tween.interpolate_callback(self, 0.5, "_set_text", "")

func _set_text(display_label: String) -> void:
  interaction_label.bbcode_text = display_label