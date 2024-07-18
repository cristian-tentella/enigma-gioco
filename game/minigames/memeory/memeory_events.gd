extends Node

@onready var memeory_first_dialogue = $memeory_first_dialogue
@onready var memeory_launcher = $memeory_launcher
@onready var memeory_retry = $memeory_retry
@onready var memeory_win = $memeory_win

var memeory

func _ready():
	#memeory = UIManager.memeory_menu
	pass
	
func memeory_start_dialogues():
	
	if StateManager.current_minigame==4:
		StateManager.current_minigame += 1
		memeory_first_dialogue.handle_interaction()
		await DialogueManager.has_finished_displaying
		memeory_first_dialogue.queue_free()
	
	if StateManager.current_minigame==6:
		memeory_retry.handle_interaction()
		await DialogueManager.has_finished_displaying
	
	MemeoryManager.start_game()
	UIManager.show_memeory()
	await UIManager.unlock
	
	if StateManager.current_minigame==7:
		memeory_win.handle_interaction()
		await DialogueManager.has_finished_displaying
		#================================ Goodbye minigame!
		self._free_every_node_related_to_the_minigame()
		#================================

#Gioco vinto, adios!
func _free_every_node_related_to_the_minigame():
	memeory_retry.queue_free()
	memeory_retry = null
	memeory_win.queue_free()
	memeory_win = null
	UIManager.memeory_menu.queue_free()
	UIManager.memeory_menu = null
	self.queue_free()
