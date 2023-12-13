extends Node2D
class_name LevelObject

var id:int

func _ready():
	id = get_instance_id()

func _name() -> String:
	return "Level Object"

func icon() -> Texture2D:
	return load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")

func is_interaction_valid(_interactor) -> bool:
	print(_name(), " clicked on")
	return false

func interact(_interactor) -> void:
	print(_name(), " interacted with")
	pass

func components() -> Dictionary:
	#{item: amount}
	return {}

func get_collision_shape() -> Shape2D:
	return $Area2D/CollisionShape2D.shape

func producers() -> Array[Producer]:
	return []

func save() -> Dictionary:
	var save_dict:Dictionary = {
		"filepath": get_scene_file_path(),
		"parent": "LevelObjects",
		"x": position.x,
		"y": position.y,
		"id": id,
	}
	save_additional_fields(save_dict)
	return save_dict

func save_additional_fields(save_dict:Dictionary) -> void: # Modifies the dictionary reference
	pass

func _load(data:Dictionary) -> void:
	position = Vector2(data["x"], data["y"])
	id = data["id"]
	additional_load_fields(data)

func additional_load_fields(_data:Dictionary) -> void:
	pass

func _to_string():
	return "Level Object " + _name()
