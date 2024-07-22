extends Card


func handle_interaction():
	print("extra ok")
	
	print_debug(MemeoryManager.hearts_lost)
	if(MemeoryManager.hearts_array.size() < MemeoryManager.max_hearts):
		if(MemeoryManager.hearts_lost.size()>1):
			for i in range(0,2):
				print_debug("due vite")
				print_debug(i)
				print_debug(MemeoryManager.hearts_lost[0])
				#print_debug(MemeoryManager.hearts_lost[1])
				MemeoryManager.hearts_lost[0].recover = true
				MemeoryManager.insert_heart(MemeoryManager.hearts_lost[0])
				MemeoryManager.hearts_lost.remove_at(0)
				print_debug(MemeoryManager.hearts_array)
		else:
			print_debug("solo una vita")
			MemeoryManager.insert_heart(MemeoryManager.hearts_lost[0])
			MemeoryManager.hearts_lost.remove_at(0)
			print_debug(MemeoryManager.hearts_array)
	#MemeoryManager.recover_heart()
