extends Area2D

signal cutscene_start(name)

# The animation to play when player enters the body
export(String) var cutscene_animation_name

# A flag to determine if the cutscene can be trigged multiple times
export(bool) var is_one_shot = true

func _ready() -> void:
	_setup_signals()

func _setup_signals() -> void:
	self.connect("body_entered", self, "_trigger_cutscene")

	if is_one_shot:
		self.connect("body_exited", self, "_cutscene_finished")

func _is_Saoirse(body: KinematicBody2D) -> bool:
	if body:
		return body.name == "Saoirse"
	else:
		return false

func _trigger_cutscene(body: KinematicBody2D) -> void:
	if _is_Saoirse(body):
		emit_signal("cutscene_start", cutscene_animation_name)

func _cutscene_finished(body: KinematicBody2D) -> void:
	if _is_Saoirse(body):
		queue_free()
