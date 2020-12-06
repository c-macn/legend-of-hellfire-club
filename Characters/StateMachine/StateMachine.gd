extends Node

signal state_changed(current_state)

export(NodePath) var start_state

var state_map: Dictionary = {}
var state_stack: Array = []
var current_state: State = null

var _active: bool = false setget set_active

func _ready() -> void:
	if not start_state:
		start_state = get_child(0).get_path()
	connect_child_node_signals(get_children())
	initialize(start_state)

func connect_child_node_signals(child_nodes) -> void:
	for child in child_nodes:
		child.connect("transition_to_state", self, "_change_state")

func initialize(initial_state: NodePath) -> void:
	set_active(true)
	state_stack.push_front(get_node(initial_state))
	current_state = state_stack[0]
	current_state.enter()

func set_active(value: bool) -> void:
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		state_stack = []
		current_state = null

func _input(event: InputEvent) -> void:
	current_state.handle_input(event)

func _physics_process(delta: float) -> void:
	current_state.update(delta)

func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)

func _change_state(state_name):
	if not _active:
		return
	current_state.exit()

	if state_name == "previous":
		state_stack.pop_front()
	else:
		state_stack[0] = state_map[state_name]

	current_state = state_stack[0]
	emit_signal("state_changed", current_state)

	if state_name != "previous":
		current_state.enter()
