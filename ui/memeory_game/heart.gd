class_name Heart
extends Control

signal gamelost

func beating_animation():
	$AnimationPlayer.play("beating_heart")
	
func lost_heart_animation():
	$AnimationPlayer.play("lost_heart")

func updateheart(heart: Heart):
	if (!heart):
		#$AnimationPlayer.play("lost_heart")
		self.lost_heart_animation()
		MemeoryManager.remove_heart()
		if(MemeoryManager.hearts_array.size() == 0):
			await 2
			MemeoryManager.clicks = 3
			MemeoryManager.gamelost.emit()
			print("HAI PERSO")
		#await 2

