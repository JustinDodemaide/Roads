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
	convoy.faction = Global.player_faction_name
	var vehicles = state_machine.vehicles
	var origin_stop = ConvoyStop.new(state_machine.current_location,{},{})
	var dest_stop = ConvoyStop.new(state_machine.destination,{},{})
	var stops:Array[ConvoyStop] = [origin_stop,dest_stop]
	convoy.init_convoy(vehicles,stops)
#func init_convoy(_vehicles:Array[Vehicle],_stops:Array[ConvoyStop],_circuit:bool = false) -> void:
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",{"module": "MapViewer"})
