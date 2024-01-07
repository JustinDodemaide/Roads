extends Control

var available_column
var selected_column
signal vehicles_chosen(vehicles,stats)

func init(location):
	available_column = $VBoxContainer/HBoxContainer/A/ScrollContainer/AvailableColumn
	selected_column = $VBoxContainer/HBoxContainer/S/ScrollContainer/SelectedColumn
	for vehicle in location.vehicles:
		var button = load("res://WorldMap/Modules/ConvoyProgrammer/VehicleSelector/VehicleChooserButton.tscn").instantiate()
		button.init(vehicle)
		button.pressed.connect(button_pressed)
		available_column.add_child(button)
	update()

func button_pressed(button):
	if button.available:
		button.available = false
		available_column.remove_child(button)
		selected_column.add_child(button)
	else:
		button.available = true
		selected_column.remove_child(button)
		available_column.add_child(button)
	update()

func update():
	if selected_column.get_children().is_empty():
		$VBoxContainer/ConfirmButton.disabled = true
	else:
		$VBoxContainer/ConfirmButton.disabled = false
	# Update stats
	var speed = 100000 # Convoy only moves as fast as its slowest vehicle
	var cargo = 0
	var consumption = 0
	for button in selected_column.get_children():
		var vehicle = button.vehicle
		if vehicle.speed() < speed:
			speed = vehicle.speed()
		cargo += vehicle.cargo_capacity()
		consumption += vehicle.fuel_consumption()
	$VBoxContainer/HBoxContainer/Stats/Speed.text = "Speed: " + str(speed)
	$VBoxContainer/HBoxContainer/Stats/Cargo.text = "Cargo: " + str(cargo)
	$VBoxContainer/HBoxContainer/Stats/Consumption.text = "Total fuel consumption: " + str(consumption)

	$ColorRect.custom_minimum_size = $VBoxContainer.size

func _on_confirm_button_pressed():
	var vehicles:Array[Vehicle] = []
	for button in selected_column.get_children():
		vehicles.append(button.vehicle)
	var stats = {}
	stats["total_fuel_consumption"] = int($VBoxContainer/HBoxContainer/Stats/Consumption.text)
	emit_signal("vehicles_chosen",vehicles,stats)
	queue_free()