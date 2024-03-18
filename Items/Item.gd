extends Node
class_name Item

@export var item_name:String
@export var icon:Texture2D = load("res://Items/DefaultItemIcon.png")
@export_multiline var tooltip_text:String = ""

@export var cost:Dictionary
@export var build_time:int
