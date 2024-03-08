extends Node

@export var mission:Node
var state:Variant
var unit:Unit
var chosen_utility:Item
var selection_info:Dictionary

signal transitioned(state_name)

func _ready():
	for i in get_children():
		i.state_machine = self

func unit_selected(_unit:Unit):
	unit = _unit
	Global.mission.ui.unit_selected(unit)
	transition_to("ChooseUtility")

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if state != null:
		state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
