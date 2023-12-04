extends Node

var state_machine

var world_object:WorldObject
# Interactables
# NPCs
# Placing objects
# Placing tiles
# Refactor for multiplayer

func enter(_msg:Dictionary = {})->void:
	world_object = _msg["WorldObject"]
	if world_object.level_id == 0:
		world_object.generate_level()
	Global.level = self
	load_level(world_object.level_id)

func exit()->void:
	pass

func load_level(id:int) -> void:
	pass

func _process(_delta):
	$Cursor.position = Global.world.tilemap.get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("LeftClick"):
		if $PlayerCharacter.position.distance_to($Cursor.position) > 250:
			return
		for i in $Cursor.get_overlapping_areas():
			var parent = i.get_parent()
			if parent is LevelObject:
				if parent.is_interaction_valid($PlayerCharacter):
					parent.interact($PlayerCharacter)
					break
	if event.is_action_pressed("M"):
		state_machine.transition_to("res://WorldMap/WorldMap.tscn")
	if event.is_action_pressed("1"):
		test()

func test():
	var v:Array[Vehicle]
	world_object.launch_convoy(world_object.vehicles,Global.world.world_objects.back())

func new_producer(producer:Producer):
	pass

func _on_button_pressed():
	var placer = load("res://World/WorldObjects/BlueprintPlacer.tscn").instantiate()
	placer.init(load("res://Level/LevelObjects/LO_Test/LO_Test.tscn"))
