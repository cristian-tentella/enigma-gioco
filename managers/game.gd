"""
GameManager

Gestisce la UI iniziale, quindi mostra soltanto i pulsanti iniziali, in attesa di un click su qualcosa.
In base al tasto selezionato, mostra il relativo comportamento.

"""
extends Node


#Chiamata da game/game.gd, a sua volta invocato in game.tscn con _ready()
func start():
	#Nascondi tutti i componenti di game.tscn tranne la UI; Inizialmente ci deve essere solo la UI coi tasti di scelta
	
	
	StateManager.player.hide()
	StateManager.house.hide()
	UIManager.mobile_only_ui.hide()
	
	
	AudioManager.play_start_menu_sound_track()
	
	if AuthenticationManager.is_enabled:
		AuthenticationManager.display_report_message("")
		UIManager.show_authentication_menu()
		StateManager.is_online = await SaveManager.is_online()
		if StateManager.is_online == false:
			AuthenticationManager.display_report_message("Connection error")
			AuthenticationManager.is_enabled = false
		await AuthenticationManager.exit
		if AuthenticationManager.is_enabled == false: ##se play offline e' stato premuto, risultera' in is_enabled = false
			UIManager.start_menu._hide_logout_button()
		
	
	#Mostra il menu iniziale 
	UIManager.show_start_menu()
	await UIManager.start_menu.exit
  
	if PlatformHelper.is_mobile():
		UIManager.mobile_only_ui.show()
	else:
		UIManager.mobile_only_ui.hide()

	AudioManager.stop_current_sound_track()
	AudioManager.play_main_theme_sound_track()

	#Mostra i componenti della scena necessari a far partire il gioco
	StateManager.player.show()
	StateManager.house.show()

#Se clicca il tasto di EXIT, distruggi tutto e addio.
func exit():
	get_tree().quit()
