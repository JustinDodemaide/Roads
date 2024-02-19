extends Node2D
class_name WorldMapObject

var map
var world_object:WorldObject
signal clicked(mo:WorldMapObject)

@export var button:Button

func init(object:WorldObject)->void:
	world_object = object
	position = world_object.world_position
	button.icon = world_object.map_texture()

func update() -> void:
	init(world_object)

func _on_button_pressed():
	emit_signal("clicked",self)
