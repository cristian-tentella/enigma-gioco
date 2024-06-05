class_name StartMenu
extends Control


signal exit


func _on_play_button_pressed():
	self.exit.emit()


func _on_exit_button_pressed():
	GameManager.exit()


func _on_log_out_button_pressed():
	AuthenticationManager.sign_out()
