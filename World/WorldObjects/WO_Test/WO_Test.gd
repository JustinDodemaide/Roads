extends WorldObject

var bounce:int = 10
var i:int = 0
var right:bool = true
func additional_updates() -> void:
	if right:
		world_position += Vector2(10, 0)
		i += 1
		if i >= bounce:
			right = false
	if not right:
		world_position -= Vector2(10, 0)
		i -= 1
		if i == 0:
			right = true
