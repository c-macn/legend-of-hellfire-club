extends Node2D

const TILE_SIZE: int = 64

onready var map: TileMap = $TileMap
onready var camera: Camera2D = $Saoirse/Camera2D
onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_set_camera_bounds(map.get_used_cells())
	animation_player.play("candles")

func _set_camera_bounds(tilemap_cells) -> void:
	var top_left = map.map_to_world(tilemap_cells[0], false)
	var bottom_right = map.map_to_world(tilemap_cells[tilemap_cells.size() - 1], false)

	camera.set_bounds(top_left.x, top_left.y, bottom_right.x + TILE_SIZE, bottom_right.y + TILE_SIZE)