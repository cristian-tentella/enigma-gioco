extends Control

@onready var italian_flag = $ItalianFlag
@onready var united_kingdom_flag = $UnitedKingdomFlag


func _ready():
	_update_flag()


func _update_flag():
	if StateManager.current_language == LanguageManager.ENGLISH:
		_show_united_kingdom_flag()
	else:
		_show_italian_flag()


func _on_flag_pressed():
	LanguageManager.change_language()
	_update_flag()
	AudioManager.play_click_sound_effect()


func _show_italian_flag():
	italian_flag.show()
	united_kingdom_flag.hide()

func _show_united_kingdom_flag():
	united_kingdom_flag.show()
	italian_flag.hide()


func _on_visibility_changed():
	_update_flag()
