extends Node

@export var mission:Node
var state:Variant
var unit:Unit
var choosen_utility:Item

signal transitioned(state_name)

func _ready():
	for i in get_children():
		i.state_machine = self

func unit_selected(_unit:Unit):
	unit = _unit
	transition_to("ChooseUtility")

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
