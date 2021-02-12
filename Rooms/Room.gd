extends Node

const BOX_OFFSET = 100

export(NodePath) var room_tilemap

var Saoirse_scene = preload("res://Characters/Saoirse/Saoirse.tscn")
var Box_scene = preload("res://Objects/Box/Box.tscn")

var Saoirse

func _ready() -> void:
	spawn_Box(GameState.get_box_position())

func spawn_Box(box_position: Vector2) -> void:
	if box_position != Vector2.ZERO:
		var Box = Box_scene.instance()
		Box.position = box_position
		add_child(Box)

func spawn_Saoirse(spawn_point) -> void:
	Saoirse = Saoirse_scene.instance()
	Saoirse.position = spawn_point
	add_child(Saoirse)
	Saoirse.connect("disguise_removed", self, "_on_disguise_removed")

func set_camera_bounds() -> void:
	if Saoirse != null and room_tilemap != null:
		var tile_map: TileMap = get_node(room_tilemap)
		var camera = Saoirse.get_node("Camera2D")
		camera.set_bounds(tile_map.get_used_rect(), tile_map.cell_size)

func update_world_state(new_state: int) -> void:
	GameState.set_world_state(new_state)

func _on_disguise_removed(position: Vector2) -> void:
	var current_scene = get_tree().current_scene.filename
	position.x = position.x + BOX_OFFSET
	GameState.set_box_state(current_scene, position)
	spawn_Box(position)
