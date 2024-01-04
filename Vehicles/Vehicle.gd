extends RefCounted
class_name Vehicle

var storage:Dictionary

func name()->String:
	return "Vehicle"

func ui_texture() -> Texture2D:
	return load("res://World/WorldObjects/WO_Convoy/truck.png")

# How many ItemStacks the Vehicle can carry
func cargo_capacity()->int:
	return 0

func stack_can_be_added(stack:ItemStack) -> bool:
	return true

func add_item_stack(stack:ItemStack) -> void:
	if storage.has(stack.item):
		storage[stack.item] += stack.quantity
	else:
		storage[stack.item] = stack.quantity

#func add_item_stack_array(stack_array:Array[ItemStack]) -> void:
#	storage.append_array(stack_array)

func personnel_capacity()->int:
	return 0

# Quantity of fuel items used per 1 tile of travel
func fuel_consumption() -> int:
	return 1

func overall_health()->int:
	return 1
	
func total_offense()->int:
	return 0

func speed()->float:
	# speed refers to the amount of time it takes to travel from
	# one path point to another. therefore,
	# lower means faster.
	return 1.0
	
func handling()->int:
	return 0

func get_stats()->Dictionary:
	var stats:Dictionary = {"name": name(),
							"cargo capacity": cargo_capacity(),
							"personnel capacity": personnel_capacity(),
							"overall health": overall_health(),
							"total offense": total_offense(),
							"speed": speed(),
							"handling":handling()
							}
	return stats
