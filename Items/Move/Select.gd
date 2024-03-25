extends SelectionType
# FreeSelect: The selection is position of the next mouse click

var actor:Unit
var cursor
var dot_scene:PackedScene = load("res://Items/Move/PathDot/PathDot.tscn")
var dots = []

func start(_unit:Unit,_utility:Variant) -> void:
	actor = _unit
	cursor = load("res://Items/Move/Cursor/MoveCursor.tscn").instantiate()
	Global.mission.add_child(cursor)
	Global.mission.position_left_clicked.connect(position_selected)

func position_selected(position:Vector2):
	var agent:NavigationAgent2D = actor.nav_agent
	agent.set_target_position(position)
	if agent.is_target_reachable():
		Global.mission.position_left_clicked.disconnect(position_selected)
		for point in agent.get_current_navigation_path():
			var tween = actor.create_tween()
			tween.tween_interval(0.005)
			await tween.finished
			new_dot(point)
		var info:Dictionary = {"position":position,"dots":dots}
		emit_signal("selection_made",info)

func new_dot(pos) -> void:
	var path_dot = dot_scene.instantiate()
	path_dot.position = pos
	Global.mission.tilemap.add_child(path_dot)

func clear():
	cursor.queue_free()
