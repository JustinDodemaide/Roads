extends UtilityExecutionBehavior

func execute(utility:Item,actor:Unit,_selection_info:Dictionary) -> void:
	actor.nav_agent.set_target_position(_selection_info["position"])
	if actor.nav_agent.is_target_reachable():
		# !! This is a load-bearing if statement. Removing this causes
		# the navigation agent to stop working
		pass
	emit_signal("complete")
