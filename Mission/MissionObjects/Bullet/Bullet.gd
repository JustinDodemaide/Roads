extends Node2D

var velocity = Vector2(20,0)

func init(from:Vector2,to:Vector2) -> void:
	position = from
	var rot = get_angle_to(to)
	rotation = rot
	velocity = velocity.rotated(rot) * Vector2(100,100)
	Global.mission.tilemap.add_child(self)

func _physics_process(delta):
	position += velocity * delta

func _on_timer_timeout():
	queue_free()

func _on_area_2d_area_entered(area):
	pass

func damage(_amount):
	print("bullet hit bullet")
	queue_free()
