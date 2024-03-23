extends Node

var state_machine

func enter(_msg:Dictionary={}) -> void:
	state_machine.mission.ui.confirm_button.visible = true
	state_machine.mission.ui.confirm_button.pressed.connect(confirm_button_pressed)

func confirm_button_pressed():
	state_machine.mission.ui.confirm_button.visible = false
	var unit = state_machine.unit
	var utility = state_machine.chosen_utility
	var info = state_machine.selection_info
	in_progress = true
	utility.complete.connect(utility_complete)
	utility.execute(unit,info)

var in_progress:bool = false
func utility_complete() -> void:
	state_machine.chosen_utility.complete.disconnect(utility_complete)
	in_progress = false
	state_machine.unit_turn_finished()
	state_machine.transition_to("Observation")

func input(event) -> void:
	if in_progress:
		return
	if event.is_action_pressed("Esc"):
		state_machine.transition_to("MakeSelection")

func exit() -> void:
	state_machine.mission.ui.confirm_button.visible = false
	state_machine.mission.ui.confirm_button.pressed.disconnect(confirm_button_pressed)
