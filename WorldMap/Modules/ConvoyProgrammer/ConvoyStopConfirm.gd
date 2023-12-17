extends Button

signal confirmed

func _ready():
	var tween = create_tween()
	tween.tween_interval(0.5)
	await tween.finished
	disabled = false

func _on_pressed():
	emit_signal("confirmed")
	queue_free()
