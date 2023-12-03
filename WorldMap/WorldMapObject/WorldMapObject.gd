extends Node2D
class_name WorldMapObject

var map
var world_object:WorldObject
var selected:bool = false

func init(object:WorldObject)->void:
	world_object = object
	position = world_object.world_position
	$Sprite2D.texture = world_object.map_texture()
	Global.world.world_update.timeout.connect(update)
	
func update() -> void:
	position = world_object.world_position
	if not selected:
		return
	$Stats.text = stats()

func select() -> void:
	deselect()
	selected = true
	for i in world_object.options():
		$Options.text += i.option_name + "\n"
	$Stats.text = stats()
	$Stats.visible = true
	
	# REMOVE LATER
	var dest = Global.world.world_objects.back()
	world_object.launch_convoy([],dest)

func deselect() -> void:
	selected = false
	$Options.text = ""
	$Stats.visible = false

func stats() -> String:
	var string = ""
	var items:Dictionary = world_object.storage
	for item in items:
		string += item + ": "
		string += str(items[item]) + "\n"
	return string
