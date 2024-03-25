extends Node2D

func _process(_delta):
	position = Global.mission.tilemap.get_local_mouse_position()

func _on_update_timeout():
	$SpriteN.visible = false
	$SpriteE.visible = false
	$SpriteS.visible = false
	$SpriteW.visible = false
	$Impassable.visible = false
	
	$CoverSensor.update()
	$SpriteN.visible = $CoverSensor.north
	$SpriteE.visible = $CoverSensor.east
	$SpriteS.visible = $CoverSensor.south
	$SpriteW.visible = $CoverSensor.west
	
	if not $ImpassArea.get_overlapping_areas().is_empty():
		$Impassable.visible = true
