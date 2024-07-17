extends Node

@onready var memeory_first_dialogue = $memeory_first_dialogue
@onready var memeory_launcher = $memeory_launcher

var memeory
#var memui = MemeoryUI.new()
#var mem = Mem

func _ready():
	memeory = UIManager.memeory_menu
	
func memeory_start_dialogues():
	memeory_first_dialogue.handle_interaction()
	await DialogueManager.has_finished_displaying
	print_debug("ciaoooo")
	#MemeoryManager.isStarted = true
	MemeoryManager.start_game()
	await 0.2
	UIManager.show_memeory()
	await UIManager.unlock
