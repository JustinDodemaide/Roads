extends RefCounted
class_name AI_Info

var offensive_score
var offensive_improvements:Array[String]
var defensive_score

func update() -> void:
	var total_character_score:int = 0
	offensive_score += total_character_score
	defensive_score += total_character_score
	
	var total_vehicle_score:int = 0
	offensive_score += total_vehicle_score

	var isolation_score:int = 0 # Either drop this or make it less expensive somehow
	defensive_score -= isolation_score
