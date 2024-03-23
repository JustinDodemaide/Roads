extends Node

@export var mission:Node
var state:Variant
var unit:Unit
var chosen_utility:Variant
var selection_info:Dictionary

signal transitioned(state_name)

func _ready():
	for i in get_children():
		i.state_machine = self

func unit_selected(_unit:Unit):
	# Check if its player's turn
	# Check if unit is player controlled
	if $Confirm.in_progress:
		transition_to("Observation")
		return
	if not _unit.team.is_player:
		transition_to("Observation")
		return
	if _unit.action_points <= 0:
		return
	unit = _unit
	unit.sensors.update()
	Global.mission.ui.unit_selected(unit)
	transition_to("ChooseUtility")

func _input(event):
	state.input(event)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if state != null:
		state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)

func unit_turn_finished() -> void:
	unit.action_points -= chosen_utility.action_point_cost
	# Check if all units are done. If they are, end the turn
	# Otherwise, select first unit with action points available
	for unit in unit.team.units:
		if unit.action_points > 0:
			unit_selected(unit)
			return
	Global.mission.emit_signal("turn_complete")
