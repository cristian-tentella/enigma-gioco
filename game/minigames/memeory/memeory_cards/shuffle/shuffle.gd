extends Card


# Called when the node enters the scene tree for the first time.
func handle_interaction():
	MemeoryManager.slots.shuffle()
	#MemeoryManager.update.emit()
