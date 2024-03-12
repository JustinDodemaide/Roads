extends Node

var state_machine

func enter(_msg:Dictionary={}) -> void:
	var unit = state_machine.unit
	var utility = state_machine.chosen_utility
	var info = state_machine.selection_info
	utility.execute(unit,info)

func exit() -> void:
	pass
