extends Node

var state_machine

func enter(_msg:Dictionary={}) -> void:
	# Clear selected utility related things
	state_machine.chosen_utility = null
	var unit = state_machine.unit
	
	Global.mission.ui.clear_utility_info()
	
	# Make buttons for all the unit's utilities
	Global.mission.ui.clear_utilities()
	var button_scene:PackedScene = load("res://Mission/UIElements/UtilityButton/UtilityButton.tscn")
	for utility in state_machine.unit.utilities:
		# Making the button *should* be the responsibility of the UI,
		# but this way is much better than daisy-chaining several different
		# signal calls just so this script knows when a button is pressed
		var button = button_scene.instantiate()
		button.init(utility)
		button.utility_chosen.connect(utility_chosen)
		Global.mission.ui.add_utility(button)
		if not utility.is_valid(unit):
			button.disabled = true

func utility_chosen(utility:Item) -> void:
	# Just putting all the "exit" things here
	state_machine.chosen_utility = utility
	Global.mission.ui.set_utility_info(utility)
	Global.mission.ui.clear_utilities()
	state_machine.transition_to("MakeSelection")

func input(event) -> void:
	if event.is_action_pressed("Esc"):
		state_machine.transition_to("Observation")

func exit() -> void:
	pass
