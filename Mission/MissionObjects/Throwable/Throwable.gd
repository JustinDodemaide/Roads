extends RigidBody2D

var force:int = 5

func init(from:Vector2,to:Vector2) -> void:
	position = from
	var direction = (to - from).normalized() * 10000 * force
	print(direction)
	Global.mission.tilemap.add_child(self)
	apply_force(direction)

func set_force(_force:int) -> void:
	force = _force
