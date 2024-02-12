extends Node

var world
var scene_handler

func save_game() -> void:
	world.save()

func research_complete(_category:String,_path:String):
	pass
