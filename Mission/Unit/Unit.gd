extends Node2D
class_name Unit

var character:Character
var team:Team

var utilities:Array[Variant] = [load("res://Items/Move/Move.tscn").instantiate(),]#Global.string2item("Waffle")]
var effects:Array[Effect]

var alive:bool = true
var stunned:bool = true
var max_action_points:int
var action_points:int
var max_health:int
var health:int
var max_sensor_radius:int
var sensor_radius:int

@onready var nav_agent = $NavigationAgent2D
var moving:bool = false
@onready var sensors = $Sensors

signal changed(unit:Unit)
signal died(unit:Unit)

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
	max_action_points = character.action_points
	action_points = max_action_points
	max_health = character.max_health
	health = max_health
	max_sensor_radius = character.max_sensor_radius
	sensor_radius = max_sensor_radius

func add_utility(_name:String) -> void:
	var item = Global.string2item(_name)
	utilities.append(item)

func new_turn():
	sensors.update()
	for effect in effects:
		effect.apply(self)

func add_effect(effect:Effect) -> void:
	effects.append(effect)
	effect.apply(self)

func damage(amount:int) -> void:
	health -= amount
	if health <= 0:
		health = 0
		alive = false
		emit_signal("died",self)
	emit_signal("changed",self)

func _process(delta):
	$Label.text = "ap: " + str(action_points)

func make_decision() -> void:
	# Go through all the utilities, execute the one with the highest score
	while action_points > 0:
		var highest_score_utility:CharacterItem
		var highest_score_utility_info:Dictionary
		var highest_score:int = -1000000
		for utility:CharacterItem in utilities:
			var info = utility.ai_score(self)
			var score = info["score"]
			if score > highest_score:
				highest_score = score
				highest_score_utility = utility
				highest_score_utility_info = info
		highest_score_utility.execute(self,highest_score_utility_info)
		await highest_score_utility.complete
	return
	## 1. Get set of potential positions to move to
	#var positions:PackedVector2Array
	#
	#var origin = position
	#var movement_radius:int = 10
	#var step = Global.mission.tilemap.tile_set.tile_size.x
	#var max = movement_radius * step
	#
	#var x:int = -max
	#while x < max:
		#var y:int = -max
		#while y < max:
			#var pos:Vector2 = Vector2(x,y) + origin
			#if origin.distance_to(pos) > max:
				#y += step
				#continue
			#nav_agent.set_target_position(pos)
			#if not nav_agent.is_target_reachable():
				#y += step
				#continue
			##var sprite = Sprite2D.new()
			##sprite.position = pos
			##sprite.texture = load("res://dot.png")
			##Global.mission.tilemap.add_child(sprite)
			#positions.append(pos)
			#
			#y += step
		#x += step
#
	#var dummy = load("res://Mission/AI/Dummy/AIDummy.tscn").instantiate()
	#Global.mission.add_child(dummy)
	#dummy.init(self)
	#
	## 2. Get position with highest score
	## Can move this inside the step 1 loop to optimize
	#var highest_score:int = -1000000
	#var highest_score_position:Vector2 = position
	#for pos in positions:
		#var score = dummy.get_score_at_position(pos)
		#if score > highest_score:
			#highest_score = score
			#highest_score_position = pos
	#dummy.queue_free()
	#Log.prn("highest score position: ", highest_score_position)
	#var sprite = Sprite2D.new()
	#sprite.position = highest_score_position
	#sprite.texture = load("res://dot.png")
	#sprite.modulate = Color.BLUE
	#sprite.z_index = 2
	#Global.mission.tilemap.add_child(sprite)
	#
	#if not (highest_score_position == position):
		## Move
		#var move = utilities.front() # Move is always the first utility
		#move.execute(self,{"position":highest_score_position})
		#await move.complete
		## func execute(_actor:Unit,_selection_info:Dictionary) -> void:
	#
	## 3. Get target with highest score

