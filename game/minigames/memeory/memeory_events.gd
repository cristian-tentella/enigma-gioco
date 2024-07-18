extends Node

@onready var memeory_first_dialogue = $memeory_first_dialogue
@onready var memeory_launcher = $memeory_launcher

var memeory

func _ready():
	memeory = UIManager.memeory_menu
	
func memeory_start_dialogues():
	memeory_first_dialogue.handle_interaction()
	await DialogueManager.has_finished_displaying
	MemeoryManager.start_game()
	UIManager.show_memeory()
	await UIManager.unlock
