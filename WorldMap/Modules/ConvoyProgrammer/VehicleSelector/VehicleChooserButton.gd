extends Control

var available:bool = true
var character:Character
signal pressed(button)

func init(c:Character):
	character = c
	$HBoxContainer/Label.text = character.name

func _on_button_pressed():
	emit_signal("pressed",self)
