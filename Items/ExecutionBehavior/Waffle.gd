extends UtilityExecutionBehavior

func execute(utility:Item,actor:Unit,_selection_info:Dictionary) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = load("res://icon.svg")
	sprite.position = _selection_info["position"]
	Global.mission.tilemap.add_child(sprite)
