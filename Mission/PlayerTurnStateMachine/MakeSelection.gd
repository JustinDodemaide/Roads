extends Node

var state_machine
var selection_script

func enter(_msg:Dictionary={}) -> void:
	state_machine.selection_info = {}
	if state_machine.chosen_utility.selection_type == null:
		state_machine.transition_to("Confirm")
		return
	selection_script = state_machine.chosen_utility.selection_type.new()
	var info = selection_script.get_validity_info(state_machine.unit,state_machine.chosen_utility)
	if info["has_valid_selection"] == false:
		# display info["msg"]
		state_machine.transition_to("ChooseUtility")
		return
	selection_script.selection_made.connect(selection_made)
	selection_script.start(state_machine.unit,state_machine.chosen_utility)

func selection_made(info:Dictionary) -> void:
	selection_script.selection_made.disconnect(selection_made)
	selection_script.clear()
	selection_script = null
	state_machine.selection_info = info
	state_machine.transition_to("Confirm")

func exit() -> void:
	if selection_script != null:
		selection_script.selection_made.disconnect(selection_made)
		selection_script.clear()
		selection_script = null

func input(event) -> void:
	if event.is_action_pressed("Esc"):
		state_machine.transition_to("ChooseUtility")
