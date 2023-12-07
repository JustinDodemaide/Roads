extends WorldObject

var bounce:int = 10
var right:bool = true
var i:int = 0

func options()->Array[WorldObjectOption]:
	var o:Array[WorldObjectOption] = []
	o.append(WorldObjectOption.new("Launch Convoy"))
	
	if Global.player_location != self and faction == "PLAYER":
		o.append(WorldObjectOption.new("Go to Location"))
	return o

func option_chosen(option:WorldObjectOption) -> void:
	var s = self
	if option.option_name == "Go to Location":
		Global.scene_handler.transition_to("res://Level/Level.tscn",{"WorldObject":s})

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
