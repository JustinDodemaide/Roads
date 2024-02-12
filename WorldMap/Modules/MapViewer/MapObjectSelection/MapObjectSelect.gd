extends Control

var object:WorldObject
@onready var world_postion = $VBoxContainer/WorldPos
@onready var faction = $VBoxContainer/Faction
@onready var resources = $VBoxContainer/Resources
@onready var vehicles = $VBoxContainer/Vehicles

func init(_object:WorldObject):
	object = _object
	position = object.world_position
	world_postion.text = str(object.world_position)
	if object.faction == null:
		faction.text = "Unclaimed"
	else:
		faction.text = object.faction.faction_name
	for i in object.resources:
		resources.text = i.item_name() + ", "
	for i in object.vehicles:
		vehicles.text = i.name() + ", "

func _on_level_button_pressed():
	Global.scene_handler.transition_to("res://Level/Level.tscn",{"WorldObject":object})
