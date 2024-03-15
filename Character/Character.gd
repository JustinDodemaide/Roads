extends RefCounted
class_name Character

var name:String = "Character"
var faction:Faction
var icon:Texture2D = load("res://Character/jerma.jpg")

var max_health:int = 100
var max_sensor_radius:int = 5
var equip_slots:int = 1
var equipment:Array[String] = []
var utility_slots:int = 2
var utilities:Array[String] = ["Waffle","Pan"]

func _init():
	name = random_name()

func random_name() -> String:
	var first = ["Garbly","Glupman","Watto","Shmarvin","Qwinkly","John","Brad","Cheepcheep","Balthazar","Steeljaw","Flotsum","Joe","Wallop","Crikey","Snacho",", First of His Name","Squibbledoo"]
	# var last = ["Binkly",]
	return first.pick_random() + " " + first.pick_random()

func _load(data:Dictionary) -> void:
	name = data["name"]

func save() -> Dictionary:
	return {"name":name,
	}

func set_utilities(items:Array[String]) -> void:
	utilities = items
