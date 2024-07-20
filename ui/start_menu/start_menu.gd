class_name StartMenu
extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var resume_button = $VBoxContainer/ResumeButton
@onready var logout_button = $VBoxContainer/LogOutButton
@onready var exit_button = $VBoxContainer/ExitButton
@onready var fade: Fade = $Fade

signal exit

func _ready():
	resume_button.hide()
	if !AuthenticationManager.is_enabled:
		logout_button.hide()
		logout_button.queue_free()

func show_resume_button():
	play_button.hide()
	play_button.queue_free()
	play_button = null
	resume_button.show()
	

#Quando si clicca su play, viene caricato il salvataggio
func _on_play_button_pressed():
	_hide_all_buttons()
	_fade_in()
	UIManager.show_loading_screen() #Fai vedere il loading screen
	await SaveManager.load_game_save_from_json() #Fai il caricamento dei file di gioco
	await UIManager.loading_screen.exit_from_loading_screen_evenly() #Se ha finito di caricare, la barra va al 100%
	UIManager.kil_loading_screen() #Sono uscito dal loading screen, quindi faccio killare l'elemento UI alla UIManager
	_fade_out()
	self.exit.emit()


func _fade_in():
	fade.show()
	fade.fade_in()


func _fade_out():
	fade.fade_out()


func _hide_all_buttons():
	if AuthenticationManager.is_enabled:
		logout_button.hide()

	play_button.hide()
	resume_button.hide()
	exit_button.hide()


func _on_exit_button_pressed():
	GameManager.exit()


func _on_log_out_button_pressed():
	AuthenticationManager.sign_out()


func _on_resume_button_pressed():
	self.exit.emit()
