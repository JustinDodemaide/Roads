extends Control

var level_object
@export var list:VBoxContainer
@export var button:Button

func _ready():
	for character in Global.current_location.characters:
		var dup = button.duplicate()
		dup.init(character)
		list.add_child(dup)

func _on_character_chosen(character):
	var customization_menu = load("res://Level/LevelScenes/CharacterCustomizer/CustomizeCharacter/CharacterCustomizer.tscn").instantiate()
	level_object.add_child(customization_menu)
	customization_menu.init(character,level_object)
	queue_free()


func _on_close_pressed():
	queue_free()
