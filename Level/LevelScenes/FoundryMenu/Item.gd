extends Control

@export var texture:TextureRect
@export var name_label:Label
@export var select_button:Button

var item:Item
signal item_selected(item:Item)

#@export var name:String
#@export var icon:Texture2D
#@export var tooltip_text:String = "\n"
#@export var equippable:bool = false
#@export var cost:Dictionary
#@export var build_time:int

func init(i:Item) -> void:
	item = i
	texture.texture = i.icon
	name_label.text = i.name
	visible = true

func _on_button_pressed():
	emit_signal("item_selected",item)
