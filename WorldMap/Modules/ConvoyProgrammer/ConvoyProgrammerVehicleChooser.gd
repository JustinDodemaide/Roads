extends Control

var available_column
var selected_column
signal vehicles_chosen(vehicles,stats)

func init(location):
	available_column = $VBoxContainer/HBoxContainer/A/ScrollContainer/AvailableColumn
	selected_column = $VBoxContainer/HBoxContainer/S/ScrollContainer/SelectedColumn
	for vehicle in location.vehicles:
	#for i in 5:
	#	var vehicle = Vehicle.new()
		var button = load("res://WorldMap/Modules/ConvoyProgrammer/VehicleChooserButton.tscn").instantiate()
		button.init(vehicle)
		button.pressed.connect(button_pressed)
		available_column.add_child(button)

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
	var speed = 0
	var cargo = 0
	var lowest_distance = 100000
	for button in selected_column.get_children():
		var vehicle = button.vehicle
		speed += vehicle.speed()
		cargo += vehicle.cargo_capacity()
		if vehicle.max_fuel_capacity() < lowest_distance:
			lowest_distance = vehicle.max_fuel_capacity()
	$VBoxContainer/HBoxContainer/Stats/Speed.text = "Speed: " + str(speed)
	$VBoxContainer/HBoxContainer/Stats/Cargo.text = "Cargo: " + str(cargo)
	$VBoxContainer/HBoxContainer/Stats/Distance.text = "Max Distance: " + str(lowest_distance)

func _on_confirm_button_pressed():
	var vehicles:Array[Vehicle] = []
	for button in selected_column.get_children():
		vehicles.append(button.vehicle)
	var stats = {}
	stats["max_distance"] = int($VBoxContainer/HBoxContainer/Stats/Distance.text)
	emit_signal("vehicles_chosen",vehicles,stats)
	queue_free()
