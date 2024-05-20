extends Node


@onready var ui = get_node("/root/Game/UI")

@onready var dialogue_box: DialogueBox = preload(
	"res://ui/dialogue_box/dialogue_box.tscn"
).instantiate()
@onready var start_menu: StartMenu = preload(
	"res://ui/start_menu/start_menu.tscn"
).instantiate()
@onready var pause_menu: PauseMenu = preload(
	"res://ui/pause_menu/pause_menu.tscn"
).instantiate()

@onready var ui_elements: Array[Control] = [
	dialogue_box,
	start_menu,
	pause_menu,
]


signal spawn(ui_element: Control)
signal kill(ui_element: Control)

signal lock
signal unlock


func _ready():
	for ui_element in ui_elements:
		ui_element.hide()
		ui.add_child(ui_element)


func _spawn_ui_element(ui_element: Control):
	ui_element.show()
	spawn.emit(ui_element)
	return ui_element


func _kill_ui_element(ui_element: Control):
	ui_element.hide()
	kill.emit(ui_element)


func _spawn_locking_ui_element(ui_element: Control):
	_spawn_ui_element(ui_element)
	lock.emit()


func _kil_locking_ui_element(ui_element: Control):
	_kill_ui_element(ui_element)
	unlock.emit()


func show_dialogue_box(dialogue_lines: Array):
	_spawn_locking_ui_element(dialogue_box)
	dialogue_box.start_dialogue(dialogue_lines)
	await DialogueManager.has_finished_displaying
	_kil_locking_ui_element(dialogue_box)


func show_start_menu():
	_spawn_locking_ui_element(start_menu)
	await start_menu.exit
	_kil_locking_ui_element(start_menu)


func show_pause_menu():
	_spawn_locking_ui_element(pause_menu)
	await pause_menu.exit
	_kil_locking_ui_element(pause_menu)
