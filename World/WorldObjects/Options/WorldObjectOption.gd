class_name WorldObjectOption

var option_name:String
var button_icon:Texture2D

func _init(_option_name:String,_button_icon:Texture2D = load("res://World/WorldObjects/Options/outline_dashboard_black_24dp.png")) -> void:
	option_name = _option_name
	button_icon = _button_icon
