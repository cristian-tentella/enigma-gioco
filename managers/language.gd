extends Node


const ENGLISH = "en_US"
const ITALIAN = "it_IT"


func get_language() -> String:
	return TranslationServer.get_locale()


func change_language():
	_set_language(_get_next_language())


func save_language_to_state_manager():
	StateManager.current_language = get_language()


func load_language_from_state_manager():
	TranslationServer.set_locale(StateManager.current_language)


func _ready():
	save_language_to_state_manager()


func _set_language(language: String):
	TranslationServer.set_locale(language)
	save_language_to_state_manager()


func _get_next_language() -> String:
	if StateManager.current_language == ENGLISH:
		return ITALIAN
	else:
		return ENGLISH
