extends StateMachine

func _on_world_ready():
	Global.scene_handler = self
	state = load("res://Level/Level.tscn").instantiate()
	add_child(state)
	state.enter({"WorldObject": Global.world.world_objects.front()})
	emit_signal("transitioned", state.name)

func transition_to(target_scene_path:String, msg:Dictionary = {}) -> void:
	state.exit()
	state.queue_free()
	state = load(target_scene_path).instantiate()
	add_child(state)
	state.enter(msg)
	emit_signal("transitioned", state.name)
