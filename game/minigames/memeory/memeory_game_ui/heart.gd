class_name Heart
extends Control

signal gamelost

func beating_animation():
	$AnimationPlayer.play("beating_heart")
	
func lost_heart_animation():
	$AnimationPlayer.play("lost_heart")

func updateheart(heart: Heart):
	if (!heart):
		self.lost_heart_animation()
		MemeoryManager.remove_heart()
		if(MemeoryManager.hearts_array.size() == 0):
			MemeoryManager.clicks = -1
			StateManager.current_minigame = 6
			MemeoryManager.gamelost.emit()


