extends Node2D

@export var level:Node

func _on_button_pressed():
	var menu = load("res://Level/LevelScenes/CharacterEditor/CharacterEditor.tscn").instantiate()
	menu.level = level
	add_child(menu)
