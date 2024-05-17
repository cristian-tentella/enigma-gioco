class_name DialogueSystem
extends Node


const dialogues = preload("res://localization/dialogue/dialogues.gd").dialogues
const dialogue_box_scene = preload("res://ui/dialogue_box/dialogue_box.tscn")


func process_dialogue_interaction(dialogue_interaction: DialogueInteraction):
	if not dialogues.has(dialogue_interaction.dialogue_id):
		return
	var dialogue_lines_ids = dialogues.get(dialogue_interaction.dialogue_id)

	var dialogue_lines: Array[String] = []
	for dialogue_line_id in dialogue_lines_ids:
		dialogue_lines.append(tr(dialogue_line_id))

	process_dialogue_lines(dialogue_lines)


func process_dialogue_lines(dialogue_lines: Array[String]):
	if not State.is_dialogue_box_shown:
		var dialogue_box = spawn_dialogue_box()
		dialogue_box.start_dialogue(dialogue_lines)
		await dialogue_box.dialogue_finished_showing
		kill_dialogue_box(dialogue_box)


func spawn_dialogue_box() -> DialogueBox:
	var dialogue_box = dialogue_box_scene.instantiate()
	add_child(dialogue_box)
	State.is_dialogue_box_shown = true
	return dialogue_box


func kill_dialogue_box(dialogue_box: DialogueBox):
	dialogue_box.queue_free()
	State.is_dialogue_box_shown = false
