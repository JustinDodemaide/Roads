extends Control

@onready var scale_label = $VBoxContainer/Scale

func _on_pause_pressed():
	Engine.time_scale = 0
	scale_label.text = "Paused"

func _on_play_pressed():
	Engine.time_scale = 1
	scale_label.text = ""

func _on_fast_pressed():
	Engine.time_scale = 2
	scale_label.text = "2x"
