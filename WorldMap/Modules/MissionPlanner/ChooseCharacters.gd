extends Node

var state_machine = null

func enter(_msg := {}) -> void:
	var chooser = $UIElements/CharacterSelector
	chooser.init(Global.current_location)
	$UIElements.visible = true

func exit() -> void:
	$UIElements.visible = false

func _on_character_selector_characters_chosen(characters:Array[Character],stats:Dictionary):
	state_machine.characters = characters
	state_machine.transition_to("ChooseDestination")
