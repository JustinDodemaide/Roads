extends Node

signal transitioned(state_name)
@onready var state = $VehiclePicker

var world_map
@onready var current_location = Global.level.world_object
var vehicles
var vehicle_stats:Dictionary
var total_fuel_consumption:int = 0
var initial_items:Array[ItemStack]

var stops:Array[ConvoyStop] = []
var upfront_cost:int

# UI element refs
@onready var vehicle_chooser = $UI/ConvoyProgammerVehicleChooser
@onready var complete_circuit_button = $UI/HBoxContainer/CompleteCircuit
@onready var confirm_program_button = $UI/HBoxContainer/Confirm

func _ready() -> void:
	for child in get_children():
		if child.name == "UI":
			continue
		child.state_machine = self
	state.enter()

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)

func add_stop(loc:ConvoyStop,cost:int):
	stops.append(loc)
	upfront_cost += cost
	update_ui()

func update_ui():
	if stops.back() == current_location:
		confirm_program_button.disabled = false
		complete_circuit_button.disabled = true
	else:
		confirm_program_button.disabled = true
		complete_circuit_button.disabled = false
	
	var stop_list = $UI/Stops
	stop_list.text = "Stops: "
	for i in stops:
		stop_list.text += i.destination.name() + " "
	$UI/UpfrontFuel.text = "Upfront fuel cost: " + str(upfront_cost)
	#make_flag()

func _on_complete_circuit_pressed():
	var path = Global.world.get_astar_path(stops.back().destination,current_location)
	add_stop(ConvoyStop.new(current_location),path.size()*total_fuel_consumption)
	transition_to("FollowUpPicker",{"location":current_location})

# init_convoy_program(_vehicles,_origin,program_stops)
func _on_confirm_pressed():
	var convoy = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new()
	
	convoy.init_convoy_program(vehicles,current_location,stops)
	queue_free()

@onready var flag = $ConfirmFollowUp/Button
var flags:Dictionary
func make_flag():
	var location = stops.back()
	var dup = flag.duplicate()
	dup.text = str(stops.size())
	dup.visible = true
	if flags.has(location):
		dup.modulate = flags[location].get_children().front().modulate
		flags[location].add_child(dup)
	else:
		var hbox = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		hbox.position = location.world_position
		hbox.anchors_preset = Control.PRESET_CENTER
		dup.modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
		hbox.add_child(dup)
		add_child(hbox)
		flags[location] = hbox

func convoy_items_before_stop(location:WorldObject) -> Array[ItemStack]:
	var cumulative_items:Array[ItemStack]
	cumulative_items.append_array(initial_items)
	for stop in stops:
		if stop.destination == location:
			break
		cumulative_items = remove(stop.items_consumed,cumulative_items)
		cumulative_items = remove(stop.items_to_deposit,cumulative_items)
		cumulative_items.append_array(stop.items_to_collect)
	return cumulative_items

# Removes all items from set2 from set1
func remove(items:Array[ItemStack],from:Array[ItemStack]) -> Array[ItemStack]:
	#TODO
	return []
