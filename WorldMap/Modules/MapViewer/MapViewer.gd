extends Node

var world_map
var selected_object:WorldObject
@onready var object_select = $MapObjectSelect
@onready var object_view = $ObjectView

func _ready():
	world_map.map_object_clicked.connect(map_object_clicked)

#var world_position:Vector2
#var resources:Array
#var producers:Array[Producer]
#var storage:Dictionary
#var vehicles:Array[Vehicle]
var ignoring_click:bool = false
func map_object_clicked(map_object):
	if ignoring_click:
		return
	selected_object = map_object.world_object
	object_select.init(map_object.world_object)

func _on_map_object_select_view_object():
	ignoring_click = true
	object_select.visible = false
	object_view.visible = true
	object_view.init(selected_object)

func _on_object_view_close():
	object_view.visible = false
	object_select.visible = true
	ignoring_click = false
