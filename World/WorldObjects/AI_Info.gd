extends RefCounted
class_name AI_Info

var offensive_score:int
var offensive_improvements:Array[String]
var defensive_score:int

const VEHICLE_SCORE_MARGIN:int = 10
const CHARACTER_SCORE_MARGIN:int = 10

func update() -> void:
	offensive_improvements.clear()
	var total_character_score:int = 0
	offensive_score += total_character_score
	defensive_score += total_character_score
	if total_character_score < CHARACTER_SCORE_MARGIN:
		offensive_improvements.append("Characters")
	
	var total_vehicle_score:int = 0
	offensive_score += total_vehicle_score
	if total_vehicle_score < VEHICLE_SCORE_MARGIN:
		offensive_improvements.append("Vehicles")

	var isolation_score:int = 0 # Either drop this or make it less expensive somehow
	defensive_score -= isolation_score
