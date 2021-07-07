extends Spatial

onready var dialouge_container: Control = $CanvasLayer/DialogContainer
onready var scene_transition := $CanvasLayer/SceneTransition

func _ready() -> void:
	$AudioStreamPlayer3D.play()
	yield(get_tree().create_timer(2.0), "timeout")
	scene_transition.blink()
	$AnimationPlayer.play("get_up")
