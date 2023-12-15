extends Node

signal transitioned(state_name)

@onready var state

func _ready() -> void:
	for child in get_children():
		child.state_machine = self
	state.enter()

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
