extends Control

var lives_count = load("res://CustomerResources/player_lives.tres")

func _ready() -> void:
	lives_count.connect("reduce_lives", self, "_on_Lives_reduced")
	_draw_candles(lives_count.get_lives_count())
	$AnimationPlayer.play("flicker")


func _draw_candles(num_of_lives: int) -> void:
	for i in range(num_of_lives):
		get_node("HBoxContainer/TextureRect_" + str(i)).visible = true


func _on_Lives_reduced(count: int) -> void:
	if count == 2:
		$HBoxContainer/TextureRect_2.visible = false
	if count == 1:
		$HBoxContainer/TextureRect_1.visible = false
	if count == 0:
		$HBoxContainer/TextureRect_0.visible = false
