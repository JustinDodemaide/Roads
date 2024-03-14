extends VBoxContainer

func init(unit:Unit):
	var character = unit.character
	$Icon.texture = character.icon
	$Name.text = character.name
	$Team.text = "(Faction name)"
