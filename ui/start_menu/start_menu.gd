class_name StartMenu
extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var resume_button = $VBoxContainer/ResumeButton
@onready var logout_button = $VBoxContainer/LogOutButton
@onready var exit_button = $VBoxContainer/ExitButton
@onready var credits_button = $VBoxContainer/CreditsButton
@onready var fade: Fade = $Fade

signal exit

func _ready():
	resume_button.hide()
	if !AuthenticationManager.is_enabled or not await SaveManager.is_online():
		logout_button.hide()
		

func show_resume_button():
	play_button.hide()
	resume_button.show()
	exit_button.show()
	credits_button.show()
	show_logout_button()

func show_play_button():
	resume_button.hide()
	play_button.show()
	show_logout_button()

func show_logout_button():
	if AuthenticationManager.is_enabled:
		logout_button.show()


#Quando si clicca su play, viene caricato il salvataggio
func _on_play_button_pressed():
	AudioManager.stop_current_sound_track()
	_hide_all_buttons()
	_fade_in()
	UIManager.show_loading_screen() #Fai vedere il loading screen
	await SaveManager.load_game_save_from_json() #Fai il caricamento dei file di gioco
	await UIManager.loading_screen.exit_from_loading_screen_evenly() #Se ha finito di caricare, la barra va al 100%
	UIManager.kil_loading_screen() #Sono uscito dal loading screen, quindi faccio killare l'elemento UI alla UIManager
	_fade_out()
	self.exit.emit()
	AudioManager.play_main_theme_sound_track()

func _fade_in():
	fade.show()
	fade.fade_in()


func _fade_out():
	fade.fade_out()
	fade.hide()


func _hide_all_buttons():
	if AuthenticationManager.is_enabled:
		logout_button.hide()

	play_button.hide()
	resume_button.hide()
	exit_button.hide()
	credits_button.hide()

func _hide_logout_button():
	logout_button.hide()


func _on_exit_button_pressed():
	GameManager.exit()


func _on_log_out_button_pressed():
	UIManager.hide_mobile_ui()
	AuthenticationManager.sign_out()
	await Supabase.auth.signed_out
	remove_auth_file()
	self.exit.emit()
	UIManager.use_start_menu_with_resume_button = false
	print_debug("\n--------------------------------------------------\n\tRESET CALLED\n--------------------------------------------------\n")
	UIManager.respawn_minigame_UI_nodes()
	SaveManager.reset_save()
	StateManager.inventory.update.emit()
	GameManager.start()
	
	
func remove_auth_file():
	DirAccess.remove_absolute("user://user.auth")
	#DirAccess.remove_absolute("user://save.json")

func _on_resume_button_pressed():
	UIManager.show_mobile_ui()
	AudioManager.stop_current_sound_track()
	self.exit.emit()
	AudioManager.play_main_theme_sound_track()
	



