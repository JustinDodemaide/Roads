extends Node2D
class_name EffectArea

@export var area:Area2D
@export var initial_flash:PointLight2D

var effects:Array[Effect]
var lifetime:int = 0 # How many turns it exists before being freed

func init(_position:Vector2,_effects:Array[Effect]) -> void:
	effects = _effects
	position = _position
	Global.mission.effect_areas.add_child(self)

func set_lifetime(turns:int) -> void:
	lifetime = turns

func set_radius(radius:int) -> void:
	scale = Vector2(radius,radius)

func set_initial_flash_color(color:Color) -> void:
	initial_flash.color = color

func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent == null:
		return
	for effect in effects:
		parent.add_effect(effect)

func new_turn():
	lifetime -= 1
	if lifetime == 0:
		queue_free()
