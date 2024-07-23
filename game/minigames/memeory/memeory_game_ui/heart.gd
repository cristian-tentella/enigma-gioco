class_name Heart
extends Control
var recover = false
signal gamelost
var reset_animation = false
var show_heart = true

func beating_animation():
	self.show()
	$AnimationPlayer.play("beating_heart")
	
func stop_animation():
	#print_debug("stop")
	$AnimationPlayer.stop()
	
func lost_heart_animation():
	$AnimationPlayer.play("lost_heart")
	#await get_tree().create_timer(1.5).timeout
	#self.hide()

func recover_heart_animation():
	self.show()
	$AnimationPlayer.play("gain_heart")

func updateheart(heart: Heart):
	#print_debug(recover)
	if (!heart):
		self.lost_heart_animation()
		self.show_heart = false
		MemeoryManager.remove_heart()
		#print_debug(MemeoryManager.hearts_array.size())
		if(MemeoryManager.hearts_array.size() == 0):
			MemeoryManager.clicks = -1
			MemeoryManager.gamelost.emit()
	if(recover):
		print_debug("entro nel recover")
		recover = false
		#self.show_heart = true
		#print_debug(self.show_heart)
		self.recover_heart_animation()
		#self.reset_animation = true
	
