extends Control

signal hide_menu

var key_translations = {
	"BraceLeft": "",
	"BraceRight": "",
	"Minus": "-",
	"Equal": "=",
	"Semicolon": ";",
	"Slash": "/",
	"BackSlash": "\\",
	"Control": "Ctrl",
	"PageUp": "PgUp",
	"PageDown": "PgDn",
	"Unknown": "N/A",
	"Comma": ",",
	"Period": ".",
	"Apostrophe": "'",
	"QuoteLeft": "\"",
}

onready var walk_forward_assign_button := $NinePatchRect/GridContainer/WalkForwardAssignButton
onready var walk_left_assign_button := $NinePatchRect/GridContainer/WalkLeftAssignButton
onready var walk_down_assign_button := $NinePatchRect/GridContainer/WalkBackAssignButton
onready var walk_right_assign_button := $NinePatchRect/GridContainer/WalkRightAssignButton
onready var interact_assign_button := $NinePatchRect/GridContainer/InteractAssignButton
onready var shoot_assign_button := $NinePatchRect/GridContainer/ShootAssignButton
onready var assign_key_popup := $AssingControlDialog
onready var cancel_button := $NinePatchRect/Cancel

func _ready() -> void:
	_assign_button_text()
	_connect_button_signals()
	assign_key_popup.connect("key_changed", self, "_assign_button_text")


func get_input_key_string(key_action: String) -> String:
	var action_list = InputMap.get_action_list(key_action)
	if action_list.empty():
		return "N/A"
	else:
		if action_list[0] is InputEventMouseButton:
			return get_mouse_button_text(action_list[0])
		else:
			return action_list[0].as_text()


func get_mouse_button_text(action_event: InputEventMouseButton) -> String:
	var button_index = action_event.button_index
	if button_index == BUTTON_LEFT:
		return "LMB"
	if button_index == BUTTON_RIGHT:
		return "RMB"
	if button_index == BUTTON_MIDDLE:
		return "MMB"
	return "?"


func _assign_button_text() -> void:
	walk_forward_assign_button.set_text(_get_key_display_string("walk_up"))
	walk_left_assign_button.set_text(_get_key_display_string("walk_left"))
	walk_down_assign_button.set_text(_get_key_display_string("walk_down"))
	walk_right_assign_button.set_text(_get_key_display_string("walk_right"))
	interact_assign_button.set_text(_get_key_display_string("obj_interact"))
	shoot_assign_button.set_text(_get_key_display_string("fire"))


func _connect_button_signals() -> void:
	walk_forward_assign_button.connect("button_down", self, "_open_popup", ["walk_up"])
	walk_left_assign_button.connect("button_down", self, "_open_popup", ["walk_left"])
	walk_down_assign_button.connect("button_down", self, "_open_popup", ["walk_down"])
	walk_right_assign_button.connect("button_down", self, "_open_popup", ["walk_right"])
	interact_assign_button.connect("button_down", self, "_open_popup", ["obj_interact"])
	shoot_assign_button.connect("button_down", self, "_open_popup", ["fire"])
	cancel_button.connect("button_down", self, "_hide_menu")


func _open_popup(action_name: String) -> void:
	$AssingControlDialog.set_action_label(action_name)
	$AssingControlDialog.popup()


func _get_key_display_string(action_name: String) -> String:
	var key_name = get_input_key_string(action_name)
	
	if key_translations.get(key_name):
		return key_translations.get(key_name)
	else:
		return key_name


func _hide_menu() -> void:
	emit_signal("hide_menu")
