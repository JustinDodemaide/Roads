extends Node2D

@onready var raycast = $RayCast2D
@onready var cover_sensor = $CoverSensor

var ideal_distance:int = 7
var enemies:Array[Unit]

var n

func init(unit:Unit) -> void:
	# circle.scale = Vector2(unit.sensor_radius,unit.sensor_radius)
	n = unit.character.name
	if unit.team == Global.mission.attacking_team:
		enemies = Global.mission.defending_team.units
	else:
		enemies = Global.mission.attacking_team.units

func get_score_at_position(pos:Vector2) -> int:
	position = pos
	var score:int = 0
	for enemy in enemies:
		score += distance_score(enemy)
		score += await cover_score() # Important to have this before flanking_score
		score += flanking_score(enemy)
	return score

func distance_score(enemy:Unit) -> int:
	var distance = position.distance_to(enemy.position) / Global.mission.tilemap.tile_set.tile_size.x
	return abs(distance - ideal_distance) * -1
	# Doing it like this means the best possible distance score is 0,
	# so they can only really lose total score from this,
	# which is unintuitive but works for now

func cover_score() -> int:
	var score:int = 0
	cover_sensor.update()
	var tween = create_tween()
	tween.tween_interval(0.001)
	await tween.finished
	if cover_sensor.north:
		score += 1
	if cover_sensor.south:
		score += 1
	if cover_sensor.east:
		score += 1
	if cover_sensor.west:
		score += 1
	return score

func flanking_score(enemy:Unit) -> int:
	var score:int = 0
	raycast.target_position = enemy.position - raycast.global_position
	if raycast.is_colliding():
		# The enemy can't see the dummy, and the dummy can't see the enemy
		return score
	if is_flanking(enemy):
		score += 1
	if is_being_flanked_by(enemy):
		score -= 2 # This is very bad so it has a greater weight
	return score

func is_flanking(enemy:Unit) -> bool:
	var cardinal = Global.card_from_pos(position,enemy.position)
	# Log.prn(n + " is " + Global.CARDINAL.keys()[cardinal] + " of " + enemy.character.name)
	
	if enemy.sensors.cover_sensor.has_cover_in_direction(cardinal):
		# Log.prn(n + " is not flanking " + enemy.character.name)
		return false
	# Genuinely going to be impossible to debug if I didnt get this right the
	# first time
	# Log.prn(n + " is flanking " + enemy.character.name)
	return true

func is_being_flanked_by(enemy:Unit) -> bool:
	var cardinal = Global.card_from_pos(enemy.position,position)
	var c = Global.CARDINAL.keys()[cardinal]
	Log.prn(position, " is ", c, " of ", enemy.position)
	
	if cover_sensor.has_cover_in_direction(cardinal):
		Log.prn(n + " is not being flanked by " + enemy.character.name)
		return false
	# Log.prn(n + " is being flanked by " + enemy.character.name)
	var sprite = Sprite2D.new()
	sprite.position = position
	sprite.texture = load("res://dot.png")
	sprite.modulate = Color.BLACK
	Global.mission.tilemap.add_child(sprite)
	return true
