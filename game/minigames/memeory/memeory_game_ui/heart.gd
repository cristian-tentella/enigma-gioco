class_name Heart
extends Control
var recover = false
signal gamelost

func beating_animation():
	$AnimationPlayer.play("beating_heart")
	
func lost_heart_animation():
	$AnimationPlayer.play("lost_heart")
	
func recover_heart_animation():
	$AnimationPlayer.play("gain_heart")

func updateheart(heart: Heart):
	#print_debug(recover)
	if (!heart):
		self.lost_heart_animation()
		MemeoryManager.remove_heart()
		#print_debug(MemeoryManager.hearts_array.size())
		if(MemeoryManager.hearts_array.size() == 0):
			MemeoryManager.clicks = -1
			StateManager.current_minigame = 6
			MemeoryManager.gamelost.emit()
	if(recover):
		recover = false
		#print("ciao")
		self.recover_heart_animation()


