extends CanvasLayer

onready var card_puzzle: Control = $CardPuzzle

func _ready():
  add_to_group("interface")

func show_cards(a, b, c):
  card_puzzle.visible = true