extends Node

var world
var scene_handler
var current_location:WorldObject
var player_faction:Faction
var mission_launched:bool = false
var mission

func save_game() -> void:
	world.save()

func research_complete(_category:String,_path:String):
	pass

func string2item(string:String) -> Item:
	var path:String = "res://Items/" + string + "/" + string + ".tres" 
	return load(path)
