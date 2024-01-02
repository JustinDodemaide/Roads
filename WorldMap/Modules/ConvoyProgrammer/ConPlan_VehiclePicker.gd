extends Node

var state_machine = null

func enter(_msg := {}) -> void:
	var chooser = state_machine.vehicle_chooser
	chooser.init(state_machine.current_location)
	chooser.vehicles_chosen.connect(vehicles_chosen)
	chooser.visible = true

func exit() -> void:
	state_machine.vehicle_chooser.queue_free()

func vehicles_chosen(vehicles:Array[Vehicle],stats:Dictionary):
	state_machine.vehicles = vehicles
	state_machine.vehicle_stats = stats
	
	for i in vehicles:
		state_machine.initial_items.append_array(i.storage)
		state_machine.total_fuel_consumption += i.fuel_consumption()
	state_machine.transition_to("FollowUpPicker",{"location":state_machine.current_location})
