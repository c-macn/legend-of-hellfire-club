extends Node
class_name BaseRoom

const BOX_OFFSET = 100

export(NodePath) var room_tilemap

var Saoirse_scene = preload("res://Characters/Saoirse/Saoirse.tscn")
var Box_scene = preload("res://Objects/Box/Box.tscn")

var Saoirse

onready var dialouge_container: Control = $CanvasLayer/DialogContainer
onready var exits := $Exits.get_children()
onready var scene_transition := $CanvasLayer/SceneTransition

func _ready() -> void:
	scene_transition.fade_out()
	setup_scene_transitions()
	spawn_Box(GameState.get_box_position())
	#$CanvasModulate.visible = true


func spawn_Box(box_position: Vector2) -> void:
	if box_position != Vector2.ZERO:
		var Box = Box_scene.instance()
		add_child(Box)


func spawn_Saoirse(spawn_point) -> void:
	Saoirse = Saoirse_scene.instance()
	Saoirse.position = spawn_point
	Saoirse.connect("disguise_removed", self, "_on_disguise_removed")
	add_child(Saoirse)


func set_camera_bounds() -> void:
	pass


func update_cutscene_state(animation_name: String) -> void:
	GameState.update_cutscene_state(animation_name)


func init_dialouge(character_name: String, dialouge_key: String) -> void:
	if character_name == "saoirse":
		dialouge_container.on_DialogReceived(character_name, dialouge_key, get_tree().get_nodes_in_group("Saoirse")[0].call("is_disguised"))
	else:
		dialouge_container.on_DialogReceived(character_name, dialouge_key)


func setup_scene_transitions() -> void:
	for exit in exits:
		if !exit.is_connected("transition_to_scene", scene_transition, "transition_to_new_scene"):
			exit.connect("transition_to_scene", scene_transition, "transition_to_new_scene")


func _on_disguise_removed(position: Vector2) -> void:
	var current_scene = GameState._current_scene # TODO add getter
	var new_position = Vector2(position.x + BOX_OFFSET, position.y)
	GameState.set_box_state(current_scene, position)
	spawn_Box(new_position)


func fade_in() -> void:
	scene_transition.fade_in()


func fade_out() -> void:
	scene_transition.fade_out()
