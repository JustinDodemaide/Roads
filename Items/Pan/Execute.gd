extends UtilityExecutionBehavior

func execute(utility:Item,actor:Unit,_selection_info:Dictionary) -> void:
	var bullet = load("res://Mission/MissionObjects/Bullet_Generic/Bullet.tscn").instantiate()
	if randi_range(0,100) > _selection_info["percent"]:
		# Miss
		var pos = get_miss_position(_selection_info["target"].position)
		bullet.init(utility,actor,pos)
	else:
		bullet.init(utility,actor,_selection_info["target"])
	emit_signal("complete")

func get_miss_position(target:Vector2) -> Vector2:
	var x = target.x + randi_range(-100,100)
	var y = target.y + randi_range(-100,100)
	return Vector2(x,y)
