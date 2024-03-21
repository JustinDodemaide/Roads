extends RigidBody2D

@export var timer:Timer

var force:int = 5
var moving:bool = true

signal stopped_moving

func init(from:Vector2,to:Vector2,lifetime:float = -1) -> void:
	position = from
	var direction = (to - from).normalized() * 5000 * force
	print(direction)
	Global.mission.tilemap.add_child(self)
	apply_force(direction)
	if lifetime != -1:
		timer.start(lifetime)

func set_force(_force:int) -> void:
	force = _force

var first_check:bool = true
func _physics_process(_delta):
	if not moving:
		return
	if (linear_velocity.x > -10 and linear_velocity.x < 10) and (linear_velocity.y > -10 and linear_velocity.y < 10):
		# It never reaches exactly 0
		if first_check: # Its always 0 for 1 frame at the beginning
			first_check = false
			return
		moving = false
		emit_signal("stopped_moving")
