extends Card

var preview : Array[int]



func handle_interaction():
	MemeoryManager.check_game_won()
	MemeoryManager.clicks = -1
	#print_debug(MemeoryManager.clicks)
	if(MemeoryManager.game_won == false):
		while(preview.size() < 2):
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var num = rng.randi_range(0, MemeoryManager.slots.size()-1)
			print_debug(preview)
			print_debug(num)
			print_debug(MemeoryManager.slots[num])
			if (MemeoryManager.slots[num] != null):
				if(preview.size() == 1):
					if(num != preview[0]):
						preview.append(num)
				else:
					#print_debug("scelgo questo numero")
					preview.append(num)
			
	#button.hide()
		print_debug(MemeoryManager.clicks)
		MemeoryManager.update.emit()
		for random_number in preview:
			MemeoryManager.slots[random_number].update_card_sprite2D_front_texture()
			#print_debug("fine front")
		MemeoryManager.update.emit()
		await get_tree().create_timer(2).timeout
		for random_number in preview:
			MemeoryManager.slots[random_number].update_card_sprite2D_back_texture()
			MemeoryManager.update.emit()
			#print_debug("tornato al back")
		#MemeoryManager.clicks = 0
		#MemeoryManager.update.emit()