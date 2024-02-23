extends Button

var character:Character
signal chosen(character:Character)

func init(char:Character):
	character = char
	text = character.name
	visible = true

func _on_pressed():
	emit_signal("chosen",character)
