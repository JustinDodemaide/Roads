extends Node2D



func _on_button_pressed():
	var menu = load("res://Level/LevelScenes/CharacterCustomizer/CharacterChooser/CharacterChooser.tscn").instantiate()
	menu.level_object = self
	add_child(menu)
