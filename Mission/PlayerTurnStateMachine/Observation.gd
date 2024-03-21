extends Node

var state_machine

func enter(_msg:Dictionary={}) -> void:
	# Clear selected utility related things
	state_machine.chosen_utility = null
	Global.mission.ui.clear_utility_info()
	Global.mission.ui.clear_utilities()

func input(_event) -> void:
	pass

func exit() -> void:
	pass
