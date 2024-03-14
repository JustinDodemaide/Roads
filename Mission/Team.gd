extends RefCounted
class_name Team

var units:Array[Unit]
var is_player:bool

func _init(_units:Array[Unit],player:bool):
	is_player = player
	units = _units
	for i in units:
		i.team = self
	if is_player:
		Global.mission.ui.init(self)

func new_turn() -> void:
	for unit in units:
		unit.new_turn()
	
	if is_player:
		Global.mission.player_state_machine.unit_selected(units.front())
	else:
		make_decision()

func make_decision():
	pass
