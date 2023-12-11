extends TileMap

# Kinda unnecessary, but it makes saving/loading TileMaps a lot less complicated
@export var prefab_id:int

func save() -> Dictionary:
	var data = {"filepath": "res://Level/TileMapScene/TileMap.tscn",
				"parent": "Level",
				"prefab": prefab_id
				}
	return data

func _load(data:Dictionary) -> void:
	var prefab = data["prefab"]
	tile_set = load("res://Level/TilesetPrefabs/TSPF_" + str(prefab) + ".tres")
