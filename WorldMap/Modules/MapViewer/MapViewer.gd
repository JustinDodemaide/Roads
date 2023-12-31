extends Node

var world_map

func _ready():
	world_map.map_object_clicked.connect(map_object_clicked)

#var world_position:Vector2
#var resources:Array
#var producers:Array[Producer]
#var storage:Dictionary
#var vehicles:Array[Vehicle]
func map_object_clicked(map_object):
	var object = map_object.world_object
	var text = "name: " + object.name() + "\n"
	text += "position: " + str(object.world_position) + "\n"
	text += "resources: "
	for i in object.resources:
		text += i.item_name() + " "
	$ObjectInfo/Label.text = text
	$ObjectInfo.visible = true
	$ObjectInfo.position = object.world_position
