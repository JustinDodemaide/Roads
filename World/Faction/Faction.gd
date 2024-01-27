extends RefCounted
class_name Faction

func _name() -> String:
	return ""

var current_target:WorldObject
var plan = []
var ideal_defense_score:int
func make_plan():
	var target_info = get_priority_target()
	var target = target_info["object"]
	if target == current_target and not plan.is_empty():
		return
	var required_score = target_info["score"]
	var best_offense = get_object_with_best_offense(target)
	var actual_score = best_offense["score"] - ideal_defense_score
	if actual_score >= required_score:
		launch_mission(target)
	else:
		increase_offense(best_offense["object"], best_offense["improvements"], target)

# Returns dict with target and defense score
func get_priority_target() -> Dictionary:
	# Criteria: Resources needed compared to Resources available at location
	# If its close to other enemy locations, its not good
	# If its close to other friendly locations, it is good
	# Defensive score
	return {"object":null, "score": 0}

# Returns dict with the object and its score
func get_object_with_best_offense(target:WorldObject) -> Dictionary:
	return {"object":null, "score":0, "improvements":[]}

func launch_mission(target:WorldObject) -> void:
	pass;

# Using the improvements suggested by "get_object_with_best_offense",
# create an action plan to increase the chance of winning a mission
# against the target.
func increase_offense(location:WorldObject, improvements:PackedStringArray, target:WorldObject) -> void:
	for improvement in improvements:
		pass

#The AI should be maximizing the defensive capability of each of its locations at all times
#Maybe each update, choose between (attempting to) attack a target, and increasing general defense
#It can be random, or alternating, or some other way of deciding
#
#Attempt to attack target:
#get_priority_target
#If priority target is the same as current priority target and theres still a plan, do nothing
#else,
#get_best_offense_score(target)
#actual offense score = best offense score - ideal defense score
#if actual offense > threshold
	#launch mission (target)
#else
	#increase offense (best offense score location)
#
#best offense score = 100000
#best offense score location = null
#get_best_offense_score(location,target)
	#criteria - resources needed to get to target
	#for location in owned locations
		#var improvements = \[]
		#if criteria  < threshold
			#improvements.append(criteria)
		#if total offense score > best offense score
			#best offense score = total offense score
			#best offense location = location
#
#Increase general defense:
#Find location with lowest defense (including criteria needed to increase it)
#Execute on criteria
