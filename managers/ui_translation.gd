extends Node

const ui_components_translations = preload("res://localization/ui/ui.gd").ui_components


func handle_ui_translation(ui_element: Control):

	if ui_element is AuthenticationMenu:
		handle_auth_translations()
	elif ui_element is StartMenu:
		handle_start_translations(ui_element)
	elif ui_element is PauseMenu:
		handle_pause_translations()



func handle_auth_translations():
	pass
			

func handle_start_translations(start_menu):
	start_menu.get_node("VBoxContainer/ExitButton").text = tr("test_2")
	
	
func handle_pause_translations():
	pass
