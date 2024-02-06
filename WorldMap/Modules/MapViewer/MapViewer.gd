extends Node

var world_map
var selected_object:WorldObject

func _ready():
	world_map.map_object_clicked.connect(map_object_clicked)

#var world_position:Vector2
#var resources:Array
#var producers:Array[Producer]
#var storage:Dictionary
#var vehicles:Array[Vehicle]
func map_object_clicked(map_object):
	selected_object = map_object.world_object
	update()

func update():
	if selected_object == null:
		return
	var text = "name: " + selected_object.name() + "\n"
	if selected_object.faction != null:
		text += "faction: " + selected_object.faction.faction_name + "\n"
	text += "position: " + str(selected_object.world_position) + "\n"
	text += "resources: "
	for i in selected_object.resources:
		text += i.item_name() + " "
	text += "\nstorage: "
	for i in selected_object.storage:
		text += i + " (" + str(selected_object.storage[i]) + "), "
	text += "\nvehicles: "
	for i in selected_object.vehicles:
		text += i.name() + ", "
	$ObjectInfo/Label.text = text
	$ObjectInfo.visible = true
	$ObjectInfo.position = selected_object.world_position

func _on_travel_pressed():
	Global.scene_handler.transition_to("res://Level/Level.tscn",  {"WorldObject": selected_object})
