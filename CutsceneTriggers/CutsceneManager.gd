extends AnimationPlayer

onready var dialouge_container: Control = get_parent().get_node("CanvasLayer/DialogContainer");

func _ready() -> void:
	self.connect("dialouge_started", dialouge_container, "_pause_current_animation")
	self.connect("dialouge_finished", dialouge_container, "_resume_current_animation")

func _pause_current_animation() -> void:
	stop()

func _resume_current_animation() -> void:
	play()
