extends Sprite2D

func _ready():
	var tween = create_tween()
	modulate = Color(1,1,1,0)
	tween.tween_property(self,"modulate",Color(1,1,1,1),1)

func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(255,255,255,0),6)
	await tween.finished
	queue_free()
