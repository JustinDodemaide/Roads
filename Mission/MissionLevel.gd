extends TileMap

enum {GROUND,START_POSITIONS,WALLS}

# Local = Global
# Map = Tile

func get_start_positions(team:int) -> Array[Vector2]:
	var positions:Array[Vector2] = []
	var cells = get_used_cells(START_POSITIONS)
	for tile in get_used_cells(START_POSITIONS):
		var team_start = int(get_cell_tile_data(START_POSITIONS,tile).get_custom_data("StartPositionTeam"))
		if team_start == team:
			var pos = map_to_local(tile)
			positions.append(pos)
	return positions

	#var clicked_cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	#var data = tile_map.get_cell_tile_data(0, clicked_cell)
	#if data:
		#return data.get_custom_data("power")
