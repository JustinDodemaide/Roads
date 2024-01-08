extends Node

var world_map
var selected_object:WorldObject

func _ready():
	world_map.map_object_clicked.connect(map_object_clicked)
	Global.world.world_update.timeout.connect(update)

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
	text += "faction: " + selected_object.faction + "\n"
	text += "position: " + str(selected_object.world_position) + "\n"
	text += "resources: "
	for i in selected_object.resources:
		text += i.item_name() + " "
	text += "\nstorage: "
	for i in selected_object.storage:
		text += i + " (" + str(selected_object.storage[i]) + "), "
	$ObjectInfo/Label.text = text
	$ObjectInfo.visible = true
	$ObjectInfo.position = selected_object.world_position
