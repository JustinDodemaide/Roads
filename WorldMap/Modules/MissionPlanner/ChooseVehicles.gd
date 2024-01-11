extends Node

var state_machine = null

func enter(_msg := {}) -> void:
	var chooser = $UIElements/VehicleSelector
	chooser.init(state_machine.current_location)
	chooser.vehicles_chosen.connect(vehicles_chosen)
	$UIElements.visible = true

func exit() -> void:
	$UIElements.visible = false

func vehicles_chosen(vehicles:Array[Vehicle],stats:Dictionary):
	state_machine.vehicles = vehicles
	
	for i in vehicles:
		state_machine.total_fuel_consumption += i.fuel_consumption()
	state_machine.transition_to("ChooseDestination")
