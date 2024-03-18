extends CharacterItem_Throwable

func execute(_actor:Unit,_selection_info:Dictionary) -> void:
	emit_signal("complete")
