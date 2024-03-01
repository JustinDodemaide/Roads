extends Node

var world_object:WorldObject

# Assumes the player is the only one that can launch missions
var player:Faction
var non_player:Faction
var teams:Array[Team] = [Team.new([],true), Team.new([])]
signal turn_complete

func enter(_msg:Dictionary = {})->void:
	world_object = _msg["location"]

	if world_object.mission_id == 0:
		assign_level()
	else:
		load_level()
	
	teams.append(Team.new(_msg["offense"]))

func exit()->void:
	pass

func assign_level() -> void:
	pass

func load_level() -> void:
	var file_path:String = "res://Mission/MissionLevels/" + str(world_object.mission_id) + ".tres"

#region gameplay loop

func start():
	# Player goes first
	while true:
		for team in teams:
			new_turn(team)
			await turn_complete

func new_turn(team:Team):
	team.new_turn()
	

#endregion
