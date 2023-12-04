extends StateMachine

func _on_world_ready():
	state = load("res://Level/Level.tscn").instantiate()
	state.state_machine = self
	add_child(state)
	state.enter({"WorldObject": Global.world.world_objects.front()})
	emit_signal("transitioned", state.name)

func transition_to(target_scene_path:String, msg:Dictionary = {}) -> void:
	state.exit()
	state.queue_free()
	state = load(target_scene_path).instantiate()
	state.state_machine = self
	add_child(state)
	state.enter(msg)
	emit_signal("transitioned", state.name)
