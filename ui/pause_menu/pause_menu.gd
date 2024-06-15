class_name PauseMenu
extends Control


signal exit

func _on_main_menu_button_pressed():
	self.exit.emit()
	GameManager.start()


func _on_exit_pause_menu_button_pressed():
	self.exit.emit()


