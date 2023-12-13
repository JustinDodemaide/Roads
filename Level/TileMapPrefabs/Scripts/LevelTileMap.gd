extends TileMap
class_name LevelTileMap

@export var prefab_id:int = 0

func save() -> Dictionary:
	var data = {"filepath": "res://Level/TileMapPrefabs/LTM_" + str(prefab_id) + ".tscn",
				"parent": "Level",
				"prefab": prefab_id
				}
	return data

func _load(_data:Dictionary) -> void:
	pass
	#var prefab = data["prefab"]
	#tile_set = load("res://Level/TilesetPrefabs/TSPF_" + str(prefab) + ".tres")
