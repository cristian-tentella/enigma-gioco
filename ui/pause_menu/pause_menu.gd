class_name PauseMenu
extends Control


signal exit


#Quando preme il tasto per tornare al menu principale
func _on_main_menu_button_pressed():
	AudioManager.set_volume(0)
	SaveManager.prepare_data_to_be_saved_and_save()
	self.exit.emit()
	UIManager.show_start_menu()
	


func _on_exit_pause_menu_button_pressed():
	AudioManager.stop_current_sound_track()
	self.exit.emit()
	
	if PlatformHelper.is_mobile():
		UIManager.mobile_only_ui.show()
	AudioManager.set_volume(0)
	AudioManager.play_main_theme_sound_track()
	
