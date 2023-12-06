extends Node
class_name LevelObject

func _name() -> String:
	return "Level Object"

func icon() -> Texture2D:
	return load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")

func is_interaction_valid(interactor) -> bool:
	print(_name(), " clicked on")
	return false

func interact(interactor) -> void:
	print(_name(), " interacted with")
	pass

func components() -> Dictionary:
	#{item: amount}
	return {}

func get_collision_shape() -> Shape2D:
	return $Area2D/CollisionShape2D.shape

func producers() -> Array[Producer]:
	return []
