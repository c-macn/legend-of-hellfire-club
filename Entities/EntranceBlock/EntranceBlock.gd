extends Area2D

onready var collider: CollisionShape2D = $CollisionPolygon2D;

func _ready() -> void:
	self.connect("body_entered", self, "_on_Body_entered")

func _on_Body_entered(body: KinematicBody2D) -> void:
	if body:
		if body.name == "Saoirse":
			get_tree().call_group("interface", "on_DialogReceived", "saoirse", "cant_leave")
