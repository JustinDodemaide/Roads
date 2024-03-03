extends Control

var state_machine
# Things to customize:
# Name
@export var name_edit:TextEdit

func enter(_msg={}) -> void:
	name_edit.text = state_machine.character.name

func _on_confirm_pressed():
	state_machine.character.name = name_edit.text
	state_machine.transition_to("EditorOptions")

func exit():
	pass
