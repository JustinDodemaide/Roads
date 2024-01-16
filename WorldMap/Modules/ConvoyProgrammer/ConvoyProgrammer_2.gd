extends Node

var world_map
@onready var current_location = Global.level.world_object

signal transitioned(state_name)
@onready var state = $ChooseVehicles

var vehicles
var total_fuel_consumption = 0
var total_storage_capacity:int
var destination
var upfront_cost
var items_to_deposit_refs:Dictionary
var items_to_deposit_strings:Dictionary
var items_to_collect_refs:Dictionary
var items_to_collect_strings:Dictionary

func _ready() -> void:
	for child in get_children():
		if child.has_method("enter"):
			child.state_machine = self
	state.enter()

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
