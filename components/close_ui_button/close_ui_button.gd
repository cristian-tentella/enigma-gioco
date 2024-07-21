extends TextureButton


func _on_pressed():
	AudioManager.play_click_sound_effect()
