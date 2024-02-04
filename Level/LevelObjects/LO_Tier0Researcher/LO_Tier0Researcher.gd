extends LevelObject

var current_project:ResearchProject

func _name():
	return "Tier0 Researcher"

func is_interaction_valid(_interactor) -> bool:
	return true

func interact(_interactor) -> void:
	pass

func _on_option_button_item_selected(index):

	Global.world.world_update.connect(update_project)

func update_project():
	current_project.update()
