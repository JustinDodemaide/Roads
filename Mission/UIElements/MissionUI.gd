extends Control

# Bottom left: Current character icon + info
# Left: Unit cards
# Bottom: Utilities
# Bottom right: Utility info?

@export var utility_container:HFlowContainer
@export var selected_unit_info:VBoxContainer

func init(player_team:Team):
	for unit in player_team.units:
		pass

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
