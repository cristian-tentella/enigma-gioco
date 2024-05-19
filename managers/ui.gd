extends Node


@onready var ui = get_node("/root/Game/UI")

@onready var dialogue_box_scene = preload("res://ui/dialogue_box/dialogue_box.tscn")


signal spawn(ui_element: Control)
signal kill(ui_element: Control)

signal lock
signal unlock


func _spawn_ui_element(ui_element: Control) -> Control:
	ui.add_child(ui_element)
	spawn.emit(ui_element)
	return ui_element


func _kill_ui_element(ui_element: Control):
	ui_element.queue_free()
	kill.emit(ui_element)


func show_dialogue_box(dialogue_lines: Array):
	var dialogue_box: DialogueBox = _spawn_ui_element(
		dialogue_box_scene.instantiate()
	)
	lock.emit()

	dialogue_box.start_dialogue(dialogue_lines)
	await DialogueManager.has_finished_displaying

	unlock.emit()
	_kill_ui_element(dialogue_box)
