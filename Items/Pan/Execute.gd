extends UtilityExecutionBehavior

func execute(utility:Item,actor:Unit,_selection_info:Dictionary) -> void:
	var spawned_bullet = preload("res://Mission/MissionObjects/Bullet/Bullet.tscn").instantiate()
	emit_signal("complete")
