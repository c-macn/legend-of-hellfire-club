extends Node2D

export(NodePath) var Saoirse
export(NodePath) var floor_map
export(NodePath) var default_spawn_position
export(int) var spawn_percentage

var Cultist
var floor_tiles: TileMap

onready var Cultist_scene := preload("res://Characters/Cultist/Cultist.tscn")
onready var spawn_timer := $SpawnTimer
onready var chase_timer := $ChaseTimer
onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	if GameState.get_has_met_cultist():
		spawn_timer.start()
		spawn_timer.connect("timeout", self, "_should_spawn_Cultist")
		chase_timer.connect("timeout", self, "despawn_cultitst")
	
	if floor_map:
		floor_tiles = get_node(floor_map)
		
func get_Saoirses_position() -> Vector2:
	return get_node(Saoirse).global_position

func despawn_cultitst() -> void:
	Cultist.phase_out()
	_increase_spawn_percentage()
	_increase_wait_time()
	chase_timer.stop()

func _should_spawn_Cultist() -> void:
	rng.randomize()
	var spawn_chance = rng.randi_range(0, 100)
	
	if spawn_chance <= spawn_percentage:
		_spawn_cultist()
		spawn_timer.stop()

func _spawn_cultist() -> void:
	var position = get_Saoirses_position()
	var spawn_position = _determine_spawn_position(position)
	Cultist = Cultist_scene.instance()
	
	if spawn_position != Vector2.ZERO:
		Cultist.global_position = spawn_position
	else:
		Cultist.global_position = get_node(default_spawn_position).global_position
	
	Cultist.connect("spell_limit_reached", self, "_start_Spawn_Timer")
	add_child(Cultist)
	chase_timer.start()

func is_position_valid(spawn_position: Vector2) -> bool:
	return floor_tiles.get_cellv(spawn_position) != TileMap.INVALID_CELL

func _increase_spawn_percentage() -> void:
	spawn_percentage -= 10
	
	if spawn_percentage <= 0:
		spawn_percentage = 10
		
func _increase_wait_time() -> void:
	spawn_timer.wait_time += 1
	spawn_timer.start(spawn_timer.wait_time)
	
func _start_Spawn_Timer() -> void:
	_increase_spawn_percentage()
	_increase_wait_time()
	chase_timer.stop()
	
func _determine_spawn_position(world_position: Vector2) -> Vector2:
	if floor_tiles:
		var tilemap_position := floor_tiles.world_to_map(world_position)
		var x_mod = Vector2(2, 0)
		var y_mod = Vector2(0, 2)
		
		var left_spawn_point = tilemap_position - x_mod
		var right_spawn_point = tilemap_position + x_mod
		var up_spawn_point = tilemap_position + y_mod
		var down_spawn_point = tilemap_position - y_mod
		
		if is_position_valid(down_spawn_point):
			return floor_tiles.map_to_world(down_spawn_point)
		elif is_position_valid(up_spawn_point):
			return floor_tiles.map_to_world(up_spawn_point)
		elif is_position_valid(left_spawn_point):
			return floor_tiles.map_to_world(left_spawn_point)
		elif is_position_valid(right_spawn_point):
			return floor_tiles.map_to_world(right_spawn_point)
		else:
			return Vector2.ZERO
	else:
		return Vector2.ZERO
