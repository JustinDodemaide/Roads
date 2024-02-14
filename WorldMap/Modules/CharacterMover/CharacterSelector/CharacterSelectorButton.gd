extends Control

var available:bool = true
var vehicle:Vehicle
signal pressed(button)

func init(v:Vehicle):
	vehicle = v
	$HBoxContainer/Label.text = vehicle.name()

func _on_button_pressed():
	emit_signal("pressed",self)
