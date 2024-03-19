extends RefCounted
class_name Effect

var remaining_applications:int = max_applications()

func name() -> String:
	return "Effect"

func max_applications() -> int:
	return 1

func apply(unit:Unit) -> void:
	pass
	#remaining_applications -= 1
	#if remaining_applications == 0:
	#	unit.effects.erase(self)
