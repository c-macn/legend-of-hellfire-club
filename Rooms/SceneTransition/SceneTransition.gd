extends ColorRect

signal transition_finished

onready var animation_player := $AnimationPlayer

func transition_to_new_scene(scene: String) -> void:
	print("CHANGE")
	fade_in()
	yield(animation_player, "animation_finished")
	print(scene)
	get_tree().change_scene(scene)

func fade_in() -> void:
	$AnimationPlayer.play("fade_in")
	
func fade_out() -> void:
	$AnimationPlayer.play("fade_out")
	yield(animation_player, "animation_finished")
	emit_signal("transition_finished")
