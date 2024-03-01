extends RefCounted
class_name Team

var units:Array[Unit]
var is_player:bool

func _init(characters:Array[Character],player:bool = false):
	is_player = player
	var unit_scene:PackedScene = preload("res://Mission/Unit/Unit.tscn")
	for character in characters:
		var new_unit = unit_scene.instantiate()
		new_unit.init(character)
		units.append(new_unit)

func new_turn() -> void:
	for unit in units:
		unit.new_turn()
