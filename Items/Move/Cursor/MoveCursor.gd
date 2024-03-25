extends Node2D

func _process(_delta):
	position = Global.mission.tilemap.get_local_mouse_position()

func _on_update_timeout():
	$SpriteN.visible = false
	$SpriteE.visible = false
	$SpriteS.visible = false
	$SpriteW.visible = false
	$Impassable.visible = false
	
	if $CoverN.is_colliding() or $CoverNE.is_colliding() or $CoverNW.is_colliding():
		$SpriteN.visible = true
	if $CoverE.is_colliding() or $CoverNE.is_colliding() or $CoverSE.is_colliding():
		$SpriteE.visible = true
	if $CoverS.is_colliding() or $CoverSE.is_colliding() or $CoverSW.is_colliding():
		$SpriteS.visible = true
	if $CoverW.is_colliding() or $CoverSW.is_colliding() or $CoverNW.is_colliding():
		$SpriteW.visible = true
	
	if not $ImpassArea.get_overlapping_areas().is_empty():
		$Impassable.visible = true
