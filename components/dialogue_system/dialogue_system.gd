class_name DialogueSystem
extends Node


const dialogues = preload("res://localization/dialogue/dialogues.gd").dialogues


func process_dialogue_interaction(dialogue_interaction: DialogueInteraction):
	if not dialogues.has(dialogue_interaction.dialogue_id):
		return
	var dialogue_lines_ids = dialogues.get(dialogue_interaction.dialogue_id)

	var dialogue_lines = []
	for dialogue_line_id in dialogue_lines_ids:
		dialogue_lines.append(tr(dialogue_line_id))

	show_dialogue_box(dialogue_lines)


# TODO: add type hint to dialogue_lines (Array[String] doesn't work?!)
func show_dialogue_box(dialogue_lines):
	# TODO: implement dialogue_box
	for line in dialogue_lines:
		print_debug(line)
