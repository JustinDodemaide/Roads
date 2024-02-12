extends Node

var world_map
var selected_object:WorldObject
@onready var object_select = $MapObjectSelect

func _ready():
	world_map.map_object_clicked.connect(map_object_clicked)

#var world_position:Vector2
#var resources:Array
#var producers:Array[Producer]
#var storage:Dictionary
#var vehicles:Array[Vehicle]
func map_object_clicked(map_object):
	selected_object = map_object.world_object
	object_select.init(map_object.world_object)
