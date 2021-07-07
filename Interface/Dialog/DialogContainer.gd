extends Control

signal dialouge_started
signal dialouge_finished

const DIALOG_BASE_URL: String = "res://DialogFiles/dialog.json"

export(int) var reveal_speed: float = 15.0

var current_dialog_set: Dictionary = {} setget set_dialog_set, get_dialog_set
var current_dialog_key: String = "" setget set_dialog_key, get_dialog_key

onready var character_portrait: TextureRect = $DialogPanel/CharacterPortrait/CenterContainer/TextureRect
onready var character_name: RichTextLabel = $DialogPanel/NameContainer/RichTextLabel
onready var dialog_label: RichTextLabel = $DialogPanel/TextContainer/RichTextLabel
onready var reveal_tween: Tween = $RevealTween
onready var next_indicator: TextureRect = $DialogPanel/NextIndicator

func _ready() -> void:
	set_dialog_container_visibility(false)
	_hide_next_indicator()

func _input(_event: InputEvent) -> void:
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
		_show_next_indicator()
	else:
		var dialog_set = get_dialog_set()
		var dialog_key = get_dialog_key()
		
		if should_dialog_continue(dialog_set, dialog_key):
			_hide_next_indicator()
			if typeof(dialog_set.get(dialog_key).next) == TYPE_DICTIONARY:

				if get_dialouge_condition_result(dialog_set.get(dialog_key).next.group, dialog_set.get(dialog_key).next.condition):
					set_dialog_key(dialog_set.get(dialog_key).next.pass)
					set_dialog_text(dialog_set.get(get_dialog_key()).value)
				else:
					_end_dialouge()
			else:
				set_dialog_key(dialog_set.get(dialog_key).next)
				set_dialog_text(dialog_set.get(get_dialog_key()).value)
		else:
			_end_dialouge()

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
	reveal_tween.interpolate_callback(self, time_to_reveal, "_show_next_indicator")

func end_reveal_animation() -> void:
	reveal_tween.seek(reveal_tween.get_runtime())

func on_DialogReceived(chararacter: String, dialog_key: String, use_alt_portrait: bool = false, should_pause_cutscene = true) -> void:
	var dialog_data: Dictionary = get_file_content()
	var dialog_set: Dictionary = dialog_data.get(chararacter)
	var portrait = dialog_set.portrait if !use_alt_portrait else dialog_set.portrait_alt

	character_name.text = chararacter

	set_dialog_set(dialog_set)
	set_dialog_key(dialog_key)
	set_dialog_text(dialog_set.get(dialog_key).value)
	set_portrait(portrait)
	set_dialog_container_visibility(true)
	get_tree().call_group("actors", "scene_start")
	
	if should_pause_cutscene:
		emit_signal("dialouge_started")

func _end_dialouge() -> void:
	get_tree().call_group("actors", "scene_over")
	set_dialog_container_visibility(false)
	emit_signal("dialouge_finished")
	_hide_next_indicator()

func get_dialouge_condition_result(group_name: String, method_name: String) -> bool:
	var result = null

	for node in get_tree().get_nodes_in_group(group_name):
		if node.has_method(method_name):
			result = node.call(method_name)
	
	return result
	
func _show_next_indicator() -> void:
	next_indicator.visible = true
	
func _hide_next_indicator() -> void:
	next_indicator.visible = false
