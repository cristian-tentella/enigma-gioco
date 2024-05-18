class_name StartMenu
extends Node


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game/game.tscn")
