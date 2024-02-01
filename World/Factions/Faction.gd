extends RefCounted
class_name Faction

var faction_name:String = "Default"
var personality_profile:int
var is_player:bool = false

var current_target:WorldObject
var plan = []

func make_plan():
	var best_target:WorldObject = null
	var best_target_score:int = -1000000
	var best_offensive_location:WorldObject = null
	var best_offensive_score:int = -100000
	# Looking for 2 things: The best target, and best offensive location
	for location in Global.world.world_objects:
		if location.faction.equals(self):
			# Get offensive score
			var offensive_score = location.ai_info.offensive_score
			if offensive_score > best_offensive_score:
				best_offensive_score = offensive_score
				best_offensive_location = location
		else:
			# Get target score
			var score:int = get_target_priority_score(location)
			if score > best_target_score:
				best_target_score = score
				best_target = location
	if best_target == current_target and !plan.is_empty():
		return
	
	if best_offensive_score > best_target_score:
		pass # Attack
	else:
		pass # Make location better

func get_target_priority_score(location:WorldObject) -> int:
	# Based on defense score (lower is better),
	# available resources : needed resources (higher is better)
	# proximity to enemy locations (how easy it is to hold after capturing,
	# lower is better)(this part is up in the air considering how expensive it
	# is to compute)
	return 0


func equals(other:Faction) -> bool:
	# Returns true if this and other are the same faction
	return faction_name == other.faction_name

func save() -> Dictionary:
	return {"what":"Faction",
			"name":faction_name,
			"profile":personality_profile
	}

func _load(data:Dictionary) -> void:
	faction_name = data["name"]
