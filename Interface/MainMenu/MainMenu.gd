extends Control

enum MENU_BUTTONS {
	STORY = 0,
	PLAY = 1,
	CREDITS = 2
}

var _selected_button = 0

onready var buttons = $ButtonContainer.get_children()
onready var button_cursor = $Cursor

func _ready() -> void:
	$CanvasLayer/SceneTransition.fade_out()
	get_tree().get_root().connect("size_changed", self, "update_cursor_position_on_resize")
	update_cursor_position(_selected_button)

func _input(_event):
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("walk_left"):
		set_previous_button(_selected_button)
	
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("walk_right"):
		set_next_button(_selected_button)
		
	if Input.is_action_just_pressed("ui_accept"):
		trigger_button_action(_selected_button)
		
func set_next_button(current_button: int) -> void:
	_selected_button = current_button + 1
	
	if _selected_button > buttons.size() -1:
		_selected_button = 0
		
	update_cursor_position(_selected_button)

func set_previous_button(current_button: int) -> void:
	_selected_button = current_button - 1
	
	if _selected_button < 0:
		_selected_button = buttons.size() - 1
		
	update_cursor_position(_selected_button)

func update_cursor_position(current_button: int) -> void:
	var draw_position = buttons[current_button].get_node("Position2D").global_position
	button_cursor.position = draw_position
	
func update_cursor_position_on_resize() -> void:
	update_cursor_position(_selected_button)

func trigger_button_action(current_button: int) -> void:
	if current_button == MENU_BUTTONS.STORY:
		_on_Story_clicked()
	
	if current_button == MENU_BUTTONS.PLAY:
		_on_Play_clicked()
		
	if current_button == MENU_BUTTONS.CREDITS:
		_on_Credits_clicked()

func _on_Play_clicked() -> void:
	load_scene(GameConstants.SCENES.MAIN_ROOM)

func _on_Story_clicked() -> void:
	load_scene(GameConstants.SCENES.MAIN_ROOM)

func _on_Credits_clicked() -> void:
	load_scene(GameConstants.SCENES.BOSS_BATTLE)

func load_scene(scene_index: int) -> void:
	get_tree().change_scene(GameConstants.get_scene(scene_index))
