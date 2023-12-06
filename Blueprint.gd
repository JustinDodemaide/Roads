extends LevelObject

var object_scene:PackedScene
var object_name:String
var required_components:Dictionary

func init(level_object:PackedScene) -> void:
	object_scene = level_object
	var temp = level_object.instantiate()
	object_name = temp._name()
	$Outline.sprite_frames = temp.get_node("AnimatedSprite2D").sprite_frames
	required_components = temp.components()
	$Area2D/CollisionShape2D.shape = temp.get_collision_shape()
	temp.queue_free()

func _name() -> String:
	return "Blueprint: " + object_name

func icon() -> Texture2D:
	return load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")

func is_interaction_valid(interactor) -> bool:
	for item in required_components:
		if interactor.held_item.item.item_name() == item:
			return true
	return false

func interact(interactor) -> void:
	var held = interactor.held_item
	var item = held.item_name()
	var num:int = held.quantity
	required_components[item] -= num
	if required_components[item] <= 0:
		required_components.erase(item)
	if required_components.is_empty():
		create()

func create() -> void:
	var new = object_scene.instantiate()
	new.position = $Outline.global_position
	Global.level.add_level_object(new)
	queue_free()
