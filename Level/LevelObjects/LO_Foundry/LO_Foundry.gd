extends Node2D

func _on_button_pressed():
	var menu = load("res://Level/LevelScenes/FoundryMenu/FoundryMenu.tscn").instantiate()
	add_child(menu)
