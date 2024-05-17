extends CharacterItem

func execute(_actor:Unit,_selection_info:Dictionary) -> void:
	var agent:NavigationAgent2D = _actor.nav_agent
	agent.set_target_position(_selection_info["position"])
	if agent.is_target_reachable():
		# !! This is a load-bearing if statement. Removing this causes
		# the navigation agent to stop working.
		pass
	var index:int = 0
	for point in agent.get_current_navigation_path():
		var tween:Tween = _actor.create_tween()
		tween.tween_property(_actor,"position",point,0.1)
		await tween.finished
		# _selection_info["dots"][index].queue_free()
		index += 1
		#(object: Object, property: NodePath, final_val: Variant, duration: float)
	
	emit_signal("complete")

func ai_score(unit:Unit) -> Dictionary:
	var position = unit.position
	# 1. Get set of potential positions to move to
	var positions:PackedVector2Array
	
	var origin = position
	var movement_radius:int = 10
	var step = Global.mission.tilemap.tile_set.tile_size.x
	var max = movement_radius * step
	
	var x:int = -max
	while x < max:
		var y:int = -max
		while y < max:
			var pos:Vector2 = Vector2(x,y) + origin
			if origin.distance_to(pos) > max:
				y += step
				continue
			unit.nav_agent.set_target_position(pos)
			if not unit.nav_agent.is_target_reachable():
				y += step
				continue
			#var sprite = Sprite2D.new()
			#sprite.position = pos
			#sprite.texture = load("res://dot.png")
			#Global.mission.tilemap.add_child(sprite)
			positions.append(pos)
			
			y += step
		x += step

	var dummy = load("res://Mission/AI/Dummy/AIDummy.tscn").instantiate()
	Global.mission.add_child(dummy)
	dummy.init(unit)
	
	# 2. Get position with highest score
	# Can move this inside the step 1 loop to optimize
	var highest_score:int = -1000000
	var highest_score_position:Vector2 = position
	var lowest_score:int = 100000
	for pos in positions:
		var score = dummy.get_score_at_position(pos)
		if score > highest_score:
			highest_score = score
			highest_score_position = pos
		if score < lowest_score:
			lowest_score = score
	dummy.queue_free()
	
	highest_score += 10
	
	Log.prn("Move score: ", highest_score)
	# Log.prn("highest score position: ", highest_score_position)
	#var sprite = Sprite2D.new()
	#sprite.position = highest_score_position
	#sprite.texture = load("res://dot.png")
	#sprite.modulate = Color.BLUE
	#sprite.z_index = 2
	#Global.mission.tilemap.add_child(sprite)
	
	if highest_score_position == position:
		Log.prn("highest score position is position")
		return {"score":-100000,"position":position}
	return {"score":highest_score,"position":highest_score_position}
