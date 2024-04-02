extends Node2D

func _process(_delta):
	position = Global.mission.tilemap.get_local_mouse_position()
	$CoverSensor.update()
	$SpriteN.visible = $CoverSensor.north
	$SpriteE.visible = $CoverSensor.east
	$SpriteS.visible = $CoverSensor.south
	$SpriteW.visible = $CoverSensor.west
	$Impassable.visible = not $ImpassArea.get_overlapping_areas().is_empty()
