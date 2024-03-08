extends Camera2D

signal done_moving
var speed = 650
var last_zoom = zoom
func _process(delta):
	if Input.is_action_pressed("D"):
		position += Vector2(speed * delta, 0)
	elif Input.is_action_pressed("A"):
		position += Vector2(-speed * delta, 0)
	if Input.is_action_pressed("W"):
		position += Vector2(0, -speed * delta)
	elif Input.is_action_pressed("S"):
		position += Vector2(0, speed * delta)
		
	if Input.is_action_pressed("C"):
		if zoom < Vector2(1,1):
			zoom += Vector2(0.025,0.025)
	if Input.is_action_pressed("X"):
		if zoom > Vector2(0.5,0.5):
			zoom -= Vector2(0.025,0.025)

func move_camera_to(target):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "position", target, 0.33)
	emit_signal("done_moving")
	
func position_camera_between(point1,point2):
	print("viewport size: ",get_viewport_rect().size)
	var edge_allowance = 512
	var difference_in_x = abs(point1.x - point2.x) + edge_allowance
	var difference_in_y = abs(point1.y - point2.y) + edge_allowance
	var scale_factor = difference_in_x / get_viewport_rect().size.x
	if difference_in_y > difference_in_x:
		scale_factor = difference_in_y / get_viewport_rect().size.y
	var new_zoom = zoom.x * (1 / scale_factor)
	new_zoom = Vector2(new_zoom,new_zoom)
	if new_zoom < Vector2(0.5,0.5):
		new_zoom = Vector2(0.5,0.5)
	if new_zoom > Vector2(1,1):
		new_zoom = Vector2(1,1)
	var midpoint = Vector2((point1.x + point2.x) / 2, (point1.y + point2.y) / 2)
	print("scale factor: ", scale_factor)
	last_zoom = zoom
	var tween = create_tween()
	var tween1 = create_tween()
	#tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "zoom", new_zoom, 0.5).set_ease(Tween.EASE_OUT)
	tween1.tween_property(self, "position", midpoint, 0.33).set_trans(Tween.TRANS_LINEAR)
	print("zoom: ", zoom)
	await tween.finished
	emit_signal("done_moving")
	
func reset_zoom():
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(1,1), 0.5).set_trans(Tween.TRANS_EXPO)
	
func tile_to_global(tile: Vector2):
	var tile_size = 64
	var half_tile = tile_size * 0.5
	var n = tile
	n.x *= tile_size
	n.x += half_tile
	n.y *= tile_size
	n.y += half_tile
	return n
