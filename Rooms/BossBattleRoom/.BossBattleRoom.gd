extends Node

var previous_index = null

var index_map = {
	"one": null,
	"two": null,
	"three": null
}
var attack_count = 0

onready var cultist: Cultist = $Cultists
onready var cultist_clone: Cultist = $CultistsClone
onready var cultist_clone_2: Cultist = $CultistsClone2

onready var spawn_points: Array = get_node("SpawnPoints").get_children()

func _ready() -> void:
	cultist.connect("cleansed", self, "_Cultist_cleansed")
	cultist.connect("phased_out", self, "_Cultist_phased_out")
	cultist_clone.connect("phased_out", self, "_Cultist_clone_phased_out")
	cultist_clone_2.connect("phased_out", self, "_Cultist_clone_2_phased_out")
	cultist.phase_out()


func _process(delta) -> void:
	pass


func _Cultist_phased_out() -> void:
	cultist.boss_phase_in(_determine_spawn_point(spawn_points, "one"))


func _Cultist_clone_phased_out() -> void:
	cultist_clone.boss_phase_in(_determine_spawn_point(spawn_points, "two"))


func _Cultist_clone_2_phased_out() -> void:
	cultist_clone_2.boss_phase_in(_determine_spawn_point(spawn_points, "three"))


func _determine_spawn_point(available_spawn_points: Array, cultist_key: String) -> Vector2:
	randomize()
	
	var index = randi() % available_spawn_points.size() - 1
	
	if index == index_map.get(cultist_key) or _is_occupied_position(index):
		return _determine_spawn_point(available_spawn_points, cultist_key)
	else:
		index_map[cultist_key] = index
		return available_spawn_points[index].position


func _is_occupied_position(index: int) -> bool:
	var is_occupied = index_map.values().find(index)
	return false if is_occupied == -1 else true


func _Cultist_cleansed(cleansed_count: int) -> void:
	if cleansed_count == 1:
		cultist_clone.phase_out()
	
	elif cleansed_count == 2:
		cultist_clone_2.phase_out()
		
	elif cleansed_count > 3:
		cultist.queue_free()
		cultist_clone.queue_free()
		cultist_clone_2.queue_free()