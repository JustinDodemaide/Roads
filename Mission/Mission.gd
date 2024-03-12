extends Node

var world_object:WorldObject

# Assumes the player is the only one that can launch missions
var player:Faction
var non_player:Faction
var teams:Array[Team]

@onready var tilemap:TileMap = $TileMap
@onready var ui:Control = $UI/MissionUI
@onready var cursor:Area2D = $CursorArea
@onready var player_state_machine:Node = $PlayerTurnStateMachine

signal turn_complete
signal unit_left_clicked(unit:Unit)
signal position_left_clicked(pos:Vector2)

#region initialization
func _ready(): # Just for test purposes, remove later
	enter()

func enter(_msg:Dictionary = {})->void:
	Global.mission = self
	var chars1:Array[Character] = [Character.new(), Character.new()]
	var chars2:Array[Character] = [Character.new(), Character.new()]
	
	make_new_team(chars1,true)
	make_new_team(chars2)
	
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

func make_new_team(characters:Array[Character],player:bool = false) -> void:
	var team_number = teams.size()
	var start_positions:Array[Vector2] = tilemap.get_start_positions(team_number)
	
	var unit_scene:PackedScene = preload("res://Mission/Unit/Unit.tscn")
	var units:Array[Unit] = []
	for character in characters:
		var new_unit = unit_scene.instantiate()
		new_unit.position = start_positions.pop_back()
		new_unit.init(character)
		$Units.add_child(new_unit)
		units.append(new_unit)
	teams.append(Team.new(units,player))

func load_tilemap() -> void:
	var file_path:String = "res://Mission/Missiontilemaps/" + str(world_object.mission_id) + ".tres"
#endregion

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

#region idk
func _process(delta):
	cursor.position = tilemap.get_local_mouse_position()

func _input(event):
	# This doesn't feel like the right place to define all the input/signal
	# functionalities, but I'm refraining from overthinking it
	if event.is_action_pressed("LeftClick"):
		if cursor.get_overlapping_areas().is_empty():
			emit_signal("position_left_clicked",cursor.position)
			return
		var clicked_object = cursor.get_overlapping_areas().front().get_parent()
		if clicked_object is Unit:
			emit_signal("unit_left_clicked",clicked_object)
			return
				
#endregion
