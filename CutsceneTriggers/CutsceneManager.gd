extends AnimationPlayer

onready var dialouge_container: Control = get_parent().get_node("CanvasLayer/DialogContainer");

func _ready() -> void:
	dialouge_container.connect("dialouge_started", self, "_pause_current_animation")
	dialouge_container.connect("dialouge_finished", self, "_resume_current_animation")

func _pause_current_animation() -> void:
	stop(false)

func _resume_current_animation() -> void:
	play(assigned_animation)