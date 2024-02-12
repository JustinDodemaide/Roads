extends Node

var world_map
@onready var state = $ChooseUnits

var destination
var upfront_cost
var characters:Array[Character]

func _ready() -> void:
	for child in get_children():
		if child.has_method("enter"):
			child.state_machine = self
	state.enter()

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
