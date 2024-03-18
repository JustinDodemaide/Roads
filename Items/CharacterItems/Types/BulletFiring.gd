extends CharacterItem
class_name CharacterItem_BulletFiring

@export_range(1, 15, 2) var bullet_speed:int = 9
@export var muzzle_flash_color:Color = Color.ORANGE
@export var bullet_light_color:Color = Color.ORANGE

func execute(actor:Unit,_selection_info:Dictionary) -> void:
	var bullet = load("res://Mission/MissionObjects/Bullet_Generic/Bullet.tscn").instantiate()
	bullet.set_speed(bullet_speed)
	if randi_range(0,100) > _selection_info["percent"]:
		# Miss
		var pos = get_miss_position(_selection_info["target"].position)
		bullet.init(self,actor,pos)
	else:
		bullet.init(self,actor,_selection_info["target"])
	emit_signal("complete")

func get_miss_position(target:Vector2) -> Vector2:
	var x = target.x + randi_range(-100,100)
	var y = target.y + randi_range(-100,100)
	return Vector2(x,y)
