extends Area2D

var _is_active: bool = false

onready var sprite: Sprite = $Sprite
onready var interaction_label = $InteractLabel

func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")

func _input(_event) -> void:
	if Input.is_action_just_pressed("obj_interact") and _is_active:
		_interact()

func _highlight() -> void:
	sprite.material.set_shader_param("outline_color", Color(255, 0, 255))

func _interact() -> void:
	print("I have been interacted with")

func set_active(is_active: bool) -> void:
	_is_active = is_active;
	interaction_label.visible = is_active

func _on_Body_entered(body: KinematicBody2D) -> void:
	if body:
		if body.name == "Saoirse":
			_highlight()
			set_active(true)

func _on_Body_exited(_body: KinematicBody2D) -> void:
	set_active(false)
