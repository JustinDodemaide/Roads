extends Node2D

var unit:Unit
var visible_enemies:Array[Unit]
var visible_allies:Array[Unit]

@onready var radius = $SensorCircle
@onready var sightcast:RayCast2D = $SightCast
@onready var cover_sensor = $CoverSensor

func _ready():
	unit = get_parent()
	update_radius()

func update_radius() -> void:
	var r = unit.sensor_radius
	radius.scale = Vector2(r,r)

func update():
	visible_enemies.clear()
	visible_allies.clear()
	for area in radius.get_overlapping_areas():
		var parent = area.get_parent()
		if parent == null:
			continue
		if parent is Unit:
			if parent == unit:
				continue
			process_unit(parent)

func can_see(pos:Vector2) -> bool:
	sightcast.target_position = pos - sightcast.global_position
	return sightcast.is_colliding()

func process_unit(u:Unit) -> void:
	#if not can_see(u.position):
	#	return
	if u.team == unit.team:
		visible_allies.append(u)
	else:
		visible_enemies.append(u)
