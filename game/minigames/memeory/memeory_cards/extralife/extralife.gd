extends Card


func handle_interaction():
	print("extra ok")
	if(MemeoryManager.hearts_array.size() < MemeoryManager.max_hearts):
		MemeoryManager.insert_heart(MemeoryManager.last_heart_lost)
		print_debug(MemeoryManager.hearts_array)
	#MemeoryManager.recover_heart()
