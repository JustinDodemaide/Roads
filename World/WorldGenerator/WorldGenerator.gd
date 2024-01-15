extends Node
class_name WorldGenerator

# Zone rings
# Altitudes
# Other geography (impasses, swamps, etc)
# World Objects

# Not very optimized, but only runs once per playthrough

var tilemap
const TILE_SIZE = 16
const FLOOR_LAYER:int = 0
const NUMBER_OF_ZONES = 3

func execute(tilemap_to_be_altered:TileMap):
	tilemap = tilemap_to_be_altered
	
	zone_rings()
	await altitudes()
	set_world_objects()
	distribute_resources()
	set_faction_starting_objects()
	initialize_player_start()

func zone_rings():
	const ZONE_RADIUS_MULTIPLIER:int = 14
	const ZONE_RADIUS_RATIOS = [3,2,1]
	# Start with outermost circle then do innermost rings
	# x = rcos(θ)
	# y = rsin(θ)
	
	# The center needs to be really far into quadrant 1 or else some tiles
	# will be negative, which breaks the astar
	const CENTER = Vector2i(250,250)
	for layer in NUMBER_OF_ZONES:
		for theta in 360:
			for radius in ZONE_RADIUS_RATIOS[layer] * ZONE_RADIUS_MULTIPLIER:
				# This adds some randomness to the edges of the regions that
				# make them look more natural
				if radius == (ZONE_RADIUS_RATIOS[layer] * ZONE_RADIUS_MULTIPLIER) - 1:
					radius += randi_range(-3,3)
				var x = round(radius * cos(theta))
				var y = round(radius * sin(theta))
				
				var tile = Vector2i(x,y) + CENTER
				var atlas = Vector2i(1,layer)
				tilemap.set_cell(FLOOR_LAYER,tile,0,atlas)
				# All cells at this point are placeholders - they'll be
				# changed in altitudes()

#func noise_tester():
	## This function allowed me to see the results of each type/frequency of noise
	## without having to rerun the program each time. Leaving it here in case
	## I need it again.
	#var button = Global.world.get_node("Button")
	#
	#var noise = FastNoiseLite.new()
	#var dots = []
	#for i in 6:
		#noise.noise_type = i
		#
		#var step = 0.001
		#for j in 3:
			#button.text = str(i) + "\n" + str(step)
			#for dot in dots:
				#dot.queue_free()
			#dots.clear()
			#
			#noise.set_frequency(step)
			#
			#for tile in tilemap.get_used_cells(FLOOR_LAYER):
				#var sprite = Sprite2D.new()
				#sprite.texture = load("res://dot.png")
				#sprite.position = tile * Vector2i(TILE_SIZE,TILE_SIZE) + Vector2i(TILE_SIZE/2,TILE_SIZE/2)
				#var val = abs(noise.get_noise_2dv(tile))
				#sprite.modulate = Color.BLACK
				#sprite.modulate.a = val
				#dots.append(sprite)
				#Global.world.add_child(sprite)
				#
			#await button.pressed
			#
			#step *= 10
			#
		#await button.pressed

func altitudes():
	# Potential noises:
	# Simplex 0.01
	# Type Value Cubic (4) 0.1 (water threshold 0.05)
	# Type Value (5) 0.1
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.set_frequency(0.05)
	randomize()
	noise.seed = randi()
	
	var cells = tilemap.get_used_cells(FLOOR_LAYER)
	
	# Originally planned on getting altitude-tile threshold values automatically
	# so I could change the noise type/frequency freely, but it wasn't giving the
	# results I wanted (too much water, not enough mountains).
	
	#var highest_value:float = 0
	#var lowest_value:float = 1000000
	#for cell in cells:
		#var val = abs(noise.get_noise_2dv(cell))
		#if val > highest_value:
			#highest_value = val
		#if val < lowest_value:
			#lowest_value = val
	
	#const NUM_STEPS:int = 5
	#var step = (highest_value - lowest_value) / NUM_STEPS
	#for cell in cells:
		#var temp_step = lowest_value + step
		#var val = abs(noise.get_noise_2dv(cell))
		#var atlas_x_value:int = 0
		#for i in NUM_STEPS:
			#if val <= temp_step:
				#break
			#atlas_x_value += 1
			#temp_step += temp_step
		#var zone = tilemap.get_cell_tile_data(FLOOR_LAYER,cell).get_custom_data("zone")
		#var atlas = Vector2i(atlas_x_value,zone)
		#tilemap.set_cell(FLOOR_LAYER,cell,0,atlas)
		
	# Hard coding the values gave better results. I'll revisit the automatic
	# version if I need the flexibility.
	# With Simplex 0.05, the highest value was ~0.8, the lowest was 0.
	for cell in cells:
		var val = abs(noise.get_noise_2dv(cell))
		var atlas_x_value:int
		if val < 0.075:
			atlas_x_value = 0
		if val >= 0.075 and val < 0.235:
			atlas_x_value = 1
		if val >= 0.235 and val < 0.48:
			atlas_x_value = 2
		if val >= 0.48 and val < 0.64:
			atlas_x_value = 3
		if val >= 0.64:
			atlas_x_value = 4
		var zone = tilemap.get_cell_tile_data(FLOOR_LAYER,cell).get_custom_data("zone")
		var atlas = Vector2i(atlas_x_value,zone)
		tilemap.set_cell(FLOOR_LAYER,cell,0,atlas)

