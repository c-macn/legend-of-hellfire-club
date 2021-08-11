extends Control

enum MENU_BUTTONS {
	PLAY = 0,
	SETTINGS = 1,
	CREDITS = 2,
	QUIT = 3
}

const OPENING_CRAW_SCENE = "res://Rooms/OpeningCrawl/Crawl.tscn"
const BOSS_BATTLE_SCENE = "res://Rooms/BossBattleRoom/BossBattleRoom.tscn"

var _selected_button = 0
var lives_count = load("res://CustomerResources/player_lives.tres")

onready var buttons = $ButtonContainer.get_children()
onready var animation := $AnimationPlayer

func _ready() -> void:
	if GameState.has_collected_all_cards():
		$ButtonContainer/VBoxContainer/Play.text = "Continue"
		
	$CanvasLayer/SceneTransition.fade_out()
	$Settings.connect("hide_menu", self, "_hide_controls")
	$AnimationPlayer.play("buttons_slide_in")
	
	lives_count.restore_lives()
	_grab_button_focus(_selected_button)


func update_cursor_position(current_button: int) -> void:
	var draw_position = buttons[current_button].get_node("Position2D").global_position
	_grab_button_focus(current_button)


func _on_Play_clicked() -> void:
	var scene_to_load = OPENING_CRAW_SCENE if !GameState.has_collected_all_cards() else BOSS_BATTLE_SCENE
	load_scene(scene_to_load)


func _on_Credits_clicked() -> void:
	$CanvasLayer/SceneTransition.transition_to_new_scene("res://Interface/Credits/Credits.tscn")


func _on_Settings_clicked() -> void:
	$AnimationPlayer.play_backwards("buttons_slide_in")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("settings_slide_in")


func load_scene(scene_name: String) -> void:
	get_tree().change_scene(scene_name)


func get_button_label_node_name(current_button: int) -> String:
	if current_button == MENU_BUTTONS.PLAY:
		return "Play"
	if current_button == MENU_BUTTONS.SETTINGS:
		return "Settings"
	if current_button == MENU_BUTTONS.CREDITS:
		return "Credits"
	if current_button == MENU_BUTTONS.QUIT:
		return "Quit"
	else:
		return ""


func _quit_game() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()


func _grab_button_focus(current_button: int) -> void:
	var button_name = get_button_label_node_name(current_button)
	buttons[current_button].get_node(button_name).grab_focus()


func _on_Play_hovered() -> void:
	_selected_button = MENU_BUTTONS.PLAY
	update_cursor_position(MENU_BUTTONS.PLAY)


func _on_Settings_hovered() -> void:
	_selected_button = MENU_BUTTONS.SETTINGS
	update_cursor_position(MENU_BUTTONS.SETTINGS)


func _on_Credits_hovered() -> void:
	_selected_button = MENU_BUTTONS.CREDITS
	update_cursor_position(MENU_BUTTONS.CREDITS)


func _on_Quit_hovered() -> void:
	_selected_button = MENU_BUTTONS.QUIT
	update_cursor_position(MENU_BUTTONS.QUIT)


func _hide_controls() -> void:
	animation.play_backwards("settings_slide_in")
	yield(animation, "animation_finished")
	animation.play("buttons_slide_in")
