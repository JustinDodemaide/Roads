extends Node

var state_machine = null

var location:WorldObject

func enter(_msg := {}) -> void:
	location = _msg["location"]
	$ConfirmButton.position = location.world_position
	
	# The input from clicking the map is going through and clicking the
	# confirm button, so wait a second
	var tween = create_tween()
	tween.tween_interval(0.1)
	await tween.finished
	$ConfirmButton.visible = true
	
	#state_machine.world_map.map_object_clicked.connect(different_object_clicked)

func exit() -> void:
	$ConfirmButton.visible = false
	
	#state_machine.world_map.map_object_clicked.disconnect(different_object_clicked)

func _on_confirm_button_pressed():
	# Make item menu
	# Update confirm and complete circuit buttons
	state_machine.add_stop(location)
	state_machine.transition_to("FollowUpPicker",{"location": location})

#func different_object_clicked(map_object:WorldMapObject):
#	state_machine.transition_to("ConfirmButton",{"location": map_object.world_object})