const OBJECTS_PER_ZONE_MULTIPLIER:int = 75
const OBJECTS_PER_ZONE_RATIOS:Array[float] = [1,0.75,0.33]
var zone_objects = []
func set_world_objects():
	for i in NUMBER_OF_ZONES:
		zone_objects.append([])
	var zone_tiles = get_tiles_by_zone()
	for zone in NUMBER_OF_ZONES:
		var available_positions = zone_tiles[zone]
		for i in OBJECTS_PER_ZONE_RATIOS[zone] * OBJECTS_PER_ZONE_MULTIPLIER:
			if available_positions.is_empty():
				print((OBJECTS_PER_ZONE_RATIOS[zone] * OBJECTS_PER_ZONE_MULTIPLIER) - i, " unplaced objects in zone ", zone)
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
		var cell_data = tilemap.get_cell_tile_data(FLOOR_LAYER,tile)
		if cell_data.get_custom_data("impass") == true:
			continue
		var zone = cell_data.get_custom_data("zone")
		zones[zone].append(tile)
	return zones

func place_object(pos:Vector2i,zone:int):
	pos = pos * Vector2i(TILE_SIZE,TILE_SIZE)
	var world_object = WorldObject.new()
	world_object.init(pos)
	Global.world.add_world_object(world_object)
	zone_objects[zone].append(world_object)

func reduce_available_positions(available_positions,center:Vector2i):
	const MIN_DISTANCE:int = 3
	for theta in 360:
		for radius in MIN_DISTANCE:
			var x = round(radius * cos(theta))
			var y = round(radius * sin(theta))
			var pos_to_remove = Vector2i(x,y) + center
			available_positions.erase(pos_to_remove)

var ZONE_RESOURCES = [
	# Zone 0
	[
	WG_RP.new("res://Items/Tier0Harvest/Item_Tier0Harvest.gd",90),
	],
	
	# Zone 1
	[
	WG_RP.new("res://Items/Tier1Harvest/Item_Tier1Harvest.gd",90),
	],
	
	# Zone 2
	[
	WG_RP.new("res://Items/Tier2Harvest/Item_Tier2Harvest.gd",90),
	],
]

func distribute_resources():
	for zone in NUMBER_OF_ZONES:
		for object in zone_objects[zone]:
			for resource in ZONE_RESOURCES[zone]:
				var dice_roll = randi_range(0,100)
				if dice_roll < resource.percent_chance:
					object.resources.append(load(resource.item_path).new())

func set_faction_starting_objects() -> void:
	var factions = ["1","2","3","PLAYER"]
	var ideal_positions = [Vector2(4000,3400),Vector2(3400,4000),Vector2(4000,4600),Vector2(4600,4000)]
	for i in factions.size():
		var ideal_position = ideal_positions.pick_random()
		ideal_positions.erase(ideal_position)
		# Get object closest to ideal location
		var closest_distance:int = 100000
		var closest_object = null
		for object in Global.world.world_objects:
			var distance = ideal_position.distance_to(object.world_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_object = object
		closest_object.faction = factions[i]
		if factions[i] == "PLAYER":
			Global.player_location = closest_object

func initialize_player_start() -> void:
	var loc = Global.player_location
	var starting_items = {load("res://Items/Tier0Harvest/Item_Tier0Harvest.gd").new().item_name(): 100}
	loc.storage = starting_items
