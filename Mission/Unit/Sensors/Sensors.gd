extends Node2D

var unit:Unit
var visible_enemies:Array[Unit]
var visible_allies:Array[Unit]

@onready var radius = $Area2D
@onready var sightcast:RayCast2D = $SightCast

func _ready():
	unit = get_parent()
	update_radius()

func update_radius() -> void:
	var r = unit.sensor_radius
	radius.scale = Vector2(r,r) * 7

func update():
	for area in radius.get_overlapping_areas():
		var parent = area.get_parent()
		if parent == null:
			continue
		if parent is Unit:
			process_unit(parent)
	pass

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
