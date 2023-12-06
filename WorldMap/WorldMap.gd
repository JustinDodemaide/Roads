extends Node

var state_machine

var selected_object:WorldMapObject

func enter(_msg:Dictionary = {})->void:
	for object in Global.world.world_objects:
		new_map_object(object)
	Global.world.tilemap.visible = true
	Global.world.new_object.connect(new_map_object)
	Global.world.removed_object.connect(new_map_object)

func exit()->void:
	Global.world.tilemap.visible = false

func _process(delta):
	$Cursor.position = Global.world.tilemap.get_global_mouse_position()
	$UI/GeneralInfo/WorldPosition.text = "(" + str(round($Cursor.position.x)) + ", " + str(round($Cursor.position.y)) + ")"

func _input(event):
	if event.is_action_pressed("LeftClick"):
		var areas = $Cursor.get_overlapping_areas()
		if not areas.is_empty():
			select(areas.front().get_parent())
		else:
			pass
			# Need a way to not deselect when clicking UI
			#deselect()
	
	if event.is_action_pressed("M"):
		state_machine.transition_to("res://Level/Level.tscn",  {"WorldObject": Global.world.world_objects.front()})

func select(map_object:WorldMapObject) -> void:
	selected_object = map_object
	# Do an animation
	update_ui()

func deselect() -> void:
	# Do an animation
	clear_ui()

func update_ui() -> void:
	if selected_object == null:
		return
	clear_ui()
	var button_scene = preload("res://World/WorldObjects/Options/OptionButton.tscn")
	var object = selected_object.world_object
	for option in object.options():
		var option_button = button_scene.instantiate()
		option_button.init(option)
		option_button.option_chosen.connect(option_chosen)
		$UI/Options.add_child(option_button)
	for i in selected_object.world_object.info():
		var label = Label.new()
		label.text = i
		$UI/VBoxContainer.add_child(label)

func clear_ui() -> void:
	for i in $UI/Options.get_children():
		i.queue_free()
	for i in $UI/VBoxContainer.get_children():
		i.queue_free()
	
func option_chosen(option:WorldObjectOption) -> void:
	selected_object.world_object.option_chosen(option)
	deselect()

func new_map_object(object:WorldObject) -> void:
	var packed_map_object:PackedScene = preload("res://WorldMap/WorldMapObject/WorldMapObject.tscn")
	var new_wmo = packed_map_object.instantiate()
	new_wmo.init(object)
	add_child(new_wmo)

func remove_world_object(object:WorldObject) -> void:
	for i in get_children():
		if i is WorldMapObject:
			if i.world_object == object:
				i.queue_free()
				return
