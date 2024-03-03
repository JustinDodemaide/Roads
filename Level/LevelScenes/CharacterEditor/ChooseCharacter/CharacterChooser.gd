extends Control

var state_machine
@export var list:VBoxContainer

func enter(_msg={}):
	for i in list.get_children():
		i.queue_free()
	var list_item_scene:PackedScene = load("res://Level/LevelScenes/CharacterEditor/ChooseCharacter/CharacterChooserListItem/CharacterChooserButton.tscn")
	for character in Global.current_location.characters:
		var item = list_item_scene.instantiate()
		item.init(character)
		item.chosen.connect(_on_character_chosen)
		list.add_child(item)

func _on_character_chosen(character):
	state_machine.character = character
	state_machine.transition_to("EditorOptions")

func _on_close_pressed():
	queue_free()

func exit():
	pass
