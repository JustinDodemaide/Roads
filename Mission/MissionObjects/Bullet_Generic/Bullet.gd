extends Node2D

var utility:Item
var from:Unit
var to_unit:Unit = null

var velocity:Vector2 = Vector2(100,0)

# If the bullet is aimed at a target, it will ignore overlapping areas
# except that of the target. If its aimed at a position, it will
# interact with the first area it hits
func init(_utility:Item,_from:Unit,_to:Variant) -> void:
	utility = _utility
	from = _from
	position = from.position
	
	if _to is Unit:
		to_unit = _to
		set_rotation_to(to_unit.position)
	elif _to is Vector2:
		set_rotation_to(_to)

	velocity = velocity.rotated(rotation) # * Vector2(100,100)
	Global.mission.tilemap.add_child(self)
	$Timer.start(7) #Time to live

func set_rotation_to(to:Vector2):
	rotation = get_angle_to(to)

func _physics_process(delta):
	position += velocity * delta

func _on_timer_timeout():
	queue_free()

func _on_area_2d_area_entered(area):
	print("bullet hit ", area.get_parent().name)
	if to_unit == null:
		#Hit
		return
	if area.get_parent() == to_unit:
		#Hit
		queue_free()

func set_speed(speed:int) -> void:
	velocity *= speed
