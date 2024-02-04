extends Node

# Assumes the player is the only one that can launch missions
var attacker:Faction
var attacker_convoy:WorldObject
var defender:Faction

var world_object:WorldObject

func enter(_msg:Dictionary = {})->void:
	world_object = _msg["location"]
	defender = world_object.faction
	attacker_convoy = _msg["attacking_convoy"]
	attacker = attacker_convoy.faction
	if world_object.mission_id == 0:
		assign_level()
	else:
		load_level()

func exit()->void:
	pass

func assign_level() -> void:
	pass

func load_level() -> void:
	var file_path:String = "res://Mission/MissionLevels/" + str(world_object.mission_id) + ".tres"

func attacker_victory() -> void:
	world_object.faction = attacker
	world_object.add_vehicles(attacker_convoy.vehicles)
	Global.world.remove_world_object(attacker_convoy)
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",)

func attacker_defeat() -> void:
	attacker_convoy.return_to_origin()
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",)
