extends Control

const DEFAULT_SETTINGS_POSITION := Vector2(712, 0)

func _ready() -> void:
	$Settings.connect("hide_menu", self, "_hide_settings")
	set_visible(false)


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if _can_open_menu():
			$Settings.rect_position = DEFAULT_SETTINGS_POSITION
			set_visible(!visible)
			_pause_game(visible)
			_set_mouse_filter(visible)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()


func _can_open_menu() -> bool:
	return get_tree().get_current_scene().get_name() != "MainMenu"


func _pause_game(is_visible) -> void:
	get_tree().paused = is_visible


func _set_mouse_filter(is_visible) -> void:
	if is_visible:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE


func _hide_settings() -> void:
	$AnimationPlayer.play_backwards("slide_in_settings")


func _on_MainMenu_pressed():
	$AnimationPlayer.play("slide_in_settings")


func _on_Quit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
