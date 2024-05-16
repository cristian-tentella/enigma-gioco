class_name PauseMenu
extends Node


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://ui/start_menu/start_menu.tscn")
