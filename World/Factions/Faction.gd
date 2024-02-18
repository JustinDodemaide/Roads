extends RefCounted
class_name Faction

var faction_name:String = "Default"
var id:int
var personality_profile:int
var is_player:bool = false

var inventory:Dictionary

var current_target:WorldObject
var plan:Array[FactionAction] = []

var needed_resources:Array[String]

signal turn_complete

func _init(player:bool = false):
	is_player = player
	if is_player:
		Global.player_faction = self

func begin_turn() -> void:
	if is_player:
		await Global.world.end_turn_button.pressed
	else:
		make_decision()
	emit_signal("turn_complete")

func turn_over():
	emit_signal("turn_complete")

func make_decision():
	return
	print("Faction ", faction_name, " making plan...")
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
				print("new best target")
				best_target_score = score
				best_target = location
	if best_target == current_target and !plan.is_empty():
		return
	
	var sprite = Sprite2D.new()
	sprite.position = best_target.world_position
	sprite.texture = load("res://dot.png")
	sprite.scale = Vector2(4,4)
	Global.world.add_child(sprite)
	
	if best_offensive_score > best_target_score:
		launch_attack(best_target)
	else:
		improve_location(best_offensive_location)

func get_target_priority_score(target:WorldObject) -> int:
	var total_score:int = 0
	# Based on defense score (lower is better),
	# available resources : needed resources (higher is better)
	if not needed_resources.is_empty():
		var r:int = 0
		for resource in target.resources:
			if needed_resources.has(resource):
				r += 1
		var percent = (r / needed_resources.size()) * 100
		total_score += percent
	# proximity to enemy locations (how easy it is to hold after capturing,
	# lower is better)(this part is up in the air considering how expensive it
	# is to compute)
	return total_score

func launch_attack(_location:WorldObject) -> void:
	plan.append(load("res://World/Factions/FactionActions/LaunchAttack.gd").new())

func improve_location(location:WorldObject) -> void:
	var improvements = location.ai_info.offensive_improvements
	if improvements.is_empty():
		return
	var improvement = improvements.pick_random()
	# For now, just choose a random
	if improvement == "Characters":
		get_better_characters(location)

func get_better_characters(_location:WorldObject) -> void:
	# Either get more or improve current ones
	pass

func get_better_vehicles(_location:WorldObject) -> void:
	# Either get more or improve current ones
	pass

func save() -> Dictionary:
	return {"what":"Faction",
			"name":faction_name,
			"id":id,
			"profile":personality_profile,
			"player":is_player,
			"inventory":inventory,
	}

func _load(data:Dictionary) -> void:
	faction_name = data["name"]
	id = data["id"]
	is_player = data["player"]
	if is_player:
		Global.player_faction = self
	inventory = data["inventory"]
