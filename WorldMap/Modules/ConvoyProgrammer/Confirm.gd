extends Node

# Confirm

# Make a review screen

var state_machine = null

const ONCE:int = 0
const WHENEVER:int = 1

@onready var vehicle_list = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Vehicles/ScrollContainer/VehicleList
@onready var deposit_list = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Deposit/ScrollContainer/VBoxContainer
@onready var collect_list = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Collect/ScrollContainer/VBoxContainer
@onready var upfront_cost = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/UpfrontCost
@onready var options_button = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/OptionButton

func enter(_msg := {}) -> void:
	var column_item = $ColumnItem
	for i in state_machine.vehicles:
		var new_item = column_item.duplicate()
		new_item.init(i.ui_texture(),i.name())
		vehicle_list.add_child(new_item)
		new_item.visible = true
	$UIElements.visible = true
	for key in state_machine.items_to_deposit_refs:
		var new_item = column_item.duplicate()
		new_item.init(key.menu_icon(),key.item_name(),state_machine.items_to_deposit_refs[key])
		deposit_list.add_child(new_item)
		new_item.visible = true
	for key in state_machine.items_to_collect_refs:
		var new_item = column_item.duplicate()
		new_item.init(key.menu_icon(),key.item_name(),state_machine.items_to_collect_refs[key])
		collect_list.add_child(new_item)
		new_item.visible = true
	upfront_cost.text = "Upfront cost: " + str(state_machine.upfront_cost) + " fuel"

func exit() -> void:
	pass

#var vehicles
#var total_fuel_consumption = 0
#var total_storage_capacity:int
#var destination
#var upfront_cost
#var items_to_deposit_refs:Dictionary
#var items_to_deposit_strings:Dictionary
#var items_to_collect_refs:Dictionary
#var items_to_collect_strings:Dictionary
func _on_confirm_pressed():
	var convoy = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new()
	var vehicles = state_machine.vehicles
	var deposit = state_machine.items_to_deposit_strings
	var collect = state_machine.items_to_collect_strings

	# Collect initial items
	var items = state_machine.items_to_deposit_strings
	for i in items:
		state_machine.current_location.storage[i] -= items[i]
		convoy.storage[i] = items[i]

	var actions:Array[ConvoyAction] = [
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/TravelTo.gd").new(state_machine.destination),
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/TransferItems.gd").new(deposit,collect),
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/TravelTo.gd").new(state_machine.current_location),
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/TransferItems.gd").new(collect,deposit),
	]
	if options_button.selected == ONCE:
		actions.append(load("res://World/WorldObjects/WO_Convoy/ConvoyActions/End.gd").new())
	convoy.init_convoy(vehicles,state_machine.current_location,actions)
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module": "MapViewer"})
