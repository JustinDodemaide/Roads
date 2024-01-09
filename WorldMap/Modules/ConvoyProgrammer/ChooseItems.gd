extends Node

# ChooseItems

@onready var collect = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Collect/ScrollContainer/VBoxContainer
@onready var deposit = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Deposit/ScrollContainer/VBoxContainer

var state_machine = null

func enter(_msg := {}) -> void:
	var column_item = $ColumnItem
	
	var destination_storage = state_machine.current_location.storage
	for item in destination_storage:
		var new_item = column_item.duplicate()
		new_item.init(item,destination_storage[item])
		collect.add_child(new_item)
		new_item.visible = true
	
	var vehicle_items:Dictionary = {}
	for vehicle in state_machine.vehicles:
		var vehicle_storage = vehicle.storage
		for item in vehicle.storage:
			if vehicle_items.has(item):
				vehicle_items[item] += vehicle.storage[item]
			else:
				vehicle_items[item] = vehicle.storage[item]
	
	for item in vehicle_items:
			var new_item = column_item.duplicate()
			new_item.init(item,vehicle_items[item])
			deposit.add_child(new_item)
			new_item.visible = true
	
	$UIElements.visible = true

func exit() -> void:
	$UIElements.visible = false

func _on_confirm_pressed():
	var to_collect = state_machine.items_to_collect
	for column_item in collect.get_children():
		var item = column_item.item
		var amount = column_item.selected_amount
		if amount == 0:
			continue
		if to_collect.has(item):
			to_collect[item] += amount
		else:
			to_collect[item] = amount

	var to_deposit = state_machine.items_to_deposit
	for column_item in deposit.get_children():
		var item = column_item.item
		var amount = column_item.selected_amount
		if amount == 0:
			continue
		if to_collect.has(item):
			to_deposit[item] += amount
		else:
			to_deposit[item] = amount

	state_machine.transition_to("ReviewAndConfirm")

