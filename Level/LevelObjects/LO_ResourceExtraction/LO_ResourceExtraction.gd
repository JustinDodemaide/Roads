extends Node2D

func _on_button_pressed():
	var menu = load("res://Level/LevelScenes/ProducerMenu/ProducerMenu.tscn").instantiate()
	menu.init(Global.current_location)
	add_child(menu)
