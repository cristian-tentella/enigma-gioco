class_name Minigame1 #SI CONSIDERA SUPERATO CON current_minigame = 3
extends Node

"""
Sei spawnato nella camera da letto, quindi ti trovi già li.

Obbiettivo: Aprire porta camera da letto

Stanze Accessibili: Camera da Letto, Balcone

Oggetti che servono:
	set_of_keys (aprire camera da letto)

Step di attivazione minigame:
	- Trovate set_of_keys sotto lo sdraio in balcone
	- Provare ad aprire camera da letto con quelle chiavi 
	  (nessuna funziona)
	- Minigame inizia con beccare la combo di tre chiavi giuste.
	  Magari dopo il primo tentativo sbagliato si locka il minigame
	  e dice tipo "dovrei guardare in giro, magari c'è qualche indizio"

Step di risoluzione minigame:
	- Interazione col poster col pi greco
	- Torna alla porta e ora il minigame funziona e può fare tentativi

"""

"""
SPIEGAZIONE NODI DELLA SCENA:
	
	first_dialogue_on_first_open -> dialogo che parte in funzione open_combination_lock_first_time(). 
			Daniel è stupito e non capisce se deve davvero mettere 3 chiavi li dentro (1,-1)
			
	second_dialogue_on_first_open -> dialogo che parte in funzione open_combination_lock_first_time(). 
			Daniel ha fatto un tentativo e dice che deve guardarsi in giro (1,-1)
	
	first_click_on_door_after_keys_taken -> AnyClickInteraction che lancia open_combination_lock_first_time(). (1, -1)
			- Messa 1 vicina allo user rispetto alla porta
	
	second_dialogue_on_first_open_static_until_poster -> questo dialogo sta fermo sulla porta, quando provi ad aprirla dopo aver fallito il
			primo tentativo al minigame ma non hai ancora interagito col poster (2,3)
			- Messa 2 vicina allo user rispetto alla porta
			
	dialogue_with_pi_poster -> interazione col poster per avanzare nel gioco. (2,4) Qui il 5 serve perché indica quando sei riuscito ad aprire la porta.
			Da quel momento in poi, non ti serve più interagire con questo poster!
			
	actual_minigame_combination_first_dialogue -> appena clicco per giocare al minigame, fa un mini dialogo per incitare (3,4)
	
	actual_minigame_launcher -> AnyClickInteraction che lancia open_combination_lock_real(), quindi il vero minigame
	
	combination_minigame_won -> hai vinto, dialogo, gg (4, -1)
	
	door_locked_basic_dialogue -> è bloccata ma non hai ancora trovato le chiavi (0, 1)
"""


"""
FLOW:
	Prende il mazzo di chiavi: +current_minigame = 1
	Cerca di aprire la porta e fallisce: +current_minigame = 2
	Interagisce col poster: +current_minigame = 3
	Vinci: +current_minigame = 4

"""

"""
NODI NECESSARI PER FUNZIONAMENTO:
	
	Porta camera da letto dentro house.tscn (va cambiato house.gd e assegnazione di quella porta al minigame manager).
		Quella porta ha minigame requirement 4
	set_of_keys dentro house.tscn
	
"""

#Il gioco vero e proprio
var combination_lock_minigame

"""
VARIABILI PER PRIMO AVVIO DEL GIOCO
"""
#Dialogo iniziale in cui Daniel è stunnato e non capisce che cavolo sono quelle tre serrature
@onready var first_dialogue_on_first_open: DialogueInteraction = $first_dialogue_on_first_open
#Il gioco vero e proprio ora parte per un solo tentativo
#Dialogo dopo che ha fallito quell'unico tentativo, in cui dice che deve guardarsi in giro
@onready var second_dialogue_on_first_open: DialogueInteraction = $second_dialogue_on_first_open

"""
VARIABILI PER IL GIOCO VERO E PROPRIO
"""
#Dialogo di incitazione quando provi a giocare
@onready var actual_minigame_combination_first_dialogue = $actual_minigame_combination_first_dialogue
#Dialogo di vittoria
@onready var combination_minigame_won = $combination_minigame_won

func _ready():
	combination_lock_minigame = UIManager.combination_key_minigame


func open_combination_lock_first_time(): 
	#Nascondi pulsante per quittare, why would they?
	self.combination_lock_minigame.exit_button.hide()
	
	#Fai vedere il primo dialogo prima che si apra il menu
	first_dialogue_on_first_open.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	#Ora mostra il minigame scriptato per fallire al primo tentativo, anche se è giusto (tired, non lo azzeccano subito dai...)
	UIManager.show_combination_key_minigame()
	await UIManager.unlock
	
	#Fai vedere la frustrazione di Daniel dopo aver fallito e dice che deve guardarsi in giro
	second_dialogue_on_first_open.handle_interaction()
	await DialogueManager.has_finished_displaying
	
func open_combination_lock_real():

	#Fai vedere il dialogo prima che si apra il menu in cui si incita
	actual_minigame_combination_first_dialogue.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	#Ora mostra il minigame vero e proprio
	UIManager.show_combination_key_minigame()
	#Fai vedere nel minigame il pulsante per uscire
	self.combination_lock_minigame.exit_button.show()
	await UIManager.unlock
	
	if StateManager.current_minigame == 4: #Quindi se ho vinto il primo minigame, che si vince in 4 steps
	#Se ha workato, fai vedere che è felice che ha vinto, altrimenti esci senza nessun dialogo (seems fair per gameplay)
		combination_minigame_won.handle_interaction()
		self._free_every_node_related_to_the_minigame()
		await DialogueManager.has_finished_displaying

#Gioco vinto, adios!
func _free_every_node_related_to_the_minigame():
	UIManager.combination_key_minigame.queue_free()
	UIManager.combination_key_minigame = null
	self.queue_free()
