class_name PauseMenu
extends Control


signal exit


#Quando preme il tasto per tornare al menu principale
func _on_main_menu_button_pressed():
	SaveManager.prepare_data_to_be_saved_and_save()
	self.exit.emit()
	UIManager.show_start_menu()
	


func _on_exit_pause_menu_button_pressed():
	self.exit.emit()
	
	if PlatformHelper.is_mobile():
		UIManager.mobile_only_ui.show()
