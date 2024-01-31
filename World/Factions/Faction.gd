extends RefCounted
class_name Faction

var faction_name:String = "Default"
var personality_profile:int
var is_player:bool = false

var current_target:WorldObject
var plan = []
var ideal_defense_score:int
var needed_items:Array[Item]
func make_plan():
	var target = get_priority_target()
	place_marker(target.world_position)
	if target == current_target and not plan.is_empty():
		return
	var required_score = defense_score(target)
	var best_offense = get_object_with_best_offense(target)
	var actual_score = best_offense["score"] - ideal_defense_score
	if actual_score >= required_score:
		launch_mission(target)
	else:
		increase_offense(best_offense["object"], best_offense["improvements"], target)

# Returns dict with target and defense score
func get_priority_target() -> WorldObject:
	var highest_object:WorldObject = null
	var highest_score:int = 0
	# Each faction will eventually have their own list of WOs.
	# For now, just use the first available location.
	for potential_target in Global.world.world_objects:
		if potential_target.faction.equals(self):
			continue
			
		var score:int
		score += resource_score(potential_target)
		score += isolation_score(potential_target) # Will return a high value if its isolated from allies, making it a better target to attack
		
		if score > highest_score:
			highest_object = potential_target
			highest_score = score
	return highest_object

func resource_score(object:WorldObject) -> int:
	# Resources needed compared to Resources available at location
	if needed_items.size() == 0:
		return 100
	var total:int = 0
	for resource in object.resources:
		for item in needed_items:
			if item.item_name() == resource.item_name():
				total += 1
	var percent:float = (total / needed_items.size()) * 100
	percent = round(percent)
	return percent

func defense_score(object:WorldObject) -> int:
	# Defense score
	# 	If its close to other enemy locations, its not good
	# 	If its close to other friendly locations, it is good
	#	Total unit score
	
	return 0

func isolation_score(object:WorldObject) -> int:
	#	Higher value means more isolated
	#	object is always going to be an enemy faction
	# 	If its close to other enemy locations, its not good
	# 	If its close to other friendly locations, it is good
	const EFFECTIVE_RANGE:int = 100
	var isolation:int = 0
	for nearby_object in Global.world.world_objects:
		var distance = object.world_position.distance_to(nearby_object.world_position)
		if distance > EFFECTIVE_RANGE:
			continue
		if nearby_object.faction.equals(object.faction):
			# The current object is near an ally
			isolation -= 1
		else:
			# The current object is not near an ally
			isolation += 1
	return isolation

# Returns dict with the object and its score
func get_object_with_best_offense(target:WorldObject) -> Dictionary:
	var best_object:WorldObject = null
	var best_score:int = -1
	for object in Global.world.world_objects:
		if not object.faction.equals(self):
			continue
		
		var improvements:Array = []
		var score:int = 0
		score += offense_score(object,improvements)
		score += resource_requirement(object,target)
		
		if score > best_score:
			best_object = object
			best_score = score

		# Eventually, sort improvements by order of importance?
	return {"object":best_object, "score":best_score, "improvements":[]}

func offense_score(object:WorldObject,improvements:Array) -> int:
	# Criteria:
	# Total power score of characters
	# Vehicle offense and defense score
	var total:int = 0
	
	var total_character_score:int = 0
	for character in object.characters:
		total_character_score += character.potential()
	if total_character_score < 10: # Arbitrary threshold
		improvements.append("Units")
	total += total_character_score
	
	var total_vehicle_score:int = 0
	for vehicle in object.vehicles:
		total_vehicle_score += vehicle.total_offense()
	if total_vehicle_score < 10: # Arbitrary threshold
		improvements.append("Vehicles")
	
	return total

func resource_requirement(object:WorldObject,target:WorldObject) -> int:
	return 0

func launch_mission(target:WorldObject) -> void:
	pass

func place_marker(where):
	var sprite = Sprite2D.new()
	sprite.texture = load("res://dot.png")
	sprite.position = where
	sprite.scale = Vector2(4,4)
	sprite.z_index = 6
	Global.world.add_child(sprite)

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
