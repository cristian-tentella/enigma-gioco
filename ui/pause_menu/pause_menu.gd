class_name PauseMenu
extends Node


signal exit


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://ui/start_menu/start_menu.tscn")
	UIManager.unlock.emit()


func _on_exit_pause_menu_button_pressed():
	self.exit.emit()
