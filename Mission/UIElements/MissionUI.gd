extends Control

# Bottom left: Current character icon + info
# Left: Unit cards
# Bottom: Utilities
# Bottom right: Utility info?

@export var team_cards:VFlowContainer
@export var utility_container:HFlowContainer
@export var selected_unit_info:VBoxContainer
@export var confirm_button:Button

func init(player_team:Team):
	var card_scene:PackedScene = load("res://Mission/UIElements/UnitCard/UnitCard.tscn")
	for unit in player_team.units:
		var new_card = card_scene.instantiate()
		new_card.init(unit)
		team_cards.add_child(new_card)

func unit_selected(unit:Unit):
	# Icon, name, team/faction, health
	selected_unit_info.init(unit)

func clear_utilities() -> void:
	for i in utility_container.get_children():
		i.queue_free()

func add_utility(button:Control) -> void:
	utility_container.add_child(button)

func set_utility_info(utility:Item) -> void:
	pass

func clear_utility_info() -> void:
	pass
