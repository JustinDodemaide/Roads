extends ConvoyAction
# TravelTo

var convoy
var destination:WorldObject
var timer:Timer
var path:PackedVector2Array
var path_index:int = -1

func _init(where:WorldObject = null):
	destination = where

func execute(_convoy:WorldObject) -> void:
	convoy = _convoy
	timer = Global.world.create_timer()
	timer.timeout.connect(_on_move_timer_timeout)
	if convoy.current_location == null:
		path = Global.world.get_astar_path(convoy, destination)
	else:
		path = Global.world.get_astar_path(convoy.current_location, destination)
	convoy.current_location = null
	timer.start(convoy.max_speed)

func _on_move_timer_timeout():
	path_index += 1
	if path_index == path.size():
		destination_reached()
		return
	convoy.world_position = path[path_index]
	var speed = convoy.max_speed
	var speed_modifier = Global.world.get_custom_data("speed_modifier", path[path_index])
	if speed_modifier == null:
		speed_modifier = 0
	speed += speed_modifier
	timer.start(speed)

func destination_reached() -> void:
	timer.queue_free()
	path_index = -1
	convoy.current_location = destination
	convoy.world_position = destination.world_position
	emit_signal("complete")

func save() -> Dictionary:
	return {"path":"res://World/WorldObjects/WO_Convoy/ConvoyActions/TravelTo.gd",
			"destination":var_to_str(destination.world_position)}

func _load(_data) -> void:
	var pos = str_to_var(_data["destination"])
	# HACK
	for i in Global.world.world_objects:
		if i.world_position == pos:
			destination = i
			return
	pass
