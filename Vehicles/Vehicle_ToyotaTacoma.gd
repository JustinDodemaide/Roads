extends Vehicle

func name()->String:
	return "Toyota Tacoma"
	
func cargo_capacity()->int:
	return 4

func personnel_capacity()->int:
	return 2

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
