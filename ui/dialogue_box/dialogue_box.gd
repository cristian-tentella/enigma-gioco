class_name DialogueBox
extends Control


@onready var title_label = $PanelContainer/MarginContainer/VBoxContainer/Title
@onready var body_label = $PanelContainer/MarginContainer/VBoxContainer/Body


signal skip_dialogue_line()
signal dialogue_finished_showing()


func start_dialogue(dialogue_lines: Array[String]):
	for dialogue_line in dialogue_lines:
		_process_dialogue_line(dialogue_line)
		await skip_dialogue_line

	dialogue_finished_showing.emit()


func _process_dialogue_line(dialogue_line: String):
	const title_delimiter = ":"

	if dialogue_line.contains(title_delimiter):
		var title_delimiter_index = dialogue_line.find(title_delimiter)
		var title_text: String = dialogue_line.substr(0, title_delimiter_index).rstrip(" ")
		var body_text: String = dialogue_line.substr(title_delimiter_index + 1).lstrip(" ")

		title_label.show()
		title_label.text = title_text
		body_label.text = body_text
	else:
		title_label.hide()
		body_label.text = dialogue_line


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("interact"):
		skip_dialogue_line.emit()
