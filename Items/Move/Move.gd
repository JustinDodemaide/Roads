extends CharacterItem

func execute(_actor:Unit,_selection_info:Dictionary) -> void:
	var agent:NavigationAgent2D = _actor.nav_agent
	agent.set_target_position(_selection_info["position"])
	if agent.is_target_reachable():
		# !! This is a load-bearing if statement. Removing this causes
		# the navigation agent to stop working
		pass
	var index:int = 0
	for point in agent.get_current_navigation_path():
		var tween:Tween = _actor.create_tween()
		tween.tween_property(_actor,"position",point,0.1)
		await tween.finished
		_selection_info["dots"][index].queue_free()
		index += 1
		#(object: Object, property: NodePath, final_val: Variant, duration: float)
	
	emit_signal("complete")
