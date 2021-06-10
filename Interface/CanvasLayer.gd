extends CanvasLayer

onready var devil_card := $DevilCard/TextureRect
onready var tween := $DevilCard/Tween

func _ready() -> void:
	devil_card.connect("animation_finished", self, "_add_card_inventory_item")

func reveal_card() -> void:
	var visible_modulate = Color(devil_card.self_modulate.r, devil_card.self_modulate.g, devil_card.self_modulate.b, 1.0)
	
	tween.interpolate_property(devil_card, "self_modulate", devil_card.self_modulate, visible_modulate, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		
	tween.interpolate_callback(self, 0.6, "play_break_away")
	
	tween.start()


func play_break_away() -> void:
	devil_card.play("break-away")


func add_card_inventory_item() -> void:
	# render inventory marker to keep track of collected card pieces
	pass
