extends Effect

func name() -> String:
	return "Effect"

func max_applications() -> int:
	return 3

func apply(unit:Unit) -> void:
	unit.damage(1)
	remaining_applications -= 1
	if remaining_applications == 0:
		unit.effects.erase(self)
