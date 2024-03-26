extends VBoxContainer

func init(unit:Unit):
	var character = unit.character
	$Icon.texture = character.icon
	$Name.text = character.name
	# $Team.text = character.faction.faction_name
	# for testing purposes, the characters we're making dont have factions
	$Team.text = "(Faction Name)"
	if unit.team == Global.mission.attacking_team:
		$Team.text += " (Attacker)"
	else:
		$Team.text += " (Defender)"
	$Health.text = "Health: " + str(unit.health)
