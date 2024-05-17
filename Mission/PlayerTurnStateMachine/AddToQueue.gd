extends Node

var state_machine

func enter(_msg:Dictionary={}) -> void:
	state_machine.mission.ui.add_action_button.visible = true
	state_machine.mission.ui.add_action_button.pressed.connect(add_button_pressed)

func add_button_pressed():
	state_machine.mission.ui.add_action_button.visible = false
	var action = {
		"utility":state_machine.chosen_utility,
		"selection_info":state_machine.selection_info
	}
	state_machine.actions.push_back(action)
	state_machine.mission.ui.execute_button.disabled = false
	state_machine.transition_to("ChooseUtility")
	return

var in_progress:bool = false
func utility_complete() -> void:
	state_machine.chosen_utility.complete.disconnect(utility_complete)
	in_progress = false
	state_machine.unit_turn_finished()
	state_machine.transition_to("ChooseUtility")

func input(event) -> void:
	if in_progress:
		return
	if event.is_action_pressed("Esc"):
		state_machine.transition_to("MakeSelection")

func exit() -> void:
	state_machine.mission.ui.add_action_button.visible = false
	state_machine.mission.ui.add_action_button.pressed.disconnect(add_button_pressed)
