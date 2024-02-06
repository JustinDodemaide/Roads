extends Button

var module:PlayerAction

func init(mod:PlayerAction) -> void:
	module = mod
	icon = module.icon()
	text = module.text()

func _on_pressed():
	pass
