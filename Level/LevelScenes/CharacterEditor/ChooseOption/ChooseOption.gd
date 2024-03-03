extends Control

var state_machine

func _on_equipment_pressed():
	state_machine.transition_to("ChooseEquipment")

func _on_customize_pressed():
	state_machine.transition_to("CharacterCustomizer")

func _on_back_pressed():
	state_machine.transition_to("CharacterChooser")

func enter(_msg={}):
	pass

func exit():
	pass
