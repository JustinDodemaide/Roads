extends LevelObject

var object_scene:PackedScene
var object_name:String

func init(level_object:PackedScene) -> void:
	object_scene = level_object
	var temp = level_object.instantiate()
	object_name = temp._name()
	$Outline.sprite_frames = temp.get_node("AnimatedSprite2D").sprite_frames
	temp.queue_free()

func _name() -> String:
	return "Blueprint: " + object_name

func icon() -> Texture2D:
	return load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")

func is_interaction_valid(interactor) -> bool:
	return false

func interact(interactor) -> void:
	pass
