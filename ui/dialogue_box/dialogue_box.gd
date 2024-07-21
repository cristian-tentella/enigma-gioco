class_name DialogueBox
extends Control


const DIALOGUE_WITH_SOUND_EFFECT_PREFIX = "sound_effect_"


func start_dialogue(dialogue_lines: Array):
	DialogueManager.has_started_displaying.emit()

	for dialogue_line in dialogue_lines:
		_process_dialogue_line(dialogue_line)
		await InputManager.advance_dialogue

	DialogueManager.has_finished_displaying.emit()


func _process_dialogue_line(dialogue_line: String):
	const title_delimiter = ":"
	
	var title: Label = $PanelContainer/MarginContainer/VBoxContainer/Title
	var body: Label = $PanelContainer/MarginContainer/VBoxContainer/Body

	body.visible_characters = 0

	if dialogue_line.contains(title_delimiter):
		title.show()
		var title_delimiter_index = dialogue_line.find(title_delimiter)

		var title_text = dialogue_line.substr(0, title_delimiter_index).rstrip(" ")
		var body_text = dialogue_line.substr(title_delimiter_index + 1).lstrip(" ")

		if title_text.begins_with(DIALOGUE_WITH_SOUND_EFFECT_PREFIX):
			var sound_effect_name = title_text.erase(0, DIALOGUE_WITH_SOUND_EFFECT_PREFIX.length())
			title.hide()
			body_text = "*" + body_text + "*"
			AudioManager.play_sound_effect.emit(sound_effect_name)

		title.text = title_text
		body.text = body_text
	else:
		title.hide()
		body.text = dialogue_line

	for i in body.text.length():
		body.visible_characters += 1
		AudioManager.play_dialogue_ploop_sound_effect()
		await get_tree().create_timer(0.015).timeout


func _on_touch_screen_button_pressed():
	InputManager.advance_dialogue.emit()
