extends Sprite

var _center
var angle = 0.0

func _ready():
	_center = global_position
	
func _process(delta):
	angle += 1.0 * delta
	
	var abs_angle = abs(angle) 
	var offset = Vector2(sin(abs_angle), cos(abs_angle)) * 280.0
	position = _center + offset
