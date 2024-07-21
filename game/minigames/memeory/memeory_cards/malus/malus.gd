extends Card


# Called when the node enters the scene tree for the first time.
func handle_interaction():
	print_debug(MemeoryManager.hearts_array[0])
	if (MemeoryManager.hearts_array.size()>1):
		MemeoryManager.remove_heart_from_array()
