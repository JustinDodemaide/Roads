extends Node

var world_object:WorldObject

# Assumes the player is the only one that can launch missions
var player:Faction
var non_player:Faction
var teams:Array[Team]
signal turn_complete

func enter(_msg:Dictionary = {})->void:
	var chars1 = [Character.new(), Character.new()]
	var chars2 = [Character.new(), Character.new()]
	
	make_new_team(chars1,true)
	make_new_team(chars2)
	
	
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

func make_new_team(characters:Array[Character],player:bool = false) -> void:
	var unit_scene:PackedScene = preload("res://Mission/Unit/Unit.tscn")
	var units:Array[Unit] = []
	for character in characters:
		var new_unit = unit_scene.instantiate()
		new_unit.init(character)
		$Units.add_child(new_unit)
		units.append(new_unit)
	teams.append(Team.new(units,player))

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
