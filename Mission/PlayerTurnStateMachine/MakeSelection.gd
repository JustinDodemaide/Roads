extends Node

var state_machine

func enter(_msg:Dictionary={}) -> void:
	state_machine.selection_info = null
	if state_machine.chosen_utility.selection_type == null:
		state_machine.transition_to("Confirm")
		return
	state_machine.chosen_utility.selection_type.selection_made.connect("selection_made")
	state_machine.chosen_utility.selection_type.start(state_machine.unit)

func selection_made(info:Dictionary) -> void:
	state_machine.selection_info = info
	state_machine.transition_to("Confirm")

func exit() -> void:
	pass
