extends Node2D
class_name Unit

var character:Character
var team:Team

var utilities:Array[Item] = [load("res://Items/Move/Move.tres")]
var effects:Array[Effect]

var available:bool = true
var max_health:int
var health:int
var max_sensor_radius:int
var sensor_radius:int

@onready var nav_agent = $NavigationAgent2D
var moving:bool = false
@onready var sensors = $Sensors

signal changed(unit:Unit)

func _ready():
	call_deferred("actor_setup")
	actor_setup()
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	$NavigationAgent2D.set_target_position(position)

func init(_character:Character) -> void:
	character = _character
	for utility_name in character.utilities:
		add_utility(utility_name)
	max_health = character.max_health
	health = max_health
	max_sensor_radius = character.max_sensor_radius
	sensor_radius = max_sensor_radius

func add_utility(_name:String) -> void:
	var item = Global.string2item(_name)
	utilities.append(item)

func new_turn():
	for effect in effects:
		effect.apply(self)

func add_effect(effect:Effect) -> void:
	effects.append(effect)

func damage(amount:int) -> void:
	health -= amount
	if health <= 0:
		health = 0
		available = false
