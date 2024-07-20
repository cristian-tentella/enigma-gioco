class_name Minigame3ColorsCombination
extends Node
"""
Sei arrivato allo studio.

FLOW:
	Computer: Spento inizialmente. Cliccandoci si attiva una ColorRect che cicla tra [black, green, purple, cyan, red]
	Mobile 1 con cassetti: con le chiavi (MINIGIOCO CHIAVI, sequenza di 4 chiavi) trovi il PLUTONIO => AGGIUNTO PLUTONIO IN INVENTARIO


Obbiettivo: Ottenere PLUTONIO RADIOATTIVO


Step di attivazione minigame:
	- Prova a cliccare sul mobile che è bloccato (container con lock image) -> 
			Dialogo che dice che è bloccato
			Parte minigame senza loss scriptata
			Se clicca X, Dialogo che dice che dovrebbe guardarsi intorno
	- Clicca sul computer e a rotazione cambiano i colori, questa interazione resta SEMPRE up fino a fine game
	
	Niente, fa tentativi finché non riesce

"""

"""
SPIEGAZIONE NODI DELLA SCENA:
	
	first_dialogue_on_first_open -> dialogo che parte in funzione open_combination_lock_first_time(). 
			Daniel è stupito e non capisce se deve davvero mettere 3 chiavi li dentro (1,-1)
	
"""


"""
FLOW:
	Vinci: +current_minigame = 3

"""

"""
NODI NECESSARI PER FUNZIONAMENTO:
	
	Mobiletto dentro house.tscn (va cambiato house.gd e assegnazione di quel mobile al minigame manager).
		Quel mobiletto non ha minigame requirement
	plutonio_radioattivo dentro house.tscn (dentro studio)
	
"""
#Il gioco vero e proprio
var combination_color_lock_minigame


@onready var mobile_bloccato_dialogo: DialogueInteraction = $mobile_bloccato_dialogo
@onready var computer_color_rect: ColorRect = $Computer_color
@onready var computer_color_switcher: OnClickAnyInteraction = $Computer_color_switcher

@onready var game_won_dialogue: DialogueInteraction = $game_won_dialogue
@onready var game_lost_dialogue: DialogueInteraction = $game_lost_dialogue
@onready var after_plutonio_dialogue: DialogueInteraction = $after_plutonio_dialogue

#      					 ["black" ,  "green", "purple",  "cyan" ,  "red"  ]
const color2hex: Array = ["000000", "64AB3A", "914A9B", "2D7885", "A6443F"]
var current_color_index: int = 0

func _ready():
	self.combination_color_lock_minigame = UIManager.combination_color_key_minigame

func open_combination_color_lock_real():

	#Dialogo in cui dice che è bloccato
	mobile_bloccato_dialogo.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	#Ora mostra il minigame vero e proprio
	UIManager.show_combination_color_key_minigame()

	#Fai vedere nel minigame il pulsante per uscire
	self.combination_color_lock_minigame.exit_button.show()
	await UIManager.unlock
	
	if combination_color_lock_minigame.is_won == true:
		self.game_won_dialogue.handle_interaction()
		await DialogueManager.has_finished_displaying
		self.after_plutonio_dialogue.handle_interaction()
		await DialogueManager.has_finished_displaying
		self._free_every_node_related_to_the_minigame()
		StateManager.inventory.insert(MinigameManager.plutonio_radioattivo)
		await DialogueManager.has_finished_displaying
	else:
		self.game_lost_dialogue.handle_interaction()
		await DialogueManager.has_finished_displaying
		

#Questo è solo per dare hint
func rotate_computer_color():
	AudioManager.play_keyboard_sound_effect()
	await get_tree().create_timer(1).timeout
	current_color_index = (current_color_index+1) % 5
	computer_color_rect.color = Color(color2hex[current_color_index])
	AudioManager.play_pew_sound_effect()


#Gioco vinto, adios!
func _free_every_node_related_to_the_minigame():
	
	UIManager.combination_color_key_minigame.queue_free()
	UIManager.combination_color_key_minigame = null
	self.queue_free()
