extends CharacterItem
class_name CharacterItem_BulletFiring

@export_range(1, 15, 2) var bullet_speed:int = 9
@export var max_distance:float = 1000
@export var muzzle_flash_color:Color = Color.ORANGE
@export var bullet_light_color:Color = Color.ORANGE

@export var damage:int
@export var impact_effects:PackedStringArray

var target:Unit
var miss:bool
var bullet

func execute(actor:Unit,_selection_info:Dictionary) -> void:
	target = _selection_info["target"]
	bullet = load("res://Mission/MissionObjects/Bullet_Generic/Bullet.tscn").instantiate()
	bullet.set_speed(bullet_speed)
	bullet.set_max_distance(max_distance)
	bullet.hit_area.connect(bullet_hit_area)
	bullet.max_distance_reached.connect(bullet_traveled_max_distance)
	if randi_range(0,100) > _selection_info["percent"]:
		# Miss
		miss = true
		var pos = get_miss_position(target.position)
		bullet.init(actor.position,pos)
	else:
		bullet.init(actor.position,target.position)

func get_miss_position(target:Vector2) -> Vector2:
	var x = target.x + randi_range(-100,100)
	var y = target.y + randi_range(-100,100)
	return Vector2(x,y)

func bullet_hit_area(bullet,area) -> void:
	var parent = area.get_parent()
	if parent == null:
		return
	if miss:
		# If the shot missed, interact with the first area it hits
		hit(parent)
		return
	if parent == target:
		# If the shot didn't miss, only interact when the target is reached
		hit(parent)

func hit(object) -> void:
	apply_effects(object)
	bullet.queue_free()
	emit_signal("complete")
	
func apply_effects(to):
	if not to.has_method("add_effect"):
		return
	for effect in impact_effects:
		to.add_effect(effect)

func bullet_traveled_max_distance(bullet) -> void:
	emit_signal("complete")
