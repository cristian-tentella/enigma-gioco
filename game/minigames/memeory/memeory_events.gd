extends Node

@onready var memeory_first_dialogue = $memeory_first_dialogue
@onready var memeory_launcher = $memeory_launcher
@onready var memeory_retry = $memeory_retry
@onready var memeory_win = $memeory_win
@onready var memeory_win_after_polipetto = $memeory_win_after_polipetto
@onready var memeory_lost = $memeory_lost


func memeory_start_dialogues():
	
	#Dialogo iniziale
	if memeory_first_dialogue != null:
		#StateManager.current_minigame += 1
		memeory_first_dialogue.handle_interaction()
		await DialogueManager.has_finished_displaying
		memeory_first_dialogue.queue_free()
	else:
		memeory_retry.handle_interaction()
		await DialogueManager.has_finished_displaying
	
	#Mostra e gioca al minigame
	MemeoryManager.start_game()
	UIManager.show_memeory()
	await UIManager.unlock
	
	#Mostra il dopo se vinto o perso
	if MemeoryManager.game_won:
		memeory_win.handle_interaction()
		await DialogueManager.has_finished_displaying
		
		StateManager.inventory.insert(MinigameManager.polipetto)
		await DialogueManager.has_finished_displaying
		
		memeory_win_after_polipetto.handle_interaction()
		await DialogueManager.has_finished_displaying
		#================================ Goodbye minigame!
		self._free_every_node_related_to_the_minigame()
		#================================
	else:
		memeory_lost.handle_interaction()
		await DialogueManager.has_finished_displaying
		return

#Gioco vinto, adios!
func _free_every_node_related_to_the_minigame():
	memeory_retry.queue_free()
	memeory_retry = null
	UIManager.memeory_menu.queue_free()
	UIManager.memeory_menu = null
	self.queue_free()

func _exit_tree():
	print_debug(get_name()+" MINIGAME exiting!\n")
	pass
	
func _ready():
	print_debug(get_name()+" MINIGAME spawning!\n")
	pass
