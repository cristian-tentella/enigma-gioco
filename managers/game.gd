extends Node


func start():
	StateManager.player.hide()
	StateManager.house.hide()

	UIManager.show_start_menu()
	await UIManager.start_menu.exit
	
	StateManager.player.show()
	StateManager.house.show()


func exit():
	get_tree().quit()
