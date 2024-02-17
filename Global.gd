extends Node

var world
var scene_handler
var current_location:WorldObject
var player_faction:Faction

func save_game() -> void:
	world.save()

func research_complete(_category:String,_path:String):
	pass
