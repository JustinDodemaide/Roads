extends PanelContainer

var unit:Unit
@export var icon_rect:TextureRect
@export var name_label:Label
@export var health_bar:ProgressBar

func init(_unit:Unit) -> void:
	unit = _unit
	var character:Character = unit.character
	icon_rect.texture = character.icon
	name_label.text = character.name
	health_bar.max_value = character.max_health
	health_bar.value = health_bar.max_value
	unit.changed.connect(update)

func update() -> void:
	# Assuming name and icon won't change during the mission
	health_bar.value = unit.health
	if not unit.available:
		$Button.disabled = true

func _on_button_pressed():
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1.5,1.5),0.1)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(self,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_ELASTIC)
