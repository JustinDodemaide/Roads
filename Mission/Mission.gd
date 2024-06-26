extends Node

var world_object:WorldObject

# Assumes the player is the only one that can launch missions
var player:Faction
var non_player:Faction
var attacking_team:Team
var defending_team:Team

@onready var tilemap:TileMap = $TileMap
@onready var camera:Camera2D = $Camera2D
@onready var ui:Control = $UI/MissionUI
@onready var cursor:Area2D = $CursorArea
@onready var player_state_machine:Node = $PlayerTurnStateMachine
@onready var effect_areas:Node = $EffectAreas

signal turn_complete
signal unit_left_clicked(unit:Unit)
signal position_left_clicked(pos:Vector2)

#region initialization
func _ready(): # Just for test purposes, remove later
	
	enter()

func enter(_msg:Dictionary = {})->void:
	Global.mission = self
	var chars1:Array[Character] = [Character.new()]#, Character.new()]
	var chars2:Array[Character] = [Character.new()]#, Character.new()]
	
	make_new_team(chars1,true,true)
	make_new_team(chars2,false)
	
	start()
	return
	
	world_object = _msg["location"]

	if world_object.mission_id == 0:
		assign_tilemap()
	else:
		load_tilemap()

func exit()->void:
	pass

func assign_tilemap() -> void:
	pass

func make_new_team(characters:Array[Character],attacker:bool,player:bool = false) -> void:
	var team_number = 0
	if attacker:
		team_number = 1
	var start_positions:Array[Vector2] = tilemap.get_start_positions(team_number)
	
	var unit_scene:PackedScene = preload("res://Mission/Unit/Unit.tscn")
	var units:Array[Unit] = []
	for character in characters:
		var new_unit = unit_scene.instantiate()
		new_unit.position = start_positions.pop_back()
		new_unit.init(character)
		$Units.add_child(new_unit)
		units.append(new_unit)
	var team = Team.new(units,player)
	if attacker:
		attacking_team = team
	else:
		defending_team = team
	if player:
		ui.init(team)
	

func load_tilemap() -> void:
	var file_path:String = "res://Mission/Missiontilemaps/" + str(world_object.mission_id) + ".tres"
#endregion

#region gameplay loop

func start():
	# Player goes first
	while true:
		attacking_team.new_turn()
		await turn_complete
		if attacking_team.living_units == 0 or defending_team.living_units == 0:
			break
		
		defending_team.new_turn()
		await turn_complete
		if attacking_team.living_units == 0 or defending_team.living_units == 0:
			break

func new_turn(team:Team):
	team.new_turn()

func team_is_out(team:Team) -> void:
	# Ends the game
	if team == attacking_team:
		attackers_win()
	else:
		defenders_win()
	# Display results? Or pass results into msg argument so they can
	# be displayed by map
	Global.scene_handler.transition_to("res://WorldMap/WorldMap.tscn",)

func attackers_win() -> void:
	$UI/Attackers.visible = true
	world_object.faction = attacking_team.faction

func defenders_win() -> void:
	$UI/Defenders.visible = true

#endregion

#region idk
func _process(delta):
	cursor.position = tilemap.get_local_mouse_position()

func _input(event):
	if event.is_action_pressed("F1"):
		print($TileMap.get_global_mouse_position())
		return
	# This doesn't feel like the right place to define all the input/signal
	# functionalities, but I'm refraining from overthinking it
	if event.is_action_pressed("LeftClick"):
		if cursor.get_overlapping_areas().is_empty():
			emit_signal("position_left_clicked",cursor.position)
			return
		for area in cursor.get_overlapping_areas():
			var clicked_object = area.get_parent()
			if clicked_object is Unit:
				emit_signal("unit_left_clicked",clicked_object)
				camera.move_to(clicked_object.position)
				return

#endregion

func string2effect(string:String) -> Effect:
	return load("res://Mission/Effects/" + string + "/" + string + ".gd").new()
