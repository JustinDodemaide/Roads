extends Node

var world
var scene_handler

var player_turn_phase:int
enum {BUILD, ATTACK, REPOSITION}

@onready var player_turn_handler = preload("res://PlayerTurn/PlayerTurnHandler.gd").new()

func save_game() -> void:
	world.save()

func research_complete(_category:String,_path:String):
	pass
