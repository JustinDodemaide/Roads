extends Node

var world
var level
var scene_handler
var player_location:WorldObject
const WORLD_UPDATE_TIME:float = 1.0

var player_faction_name:String = "PLAYER"
const UNCLAIMED_FACTION:String = "Unclaimed"

func save_game() -> void:
	world.save()

func random_color() -> Color:
	randomize()
	return Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))

func research_complete(category:String,path:String):
	pass
