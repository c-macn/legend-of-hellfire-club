extends Control

const DIALOG_BASE_URL: String = "res://DialogFiles/dialog.json"

export(int) var reveal_speed: int = 15

var current_dialog_set: Dictionary = {} setget set_dialog_set, get_dialog_set
var current_dialog_key: String = "" setget set_dialog_key, get_dialog_key

onready var character_portrait: TextureRect = $HBoxContainer/CharacterPortraitContainer/CenterContainer/TextureRect
onready var dialog_label: RichTextLabel = $HBoxContainer/DialogContainer/RichTextLabel
onready var reveal_tween: Tween = $HBoxContainer/DialogContainer/RevealTween

func _ready() -> void:
	set_dialog_container_visibility(false)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if is_dialog_container_visible():
			on_dialog_continue_pressed()

func set_dialog_container_visibility(is_visible: bool) -> void:
	visible = is_visible

func is_dialog_container_visible() -> bool:
	return visible

func on_dialog_continue_pressed() -> void:
	if reveal_tween.is_active():
		end_reveal_animation() # skip to the end for impatient players #ADHD_ME
	else:
		var dialog_set = get_dialog_set()
		var dialog_key = get_dialog_key()

		if should_dialog_continue(dialog_set, dialog_key):
			set_dialog_key(dialog_set.get(dialog_key).next)
			set_dialog_text(dialog_set.get(dialog_key).value)
		else:
			get_tree().call_group("actors", "scene_over")
			set_dialog_container_visibility(false)

func get_file_content() -> Dictionary:
	var file = File.new()

	file.open(DIALOG_BASE_URL, file.READ)

	var json_data = file.get_as_text()
	var parsed_json = JSON.parse(json_data)

	file.close()

	return parsed_json.result

func set_dialog_set(dialog_set: Dictionary) -> void:
	current_dialog_set = dialog_set

func get_dialog_set() -> Dictionary:
	return current_dialog_set

func set_dialog_key(dialog_key: String) -> void:
	current_dialog_key = dialog_key

func get_dialog_key() -> String:
	return current_dialog_key

func should_dialog_continue(dialog_set, dialog_key) -> bool:
	var dialog_object: Dictionary = dialog_set.get(dialog_key)
	return dialog_object.has("next")

func set_dialog_text(text: String) -> void:
	var time_to_reveal = text.length() / reveal_speed
	dialog_label.bbcode_text = ""
	dialog_label.percent_visible = 0
	dialog_label.bbcode_text = text

	animate_text(time_to_reveal)

func set_portrait(character_portrait_texture) -> void:
	character_portrait.texture = load(character_portrait_texture)

func animate_text(time_to_reveal: int) -> void:
	reveal_tween.interpolate_property(dialog_label, "percent_visible", 0, 1, time_to_reveal, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	reveal_tween.start()

func end_reveal_animation() -> void:
	reveal_tween.seek(reveal_tween.get_runtime())

func on_DialogReceived(chararacter: String, dialog_key: String) -> void:
	var dialog_data: Dictionary = get_file_content()
	var dialog_set: Dictionary = dialog_data.get(chararacter)

	set_dialog_set(dialog_set)
	set_dialog_key(dialog_key)
	set_dialog_text(dialog_set.get(dialog_key).value)
	set_portrait(dialog_set.portrait)
	set_dialog_container_visibility(true)
