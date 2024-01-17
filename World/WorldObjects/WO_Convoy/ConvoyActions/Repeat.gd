extends ConvoyAction

func execute(convoy:WorldObject) -> void:
	convoy.action_index = 0
	emit_signal("complete")
