extends Node

# Confirm

var state_machine = null

@onready var vehicle_list = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Vehicles/ScrollContainer/VehicleList
@onready var unit_list = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Units/ScrollContainer/VBoxContainer
@onready var upfront_cost = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/UpfrontCost

#var vehicles
#var total_fuel_consumption = 0
#var upfront_cost
#var items_to_collect:Dictionary
#func init(image,_name,amount = 0):
func enter(_msg := {}) -> void:
	var column_item = $ColumnItem
	for i in state_machine.vehicles:
		var new_item = column_item.duplicate()
		new_item.init(i.ui_texture(),i.name())
		vehicle_list.add_child(new_item)
		new_item.visible = true
		new_item.visible = true
	for unit in state_machine.units:
		var new_item = column_item.duplicate()
		new_item.init(unit,unit._name())
		unit_list.add_child(new_item)
		new_item.visible = true
	upfront_cost.text = "Upfront cost: " + str(state_machine.upfront_cost) + " fuel"
	
	$UIElements.visible = true

func exit() -> void:
	pass

func _on_confirm_pressed():
	var convoy = load("res://World/WorldObjects/WO_Convoy/WO_Convoy.gd").new()
	convoy.faction = Global.player_faction
	var vehicles = state_machine.vehicles
	var actions:Array[ConvoyAction] = [
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/ConsumeItem.gd").new({"Fuel":state_machine.upfront_cost}),
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/TravelTo.gd").new(state_machine.destination),
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/LaunchMission.gd").new(state_machine.destination),
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/TravelTo.gd").new(state_machine.current_location),
		load("res://World/WorldObjects/WO_Convoy/ConvoyActions/End.gd").new()
	]
	convoy.init_convoy(state_machine.vehicles,state_machine.current_location,actions)
# func init_convoy(_vehicles:Array[Vehicle],_origin:WorldObject,_actions:Array) -> void:
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module": "MapViewer"})
