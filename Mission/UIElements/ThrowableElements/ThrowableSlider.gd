extends PanelContainer

@export var label:Label
@export var slider:VSlider
var dragging:bool = false
signal force_chosen(force:int)

func init(item:Variant) -> void:
	slider.add_theme_icon_override("grabber",item.icon)
	slider.add_theme_icon_override("grabber_highlight",item.icon)

func _on_v_slider_drag_ended(_value_changed):
	dragging = false
	label.visible = false
	if slider.value > 99:
		slider.value = 100
		return # If the reset it to the top, it cancels it
	var force = round(int(100 - slider.value) / 10)
	# The slider is "upside down", pulling further down should give more force,
	# so substract it by 100
	# Then, the force needs to be on a scale of 1-10, so divide it by 10
	emit_signal("force_chosen",force)


func _on_v_slider_drag_started():
	# label.visible = true
	dragging = true
