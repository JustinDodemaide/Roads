extends Node

var state_machine
var selection_script

func enter(_msg:Dictionary={}) -> void:
	state_machine.selection_info = {}
	if state_machine.chosen_utility.selection_type == null:
		state_machine.transition_to("Confirm")
		return
	selection_script = state_machine.chosen_utility.selection_type
	selection_script.selection_made.connect(selection_made)
	selection_script.start(state_machine.unit)

func selection_made(info:Dictionary) -> void:
	selection_script = null
	state_machine.selection_info = info
	state_machine.transition_to("Confirm")

func exit() -> void:
	pass
#	selection_script.selection_made.disconnect(selection_made)
