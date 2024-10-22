"""
Classe che gestisce i dialoghi.

Non mi va di leggere quello che c'è scritto, perciò ripeti dopo di me:
	Fine, I'll do it myself.
Bene! HF!
"""


extends Node


const dialogues = preload("res://localization/dialogue/dialogues.gd").dialogues
const DIALOGUE_WITH_SOUND_EFFECT_PREFIX = "sound_effect_"

signal has_started_displaying
signal has_finished_displaying

"""
Dato un dialogue_id, definito nella variabile esportata della scena "components/interaction/dialogue_interaction/dialogue_interaction.tscn",
prende tutti gli ID delle linee di dialogo riferite a quel dialogue_id dal Dictionary definito in "localization/dialogue/dialogues.gd",
poi da quegli ID si prende le vere e proprie linee di dialogo dal file csv ("localization/dialogue/dialogue.csv") usando il metodo tr
per poi farle mostrare attraverso UIManager
"""
func handle_dialogue_interaction(dialogue_interaction: DialogueInteraction):
	var dialogue_lines_ids = _get_dialogue_lines_ids(dialogue_interaction.dialogue_id)
	var dialogue_lines = _dialogue_lines_ids_to_dialogue_lines(dialogue_lines_ids)

	UIManager.show_dialogue_box(dialogue_lines)

#Mi sa che questa non la usiamo mai...
#handle_dialogue_interaction_with_dynamic_replace(dialogue_interaction, "Item", item_name)
func handle_dialogue_interaction_with_dynamic_replace(dialogue_interaction: DialogueInteraction, word_to_be_replaced: String, replace_word: String):
	var dialogue_lines_ids = _get_dialogue_lines_ids(dialogue_interaction.dialogue_id)
	var dialogue_lines = _dialogue_lines_ids_to_dialogue_lines(dialogue_lines_ids)

	UIManager.show_dialogue_box(dialogue_lines.replace(word_to_be_replaced, replace_word))


func _get_dialogue_lines_ids(dialogue_id: String) -> Array:
	#if not dialogues.has(dialogue_id)
	#	print_debug(dialogue_id)
	#	return []
	assert(dialogues.has(dialogue_id))
	return dialogues.get(dialogue_id)

"""
Metodo che prende gli id di singole righe di dialogo e le converte nelle versioni tradotte nella lingua impostata dal giocatore
"""
func _dialogue_lines_ids_to_dialogue_lines(dialogue_lines_ids: Array) -> Array:
	var dialogue_lines = []

	for dialogue_line_id in dialogue_lines_ids:
		var id: String = dialogue_line_id
		var line: String

		if id.begins_with(DIALOGUE_WITH_SOUND_EFFECT_PREFIX):
			#var sound_effect_name: String = id.erase(0, DIALOGUE_WITH_SOUND_EFFECT_PREFIX.length())
			# sound_effect_light_saber ; light saber ; spada laser
			# diventa
			# line -> sound_effect_light_saber : light saber ; sound_effect_light_saber : spada laser
			line = id + ":" + tr(id)
		else:
			line = tr(id)

		dialogue_lines.append(line)

	return dialogue_lines


#Utilizzo improprio ma funzionale del sistema dei dialoghi anche per le traduzioni degli item
#Non vale la pena implementarlo in modo diverso
func _item_description_id_to_item_description(item_description_id: String):
	return _dialogue_lines_ids_to_dialogue_lines([item_description_id])[0]
