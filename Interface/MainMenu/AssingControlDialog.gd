extends PopupDialog

signal key_changed

var action_name: String
var selected_key: InputEvent

onready var save_button := $SaveButton
onready var cancel_button := $CancelButton
onready var description_label := $DescriptionLabel
onready var key_choice_label := $KeyChoice

func _ready() -> void:
	save_button.connect("button_down", self, "_on_save_clicked")
	cancel_button.connect("button_down", self, "_cancel")


func _gui_input(event) -> void:
	if visible:
		if event is InputEventMouseButton:
			_set_mouse_choice(event.button_index)
			selected_key = event


func _unhandled_key_input(event) -> void:
	if visible:
		if event is InputEventKey:
			_set_key_choice(OS.get_scancode_string(event.scancode))
			selected_key = event


func set_action_label(action_label: String) -> void:
	var current_text = description_label.get_text()
	var new_text = current_text.replace("[action]", "\"" + _get_action_name_display(action_label) + "\"")
	action_name = action_label
	description_label.set_text(new_text)


func _on_save_clicked() -> void:
	if selected_key:
		_assign_key(action_name, selected_key)
		_cancel()


func _cancel() -> void:
	_set_key_choice("")
	action_name = ""
	selected_key = null
	visible = false


func _set_key_choice(key_string: String) -> void:
	key_choice_label.set_text(key_string)
	
	# hack!? to auto center
	if key_string.length() == 5:
		key_choice_label.anchor_left = 0.42
		key_choice_label.anchor_right = 0.42
		
	elif key_string.length() > 6:
		key_choice_label.anchor_left = 0.35
		key_choice_label.anchor_right = 0.35
		
	else:
		key_choice_label.anchor_left = 0.5
		key_choice_label.anchor_right = 0.5


func _set_mouse_choice(button_index: int) -> void:
	if button_index == BUTTON_LEFT:
		key_choice_label.set_text("LMB")
	
	if button_index == BUTTON_RIGHT:
		key_choice_label.set_text("RMB")
	
	if button_index == BUTTON_MIDDLE:
		key_choice_label.set_text("MMB")
	
	key_choice_label.anchor_left = 0.45
	key_choice_label.anchor_right = 0.45


func _assign_key(action: String, key: InputEvent) -> void:
	if !InputMap.get_action_list(action).empty():
		InputMap.action_erase_event(action, InputMap.get_action_list(action)[0])
		
	if InputMap.action_has_event(action, key):
		Input.action_erase_event(action, key)
	
	InputMap.action_add_event(action, key)
	emit_signal("key_changed")


func _get_action_name_display(action_label: String) -> String:
	if action_label == "walk_up":
		return "Up"
	
	if action_label == "walk_left":
		return "Left"
	
	if action_label == "walk_down":
		return "Down"
	
	if action_label == "walk_right":
		return "Right"
	
	if action_label == "obj_interact":
		return "Interact"
	
	if action_label == "fire":
		return "Shoot"
		
	return "?"
