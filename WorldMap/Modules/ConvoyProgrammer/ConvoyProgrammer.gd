extends Node

# TODO: This can run on a seperate thread without causing problems

var world_map
var current_location
var stops = []

@onready var stop_label = Label.new()
var complete_circuit_button = preload("res://WorldMap/Modules/ConvoyProgrammer/ConvoyProgrammerCompleteCircuit.tscn").instantiate()
var confirm_convoy_button = preload("res://WorldMap/Modules/ConvoyProgrammer/ConvoyStopConfirm.tscn").instantiate()

func execute(map):
	world_map = map
	world_map.map_object_clicked.connect(map_object_clicked)
	current_location = Global.player_location
# 1. Choose vehicles from current location
	var vehicle_chooser = load("res://WorldMap/Modules/ConvoyProgrammer/ConvoyProgrammerVehicleChooser.tscn").instantiate()
	vehicle_chooser.vehicles_chosen.connect(on_vehicles_chosen)
	vehicle_chooser.init(current_location)
	world_map.ui.add_child(vehicle_chooser)

var worst_speed = 1000000
var worst_mileage = 1000000
var worst_fuel_capacity = 100000
func on_vehicles_chosen(vehicles:Array[Vehicle]) -> void:
	for vehicle in vehicles:
		if vehicle.speed() < worst_speed:
			worst_speed = vehicle.speed()
		if vehicle.fuel_consumption() < worst_mileage:
			worst_mileage = vehicle.fuel_consumption()
		if vehicle.max_fuel_capacity() < worst_fuel_capacity:
			worst_fuel_capacity = vehicle.max_fuel_capacity()
	
	world_map.ui.add_child(stop_label)
	complete_circuit_button.pressed.connect(complete_circuit)
	world_map.ui.add_child(complete_circuit_button)
	confirm_convoy_button.pressed.connect(confirm_program)
	world_map.ui.add_child(confirm_convoy_button)
# 2. Allow player to start selecting places for the convoy to stop
	determine_valid_followup_locations(current_location)

var valid_followups:Dictionary = {}
func determine_valid_followup_locations(from:WorldObject):
	valid_followups.clear()
	for i in Global.world.world_objects:
		if i == from:
			continue
		if i.faction != Global.player_faction_name:
			continue
		var path = Global.world.get_astar_path(from,i)
		var fuel_cost = path.size() * worst_mileage

		valid_followups[i] = {"path": path, "fuel cost": fuel_cost}
		draw_path_line(i,path)
	
	if valid_followups.is_empty():
		var label = Label.new()
		label.text = "No valid follow-up locations!"
		world_map.add_child(label)

var lines = {}
func draw_path_line(location,path):
	var line = Line2D.new()
	for pos in path:
		line.add_point(pos)
	randomize()
	var color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),0.75)
	line.default_color = color
	world_map.add_child(line)
	lines[location] = line

var clicked_object:WorldObject
var confirm_prompt
func map_object_clicked(object:WorldMapObject):
	if object.world_object == clicked_object:
		return
	if not valid_followups.has(object.world_object):
		return
	
	if confirm_prompt != null:
		confirm_prompt.queue_free()
	if clicked_object != null:
		lines[clicked_object].default_color.a = 0.75
	
	clicked_object = object.world_object
	lines[clicked_object].default_color.a = 1
# 2.5. If valid location is chosen, load 'confirm' prompt
	confirm_prompt = load("res://WorldMap/Modules/ConvoyProgrammer/ConvoyStopConfirm.tscn").instantiate()
	confirm_prompt.confirmed.connect(stop_confirmed)
	confirm_prompt.position = object.position
	world_map.add_child(confirm_prompt)

func stop_confirmed():
	var obj = clicked_object 
	clicked_object = null
	stops.append(obj)
	for i in lines:
		lines[i].queue_free()
	lines.clear()

	stop_label.text = ""
	for stop in stops:
		stop_label.text += stop.name() + "\n"
	
	if stops.back() == current_location:
		confirm_convoy_button.disabled = false
		complete_circuit_button.disabled = true
	else:
		confirm_convoy_button.disabled = true
		complete_circuit_button.disabled = false
		
	determine_valid_followup_locations(obj)
# 3. When location is confirmed, add it to 'stops', make item selection menu,
#    update total and fuel consumption, get valid follow ups

func item_selected(location,item:ItemStack):
	pass

func item_deselected(location,item:ItemStack):
	pass

func complete_circuit():
	clicked_object = current_location
	stop_confirmed()

func confirm_program():
	world_map.clear_ui()
	for i in lines:
		lines[i].queue_free()
	queue_free()
