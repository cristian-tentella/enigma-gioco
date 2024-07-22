extends Control


@onready var muted_button = $Muted
@onready var unmuted_button = $Unmuted


func _ready():
	_load_muted_from_state_manager()
	_update_icon()


func _toggle_mute():
	AudioManager.set_mute(not AudioManager.is_muted())
	_save_muted_to_state_manager()
	_update_icon()


func _on_pressed():
	_toggle_mute()
	AudioManager.play_click_sound_effect()


func _update_icon():
	if AudioManager.is_muted():
		muted_button.show()
		unmuted_button.hide()
	else:
		unmuted_button.show()
		muted_button.hide()


func _save_muted_to_state_manager():
	StateManager.muted = AudioManager.is_muted()


func _load_muted_from_state_manager():
	AudioManager.set_mute(StateManager.muted)


func _on_visibility_changed():
	_update_icon()
