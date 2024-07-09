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

	#UIManager.show_authentication_menu()
	#await AuthenticationManager.exit
  	
	#UIManager.show_authentication_reset_menu()
	#await AuthenticationManager.exit
	
	#Mostra il menu iniziale
	UIManager.show_start_menu() 
	
	#Resta nella schermata di selezione finché non viene cliccato un tasto
	await UIManager.start_menu.exit 
	
	#Mostra i componenti della scena necessari a far partire il gioco
	StateManager.player.show()
	StateManager.house.show()



#Se clicca il tasto di EXIT, distruggi tutto e addio.
func exit():
	get_tree().quit()
