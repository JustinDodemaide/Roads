extends Node

var state_machine

func enter(_msg:Dictionary={}) -> void:
	state_machine.mission.ui.confirm_button.visible = true
	state_machine.mission.ui.confirm_button.pressed.connect(confirm_button_pressed)

func confirm_button_pressed():
	var unit = state_machine.unit
	var utility = state_machine.chosen_utility
	var info = state_machine.selection_info
	utility.execute(unit,info)
	state_machine.transition_to("Observation")

func exit() -> void:
	state_machine.mission.ui.confirm_button.visible = false
	state_machine.mission.ui.confirm_button.pressed.disconnect(confirm_button_pressed)
