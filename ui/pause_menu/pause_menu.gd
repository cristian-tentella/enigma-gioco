class_name PauseMenu
extends Control


signal exit

#Quando preme il tasto per tornare al menu principale
func _on_main_menu_button_pressed():
	SaveManager.save_current_state_into_json()
	self.exit.emit()
	GameManager.start()


func _on_exit_pause_menu_button_pressed():
	self.exit.emit()


