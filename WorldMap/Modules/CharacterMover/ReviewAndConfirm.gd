extends Node

# Confirm

var state_machine = null

@onready var unit_list = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Units/ScrollContainer/VBoxContainer
@onready var upfront_cost = $UIElements/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/UpfrontCost

func enter(_msg := {}) -> void:
	var column_item = $ColumnItem
	for character in state_machine.characters:
		var new_item = column_item.duplicate()
		new_item.init(character,character.name)
		unit_list.add_child(new_item)
		new_item.visible = true
	upfront_cost.text = "Upfront cost: " + str(state_machine.upfront_cost) + " fuel"
	
	$UIElements.visible = true

func exit() -> void:
	pass

func _on_confirm_pressed():
	var attacking = state_machine.msg["mission"]
	if attacking:
		Global.scene_handler.transition_to("res://Mission/Mission.tscn",{"location": state_machine.destination,"attacker":Global.world.factions[0]})
	if not attacking:
		var to_be_moved = state_machine.characters
		Global.current_location.remove_characters(to_be_moved)
		state_machine.destination.add_characters(to_be_moved)
		Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn")
