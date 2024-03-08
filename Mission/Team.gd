extends RefCounted
class_name Team

var units:Array[Unit]
var is_player:bool

func _init(_units:Array[Unit],player:bool = false):
	is_player = player
	units = _units

func new_turn() -> void:
	for unit in units:
		unit.new_turn()
	
	if is_player:
		pass
	else:
		make_decision()

func make_decision():
	pass
