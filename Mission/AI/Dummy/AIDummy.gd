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
		score += cover_score() # Important to have this before flanking_score
		score += flanking_score(enemy)
	var label = Label.new()
	label.text = str(score)
	label.position = pos
	label.scale *= 0.75
	Global.mission.tilemap.add_child(label)
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
	if enemy.sensors.cover_sensor.has_cover_in_direction(cardinal):
		return false
	# Genuinely going to be impossible to debug if I didnt get this right the
	# first time
	# Got the programming right, got the idea wrong. Decided that if a unit is
	# looking at another unit from NE, SE, etc, the target is being flanked if
	# either direction is uncovered (as opposed to only one direction needing
	# to be covered
	return true

func is_being_flanked_by(enemy:Unit) -> bool:
	var cardinal = Global.card_from_pos(enemy.position,position)
	if cover_sensor.has_cover_in_direction(cardinal):
		Log.prn(n + " is not being flanked by " + enemy.character.name)
		return false
	return true
