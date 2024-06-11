"""
Classe che gestisce i dialoghi.

Non mi va di leggere quello che c'è scritto, perciò ripeti dopo di me:
	Fine, I'll do it myself.
Bene! HF!
"""


extends Node


const dialogues = preload("res://localization/dialogue/dialogues.gd").dialogues

signal has_started_displaying
signal has_finished_displaying


func handle_dialogue_interaction(dialogue_interaction: DialogueInteraction):
	var dialogue_lines_ids = _get_dialogue_lines_ids(dialogue_interaction.dialogue_id)
	var dialogue_lines = _dialogue_lines_ids_to_dialogue_lines(dialogue_lines_ids)

	UIManager.show_dialogue_box(dialogue_lines)


func _get_dialogue_lines_ids(dialogue_id: String) -> Array:
	assert(dialogues.has(dialogue_id))
	return dialogues.get(dialogue_id)


func _dialogue_lines_ids_to_dialogue_lines(dialogue_lines_ids: Array) -> Array:
	var dialogue_lines = dialogue_lines_ids.map(
		func(dialogue_line_id: String): return tr(dialogue_line_id)
	)

	return dialogue_lines
