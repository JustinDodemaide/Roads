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

#var vehicles
#var total_fuel_consumption = 0
#var upfront_cost
#var items_to_deposit:Dictionary
#var items_to_collect:Dictionary
#func init(image,_name,amount = 0):
func enter(_msg := {}) -> void:
	var column_item = $ColumnItem
	for i in state_machine.vehicles:
		var new_item = column_item.duplicate()
		new_item.init(i.ui_texture(),i.name())
		vehicle_list.add_child(new_item)
		new_item.visible = true
	$UIElements.visible = true
	for key in state_machine.items_to_deposit:
		var new_item = column_item.duplicate()
		new_item.init(key.menu_icon(),key.item_name(),state_machine.items_to_deposit[key])
		deposit_list.add_child(new_item)
		new_item.visible = true
	for key in state_machine.items_to_collect:
		var new_item = column_item.duplicate()
		new_item.init(key.menu_icon(),key.item_name(),state_machine.items_to_collect[key])
		collect_list.add_child(new_item)
		new_item.visible = true
	upfront_cost.text = "Upfront cost: " + str(state_machine.upfront_cost) + " fuel"

func exit() -> void:
	pass

func _on_confirm_pressed():
	var convoy = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new()
	var vehicles = state_machine.vehicles
	var origin = state_machine.current_location
	var dest_stop = ConvoyStop.new(state_machine.destination,state_machine.items_to_deposit,state_machine.items_to_collect)
	if options_button.selected == ONCE:
		convoy.init_convoy_oneshot(vehicles,origin,dest_stop)
#func init_convoy_oneshot(_vehicles:Array[Vehicle],_origin:WorldObject,_destination:ConvoyStop) -> void:
	else:
		var origin_stop = ConvoyStop.new(origin,state_machine.items_to_collect,state_machine.items_to_deposit)
		var stops:Array[ConvoyStop] = [origin_stop,dest_stop]
		convoy.init_convoy_circuit(vehicles,origin,stops)
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module": "MapViewer"})
#func init_convoy_cicruit(_vehicles:Array[Vehicle],_origin:WorldObject,program_stops:Array[ConvoyStop]) -> void:
