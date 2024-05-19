extends SelectionType

var slider
var direction_line
var unit_position
var position:Vector2
var force:int = 0
var utility

func start(_unit:Unit,_utility:Variant) -> void:
	unit_position = _unit.position
	utility = _utility
	Global.mission.position_left_clicked.connect(position_selected)

func position_selected(_position:Vector2):
	if slider != null:
		var tween = Global.mission.create_tween()
		tween.tween_interval(0.01)
		await tween.finished
		if slider.dragging:
			return
	# This is dumb and I hate it. When clicking the slider to choose the force,
	# the click was changing the position, so this prevents that
	
	if direction_line != null:
		direction_line.queue_free()
	position = _position
	direction_line = Line2D.new()
	direction_line.add_point(unit_position)
	
	var radius = 80
	var angle = (unit_position.angle_to_point(position))
	print(angle)
	var x = round(radius * cos(angle))
	var y = round(radius * sin(angle))
	var point = Vector2(x,y) + unit_position
	print(point)
	direction_line.add_point(point)
	Global.mission.tilemap.add_child(direction_line)
	
	if slider == null:
		# Dont want the force to be chosen before the position. Just feels wrong
		make_slider()
	done()

func make_slider():
	slider = load("res://Mission/UIElements/ThrowableElements/ThrowableSlider.tscn").instantiate()
	slider.init(utility)
	slider.force_chosen.connect(force_chosen)
	Global.mission.ui.add_child(slider)

func force_chosen(_force:int) -> void:
	force = _force
	done()

func done():
	if position != Vector2(0,0) and force != 0:
		slider.queue_free()
		var info:Dictionary = {"position":position,"force":force,"cleanup":[direction_line]}
		# 'cleanup' isnt a very elegant solution but it works
		emit_signal("selection_made",info)

func clear():
	if slider != null:
		slider.queue_free()
	if direction_line != null:
		direction_line.queue_free()
