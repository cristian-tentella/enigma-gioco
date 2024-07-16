extends Node


const ENGLISH = "en_US"
const ITALIAN = "it_IT"


func _ready():
	StateManager.current_language = TranslationServer.get_locale()


func _set_language(language: String):
	TranslationServer.set_locale(language)
	StateManager.current_language = TranslationServer.get_locale()


func change_language():
	_set_language(_get_next_language())


func _get_next_language() -> String:
	if StateManager.current_language == ENGLISH:
		return ITALIAN
	else:
		return ENGLISH
