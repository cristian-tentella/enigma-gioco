extends TextureButton


func _on_pressed():
	AudioManager.play_reset_sound_effect()
