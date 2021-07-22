extends Control

onready var walk_forward_assign_button := $NinePatchRect/GridContainer/WalkForwardAssignButton
onready var walk_left_assign_button := $NinePatchRect/GridContainer/WalkLeftAssignButton
onready var walk_down_assign_button := $NinePatchRect/GridContainer/WalkBackAssignButton
onready var walk_right_assign_button := $NinePatchRect/GridContainer/WalkRightAssignButton
onready var interact_assign_button := $NinePatchRect/GridContainer/InteractAssignButton
onready var shoot_assign_button := $NinePatchRect/GridContainer/ShootAssignButton

func _ready() -> void:
	walk_forward_assign_button.set_text(get_input_key_string("walk_up"))
	walk_left_assign_button.set_text(get_input_key_string("walk_left"))
	walk_down_assign_button.set_text(get_input_key_string("walk_down"))
	walk_right_assign_button.set_text(get_input_key_string("walk_right"))
	interact_assign_button.set_text(get_input_key_string("obj_interact"))
	shoot_assign_button.set_text(get_input_key_string("fire"))


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
	if action_event.button_index == BUTTON_LEFT:
		return "LMB"
	if action_event.button_index == BUTTON_RIGHT:
		return "RMB"
	if action_event.button_index == BUTTON_MIDDLE:
		return "MMB"
	return "?"
