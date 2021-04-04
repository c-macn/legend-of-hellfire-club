extends Area2D

var _is_active: bool = false

# le hack?
var player: KinematicBody2D

onready var sprite: Sprite = $Sprite
onready var interaction_label = $InteractLabel
onready var interation_delay: Timer = $InterationDelay

func _ready() -> void:
	_highlight(Color(0, 0, 0))
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")
	interation_delay.connect("timeout", self, "_on_InteractionDelay_passed")
	
func _input(_event) -> void:
	if Input.is_action_just_pressed("obj_interact") and _is_active:
		interact()

func _highlight(color: Color) -> void:
	if sprite.visible:
		sprite.material.set_shader_param("outline_color", color)

func interact() -> void:
	pass

func set_active(is_active: bool) -> void:
	_is_active = is_active;
	if _is_active:
		get_tree().call_group("interface", "reveal_panel", interaction_label.text)
	else:
		get_tree().call_group("interface", "hide_panel")

func _on_Body_entered(body: KinematicBody2D) -> void:
	if GameConstants.is_Saoirse(body):
		_highlight(Color(255, 255, 255))
		player = body
		
		if !_is_active:
			interation_delay.start(0.2)

func _on_Body_exited(_body: KinematicBody2D) -> void:
	_highlight(Color(0, 0, 0))
	set_active(false)
	interation_delay.stop()

func _on_InteractionDelay_passed() -> void:
	set_active(true)
	interation_delay.stop()

func destroy() -> void:
	queue_free()
