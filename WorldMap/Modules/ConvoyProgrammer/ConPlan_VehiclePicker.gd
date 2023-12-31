extends Node

var state_machine = null

func enter(_msg := {}) -> void:
	var chooser = state_machine.vehicle_chooser
	chooser.init(state_machine.current_location)
	chooser.vehicles_chosen.connect(vehicles_chosen)
	chooser.visible = true

func exit() -> void:
	state_machine.vehicle_chooser.queue_free()

func vehicles_chosen(vehicles:Array[Vehicle]):
	state_machine.transition_to("FollowUpPicker",{"location":state_machine.current_location})
