extends Node

var state
var character:Character
var level

func _ready():
	for i in get_children():
		i.state_machine = self
	state = $CharacterChooser
	$CharacterChooser.enter()

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	state.exit()
	state.visible = false
	state = get_node(target_state_name)
	state.enter(msg)
	state.visible = true
