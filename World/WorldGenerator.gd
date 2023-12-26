class_name WorldGenerator

# Zone rings
# Altitudes
# Other geography (impasses, swamps, etc)
# World Objects

var tilemap
const TILE_SIZE = 16
const FLOOR_LAYER:int = 0
const NUMBER_OF_ZONES = 3

func execute(tilemap_to_be_altered:TileMap):
	tilemap = tilemap_to_be_altered
	
	zone_rings()
	set_world_objects1()

func zone_rings():
	const ZONE_RADIUS = [35,25,12]
	const LAYER_NAMES = ["grass","desert","mountain"]
	# Start with outermost circle then do innermost rings
	# x = rcos(θ)
	# y = rsin(θ)
	
	# The center needs to be really far into quadrant 1 or else some tiles
	# will be negative, which breaks the astar
	const CENTER = Vector2i(250,250)
	for layer in NUMBER_OF_ZONES:
		for theta in 360:
			for radius in ZONE_RADIUS[layer]:
				# If the layer isn't grasslands, we can add some noise
				# at the edges of the regions to make it look more natural
				# if layer != 0 and 
				if radius == ZONE_RADIUS[layer] - 1:
					radius += randi_range(-2,3)
				var x = round(radius * cos(theta))
				var y = round(radius * sin(theta))
				
				var tile = Vector2i(x,y) + CENTER
				var atlas = Vector2i(layer,0)
				tilemap.set_cell(FLOOR_LAYER,tile,0,atlas)

func set_world_objects():
	# Want exactly x objects per zone
	# Want the objects to be spread evenly (but still randomly) around the map

	# Place one object on random tile
	# Draw a circle with a radius of 'desired_distance' around the object
	# Remove every tile of circle from 'available tiles' pool
	const MIN_DISTANCE:int = 5
	const NEEDED_OBJECTS:int = 15
	var objects_placed:int = 0
	const MAX_OBJECTS_PER_ZONE:int = 5
	var objects_in_zone = [0,0,0]
	var available_positions = tilemap.get_used_cells(FLOOR_LAYER)
	while objects_placed < NEEDED_OBJECTS:
		if available_positions.is_empty():
			break
		# Get a random position from the list of available positions
		var pos = available_positions[randi_range(0,available_positions.size() - 1)]
		# Get the zone that the position is in
		var zone = tilemap.get_cell_tile_data(FLOOR_LAYER,pos).get_custom_data("zone")
		if objects_in_zone[zone] >= MAX_OBJECTS_PER_ZONE:
			# If the zone already has all its required objects, 
			continue
		for theta in 360:
			for radius in MIN_DISTANCE:
				# If the layer isn't grasslands, we can add some noise
				# at the edges of the regions to make it look more natural
				# if layer != 0 and 
				var x = round(radius * cos(theta))
				var y = round(radius * sin(theta))
				var pos_to_remove = Vector2i(x,y) + pos
				available_positions.erase(pos_to_remove)
		var sprite = Sprite2D.new()
		sprite.texture = load("res://dot.png")
		sprite.position = pos * Vector2i(TILE_SIZE,TILE_SIZE)
		Global.world.add_child(sprite)
		objects_placed += 1
	if NEEDED_OBJECTS - objects_placed == 0:
		print("All objects placed")
	else:
		print(NEEDED_OBJECTS - objects_placed, " objects haven't been placed")

func set_world_objects1():
	const OBJECTS_PER_ZONE:int = 100
	var zone_tiles = get_tiles_by_zone()
	for zone in NUMBER_OF_ZONES:
		var available_positions = zone_tiles[zone]
		pass
		for i in OBJECTS_PER_ZONE:
			if available_positions.is_empty():
				print(OBJECTS_PER_ZONE - i, " unplaced objects in zone ", zone)
				break
			var pos = available_positions[randi_range(0,available_positions.size() - 1)]
			pass
			place_object(pos,zone)
			reduce_available_positions(available_positions,pos)

func get_tiles_by_zone():
	var zones = []
	for i in NUMBER_OF_ZONES:
		zones.append([])
	for tile in tilemap.get_used_cells(FLOOR_LAYER):
		var zone = tilemap.get_cell_tile_data(FLOOR_LAYER,tile).get_custom_data("zone")
		zones[zone].append(tile)
	return zones

func place_object(pos:Vector2i,zone:int):
	var sprite = Sprite2D.new()
	sprite.texture = load("res://dot.png")
	sprite.position = pos * Vector2i(TILE_SIZE,TILE_SIZE) + Vector2i(TILE_SIZE/2,TILE_SIZE/2)
	if zone == 0:
		sprite.modulate = Color.HOT_PINK
	if zone == 1:
		sprite.modulate = Color.MEDIUM_PURPLE
	if zone == 2:
		sprite.modulate = Color.ROYAL_BLUE
	Global.world.add_child(sprite)

func reduce_available_positions(available_positions,center:Vector2i):
	const MIN_DISTANCE:int = 3
	for theta in 360:
		for radius in MIN_DISTANCE:
			var x = round(radius * cos(theta))
			var y = round(radius * sin(theta))
			var pos_to_remove = Vector2i(x,y) + center
			available_positions.erase(pos_to_remove)
