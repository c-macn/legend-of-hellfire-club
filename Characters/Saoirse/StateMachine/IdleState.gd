extends State

enum DEFAULT_IDLE_FRAMES {
	BACKWARD = 0,
	FORWARD = 10,
	LEFT = 3,
	LEFT_DOWN = 3,
	LEFT_UP = 13,
	RIGHT = 7,
	RIGHT_DOWN = 7,
	RIGHT_UP = 16
}

enum BOX_IDLE_FRAMES {
	LEFT = 0,
	RIGHT = 2,
	FORWARD = 4,
	BACKWARD = 6,
	LEFT_UP = 8,
	RIGHT_DOWN = 10,
	RIGHT_UP = 12
	LEFT_DOWN = 14,
}

var default_idles_frames = {
	"walk_back": DEFAULT_IDLE_FRAMES.BACKWARD,
	"walk_down_left": DEFAULT_IDLE_FRAMES.LEFT_DOWN,
	"walk_down_right": DEFAULT_IDLE_FRAMES.RIGHT_DOWN,
	"walk_forward": DEFAULT_IDLE_FRAMES.FORWARD,
	"walk_left": DEFAULT_IDLE_FRAMES.LEFT,
	"walk_right": DEFAULT_IDLE_FRAMES.RIGHT,
	"walk_up_left": DEFAULT_IDLE_FRAMES.LEFT_UP,
	"walk_up_right": DEFAULT_IDLE_FRAMES.RIGHT_UP
}

var box_idles_frames = {
	"box_walk_back": BOX_IDLE_FRAMES.BACKWARD,
	"box_walk_down_left": BOX_IDLE_FRAMES.LEFT_DOWN,
	"box_walk_down_right": BOX_IDLE_FRAMES.RIGHT_DOWN,
	"box_walk_forward": BOX_IDLE_FRAMES.FORWARD,
	"box_walk_left": BOX_IDLE_FRAMES.LEFT,
	"box_walk_right": BOX_IDLE_FRAMES.RIGHT,
	"box_walk_up_left": BOX_IDLE_FRAMES.LEFT_UP,
	"box_walk_up_right": BOX_IDLE_FRAMES.RIGHT_UP
}

func enter() -> void:
	var sprite: Sprite = owner.owner.get_node("Sprite")
	var animation_player = owner.owner.get_node("AnimationPlayer")
	var idle_frames = box_idles_frames if owner.owner.is_disguised() else default_idles_frames
	sprite.frame = get_idle_frame(animation_player.get_current_animation(), idle_frames)
	animation_player.stop()


func handle_input(event: InputEvent):
	return .handle_input(event)


func update(_delta: float) -> void:
	if is_moving():
		emit_signal("transition_to_state", "move")


func is_moving() -> bool:
	return Input.is_action_just_pressed("walk_left") or Input.is_action_just_pressed("walk_right") or Input.is_action_just_pressed("walk_up") or Input.is_action_just_pressed("walk_down")


func get_idle_frame(animation_name: String, frames_dict: Dictionary) -> int:
	var frame = frames_dict.get(animation_name)
	return frame if not frame == null else 0
