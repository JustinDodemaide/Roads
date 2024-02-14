extends Node

# Assumes the player is the only one that can launch missions
var attacker:Faction
var defender:Faction

var world_object:WorldObject

func enter(_msg:Dictionary = {})->void:
	world_object = _msg["location"]
	defender = world_object.faction
	attacker = _msg["attacker"]
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
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",)

func attacker_defeat() -> void:
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",)
