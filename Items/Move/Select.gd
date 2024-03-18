extends SelectionType
# FreeSelect: The selection is position of the next mouse click

var actor:Unit
var dots = []

func start(_unit:Unit,_utility:Variant) -> void:
	actor = _unit
	Global.mission.position_left_clicked.connect(position_selected)

func position_selected(position:Vector2):
	var agent:NavigationAgent2D = actor.nav_agent
	agent.set_target_position(position)
	if agent.is_target_reachable():
		Global.mission.position_left_clicked.disconnect(position_selected)
		for point in agent.get_current_navigation_path():
			make_sprite(point)
		var info:Dictionary = {"position":position,"dots":dots}
		emit_signal("selection_made",info)

func make_sprite(pos) -> void:
	var sprite = Sprite2D.new()
	sprite.position = pos
	sprite.texture = load("res://dot.png")
	dots.append(sprite)
	Global.mission.tilemap.add_child(sprite)
