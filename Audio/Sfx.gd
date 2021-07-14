extends Node2D

func play() -> void:
	var audio: AudioStreamPlayer2D = get_node("footstep_" + str(randi() % 5))
	if audio and !audio.is_playing():
		audio.play()
