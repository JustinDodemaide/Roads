extends RefCounted
class_name Team

var units:Array[Unit]
var is_player:bool
var living_units:int

func _init(_units:Array[Unit],player:bool):
	is_player = player
	units = _units
	for i in units:
		i.team = self
		i.died.connect(unit_died)
	living_units = units.size()

func new_turn() -> void:
	for unit in units:
		unit.new_turn()
	
	if is_player:
		Global.mission.player_state_machine.unit_selected(units.front())
	else:
		make_decision()

func make_decision():
	for i in units:
		i.make_decision()
	pass

func unit_died(unit:Unit) -> void:
	living_units -= 1
	if living_units <= 0:
		Global.mission.team_is_out(self)
