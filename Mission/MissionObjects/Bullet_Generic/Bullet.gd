extends Node2D

var start_position:Vector2

var velocity:Vector2 = Vector2(100,0)
var max_distance:float = 1000

# Pass 'self' as an argument bc one Item could be handling several bullets
# Bullets don't act, they're acted upon
signal hit_area(bullet,area)
signal max_distance_reached(bullet)

func init(_start_position:Vector2,_end_position) -> void:
	start_position = _start_position
	position = start_position
	rotation = get_angle_to(_end_position)
	velocity = velocity.rotated(rotation)
	Global.mission.tilemap.add_child(self)

func _physics_process(delta):
	position += velocity * delta
	var traveled_distance = position.distance_to(start_position)
	if traveled_distance >= max_distance:
		emit_signal("max_distance_reached")
		queue_free()

func _on_area_2d_area_entered(area):
	print("bullet hit ", area.get_parent().name)
	emit_signal("hit_area",self,area)

# Builder functions. Need to be called before init
func set_speed(speed:int) -> void:
	velocity *= speed

func set_max_distance(distance:float) -> void:
	max_distance = distance
