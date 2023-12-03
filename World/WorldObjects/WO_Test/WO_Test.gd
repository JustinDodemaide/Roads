extends WorldObject

var bounce:int = 10
var i:int = 0
var right:bool = true

func options()->Array[WorldObjectOption]:
	return [WorldObjectOption.new("Launch Convoy")
	]

func option_chosen(option:WorldObjectOption) -> void:
	if option.option_name == "Launch Convoy":
		var dest = Global.world.world_objects.back()
		launch_convoy([],dest)

func additional_updates() -> void:
	if right:
		world_position += Vector2(10, 0)
		i += 1
		if i >= bounce:
			right = false
	if not right:
		world_position -= Vector2(10, 0)
		i -= 1
		if i == 0:
			right = true
