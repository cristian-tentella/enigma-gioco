"""
UIManager

Gestisce tutto ciò che ha a che fare con l'interfaccia utente.
"""

extends Node

"""################################################################################
PRELOAD DI TUTTE LE SCENE RIGUARDANTI OGNI SINGOLO POSSIBILE CAMBIAMENTO DI UI
################################################################################"""
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

"""################################################################################
QUANDO AGGIUNGO UN ELEMENTO UI QUI SOPRA, TRA I @onready, VA MESSO ANCHE QUI DENTRO PER L'INIZIALIZZAZIONE DEI NODI FIGLI
################################################################################"""
@onready var ui_elements: Array[Control] = [
	dialogue_box,
	start_menu,
	pause_menu,
]

#Segnali
signal spawn(ui_element: Control) #Segnale per mettere in sovrimpressione un elemento UI
signal kill(ui_element: Control) #Segnale per nascondere un elemento UI

#Le functioni associate a questi due segnali sono definite in managers/state.gd
signal lock 
"""
LOCK:
	func():
		player_can_move.emit(false)
		self.should_player_be_able_to_move = false
	"""
signal unlock
"""
UNLOCK:
	func():
		player_can_move.emit(true)
		self.should_player_be_able_to_move = true
"""

#Inizializza come nodi figli di Control tutti gli elementi UI prima elencati, per una veloce selezione in runtime
func _ready():
	for ui_element in ui_elements:
		ui_element.hide()
		ui.add_child(ui_element)

#Mostra un elemento di UI.
func _spawn_ui_element(ui_element: Control):
	ui_element.show() #Era già nello scene tree, e ora lo mostri
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