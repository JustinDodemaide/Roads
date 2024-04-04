extends Node

var world
var scene_handler
var current_location:WorldObject
var player_faction:Faction
var mission_launched:bool = false
var mission

func save_game() -> void:
	world.save()

func research_complete(_category:String,_path:String):
	pass

func string2item(string:String) -> Variant:
	var path:String = "res://Items/" + string + "/" + string + ".tscn" 
	return load(path).instantiate()

enum CARDINAL{NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST}

func deg_to_vector2(degree:float)->Vector2i:
	var d:int = round(degree/45)
	if d == 0:
		# West
		return Vector2i(-1,0)
	if d == 1:
		# Northwest
		return Vector2i(-1,-1)
	if d == 2:
		# North
		return Vector2i(0,-1)
	if d == 3:
		# Northeast
		return Vector2i(1,-1)
	if d == 4:
		# East
		return Vector2i(1,0)
	if d == -4:
		# East
		return Vector2i(1,0)
	if d == -3:
		# Southeast
		return Vector2i(1,1)
	if d == -2:
		# South
		return Vector2i(0,1)
	if d == -1:
		# Southwest
		return Vector2i(-1,1)
	# West
	return Vector2i(-1,0)

func deg_to_card(degree:float)->CARDINAL:
	var d:int = round(degree/45)
	if d == 0:
		# West
		return CARDINAL.WEST
	if d == 1:
		# Northwest
		return CARDINAL.NORTHWEST
	if d == 2:
		# North
		return CARDINAL.NORTH
	if d == 3:
		# Northeast
		return CARDINAL.NORTHEAST
	if d == 4:
		# East
		return CARDINAL.EAST
	if d == -4:
		# East
		return CARDINAL.EAST
	if d == -3:
		# Southeast
		return CARDINAL.SOUTHEAST
	if d == -2:
		# South
		return CARDINAL.SOUTH
	if d == -1:
		# Southwest
		return CARDINAL.SOUTHWEST
	# West
	return CARDINAL.WEST

func deg_to_card_string(degree:float)->String:
	var d:int = round(degree/45)
	if d == 0:
		# West
		return "West"
	if d == 1:
		# Northwest
		return "Northwest"
	if d == 2:
		# North
		return "North"
	if d == 3:
		# Northeast
		return "Northeast"
	if d == 4:
		# East
		return "East"
	if d == -4:
		# East
		return "East"
	if d == -3:
		# Southeast
		return "Southeast"
	if d == -2:
		# South
		return "South"
	if d == -1:
		# Southwest
		return "Southwest"
	# West
	return "West"

func card_from_pos(origin:Vector2,to:Vector2) -> CARDINAL:
	var deg = rad_to_deg(origin.angle_to_point(to))
	return deg_to_card(deg)
