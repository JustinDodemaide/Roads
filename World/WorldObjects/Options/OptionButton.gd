extends Button

var option:WorldObjectOption
signal option_chosen(option:WorldObjectOption)
signal option_hovered(option:WorldMapObject)

func init(_option:WorldObjectOption) -> void:
	option = _option
	text = option.option_name
	icon = option.button_icon

func _on_pressed():
	emit_signal("option_chosen", option)


func _on_mouse_entered():
	emit_signal("option_hovered", option)
