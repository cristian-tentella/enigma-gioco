class_name StartMenu
extends Control


signal exit


func _on_play_button_pressed():
	self.exit.emit()


func _on_exit_button_pressed():
	GameManager.exit()
