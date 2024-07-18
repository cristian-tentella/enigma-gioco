extends Node

@onready var memeory_first_dialogue = $memeory_first_dialogue
@onready var memeory_launcher = $memeory_launcher
@onready var memeory_second_chance = $memeory_second_chance
@onready var memeory_win = $memeory_win

var memeory

func _ready():
	#memeory = UIManager.memeory_menu
	pass
	
func memeory_start_dialogues():
	StateManager.current_minigame += 1 #next_step
	if StateManager.current_minigame==5:
		memeory_first_dialogue.handle_interaction()
		await DialogueManager.has_finished_displaying
	if StateManager.current_minigame==6:
		memeory_second_chance.handle_interaction()
		await DialogueManager.has_finished_displaying
	if StateManager.current_minigame==7:
		memeory_win.handle_interaction()
		await DialogueManager.has_finished_displaying
	MemeoryManager.start_game()
	UIManager.show_memeory()
	await UIManager.unlock
