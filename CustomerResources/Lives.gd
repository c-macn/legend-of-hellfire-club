extends Resource

signal reduce_lives(count)

export(int) var lives_count: int

func _init(p_lives_count = 2) -> void:
	lives_count = p_lives_count


func reduce_lives_count() -> void:
	lives_count -= 1
	emit_signal("reduce_lives", lives_count)


func get_lives_count() -> int:
	return lives_count


func restore_lives() -> void:
	lives_count = 2
