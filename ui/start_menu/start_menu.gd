class_name StartMenu
extends Control


signal exit

#Quando si clicca su play, viene caricato il salvataggio
func _on_play_button_pressed():
	UIManager.show_loading_screen() #Fai vedere il loading screen
	await SaveManager.load_game_save_from_json() #Fai il caricamento dei file di gioco
	await get_tree().create_timer(0.001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
	await UIManager.loading_screen.exit_from_loading_screen_evenly() #Se ha finito di caricare, la barra va al 100%
	UIManager.kil_loading_screen() #Sono uscito dal loading screen, quindi faccio killare l'elemento UI alla UIManager
	self.exit.emit()


func _on_exit_button_pressed():
	GameManager.exit()


func _on_log_out_button_pressed():
	AuthenticationManager.sign_out()
