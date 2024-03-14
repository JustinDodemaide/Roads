extends VBoxContainer

func init(unit:Unit):
	var character = unit.character
	$Name.text = unit.name#character.name
	$Team.text = "(Faction name)"
