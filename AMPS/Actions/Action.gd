extends RefCounted
class_name Action

var is_running:bool = false

func name():
	return "Unnamed Action"

func is_valid(_actor) -> bool:
	return true

func get_cost() -> int:
	return 1000

func get_desireability() -> int:
	return 1
	
func get_score()->float:
	return get_desireability() / get_cost()

func get_preconditions() -> Dictionary:
	return {}

func get_effects() -> Dictionary:
	return {}

func perform(_actor) -> bool:
	return false

func _to_string():
	return name()
