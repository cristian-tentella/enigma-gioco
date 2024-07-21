class_name Minigame4RiparaSpadaLaser
extends Node
"""
PARLA PRIMA CON IMMONDIZIA (current_minigame = 11 (+1)) E POI PUO' INTERAGIRE CON LA SPADA

FLOW:
	Clicco sulla spada laser dopo essere stato invogliato a farlo, guardando la spazzatura davanti la scala
	Dialogo che dice che questa spada laser non funziona ma c'è un vano in cui posso inserire un oggetto
	Apre UI inventario per selezionare oggetto da provarci a inserire
	La parte a dx dell'inventario si aggiorna in funzione di cosa premo, finché non premo sul plutonio radioattivo

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
	Parli con immondizia prima volta: current_minigame += 1 (11)
	Vinci: current_minigame = 15
	Rompi Immondizia: current_minigame += 1 (16)

"""

"""
NODI NECESSARI PER FUNZIONAMENTO:
	
	Mobiletto dentro house.tscn (va cambiato house.gd e assegnazione di quel mobile al minigame manager).
		Quel mobiletto non ha minigame requirement
	plutonio_radioattivo dentro house.tscn (dentro studio)
	
"""
@onready var dialogo_monnezza: DialogueInteraction = $dialogo_monnezza
@onready var dialogo_monnezza_persistente: DialogueInteraction = $dialogo_monnezza_uguale
@onready var primo_dialogo_appena_clicco_su_spada: DialogueInteraction = $click_spada_laser_dialogo_minigame4
@onready var dialogo_al_reclick: DialogueInteraction = $click_spada_laser_dialogo_finale
@onready var game_won_dialogue: DialogueInteraction = $game_won_dialogue
@onready var game_lost_dialogue: DialogueInteraction = $game_lost_dialogue
@onready var game_starter: OnClickAnyInteraction = $game_starter

@onready var brucia_immondizia_dialogo_inizio: DialogueInteraction = $interazione_con_immondizia/brucia_immondizia_dialogo_inizio
@onready var brucia_immondizia_dialogo_fine: DialogueInteraction = $interazione_con_immondizia/brucia_immondizia_dialogo_fine
var is_won: bool = false

func launch_minigame():
	UIManager.inventory_menu.inventory_slot_pressed.connect(_on_inventory_slot_pressed)
	#Dialogo in cui vede la spada per la prima volta
	if primo_dialogo_appena_clicco_su_spada != null:
		self.primo_dialogo_appena_clicco_su_spada.handle_interaction()
		await DialogueManager.has_finished_displaying
	
	#Dialogo in cui dice che la spada ha spazio per ficcarci qualcosa, è quello che parte quando ci riclicca
	self.dialogo_al_reclick.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	#Ora mostra inventario e sfrutta il click dei pulsanti per modificare la UI
	UIManager.show_inventory_for_minigame4()
	
	await UIManager.unlock #Si sblocca sia se azzecca sia se quitta
	
	if is_won:
		self.game_starter.queue_free()
		self.game_won_dialogue.handle_interaction()
		await DialogueManager.has_finished_displaying
		$LightSaber.hide()
		StateManager.inventory.insert(MinigameManager.spada_laser)
		StateManager.inventory.remove("polipetto")
		StateManager.inventory.remove("plutonio_radioattivo")
		await DialogueManager.has_finished_displaying
		StateManager.current_minigame = 15
	else:
		AudioManager.play_failure_sound_effect()
		self.game_lost_dialogue.handle_interaction()
		await DialogueManager.has_finished_displaying


func _on_inventory_slot_pressed(item: PickableItem):
	if is_won:
		return
	if item.item_name != "plutonio_radioattivo":
		UIManager.inventory_menu.change_description(DialogueManager._item_description_id_to_item_description("wrong_item_selected_minigame4"))
		AudioManager.play_failure_sound_effect()
	else:
		self.is_won = true
		AudioManager.play_success_sound_effect()
		UIManager.inventory_menu.exit.emit() #Questo emette UIManager.unlock



#Gioco vinto, adios!
func _free_every_node_related_to_the_minigame():
	self.queue_free()


@onready var monnezza: Sprite2D = $monnezza
@onready var fire_particles: CPUParticles2D = $FireParticles

func launch_brucia_cumulo_immondizia_interazione():
	self.brucia_immondizia_dialogo_inizio.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	AudioManager.play_light_saber_sound_effect()

	var ash: Sprite2D = StateManager.house.get_node("Ash")
	ash.show()

	var monnezza_fade_out = create_tween()
	monnezza_fade_out.tween_property(self.monnezza, "modulate", Color.hex(0x00000000), 1)

	self.fire_particles.emitting = true
	await monnezza_fade_out.finished

	var ash_fade_in = create_tween()
	ash_fade_in.tween_property(ash, "modulate", Color.hex(0xffffffff), 0.25)
	await ash_fade_in.finished
	self.fire_particles.emitting = false
	self.monnezza.queue_free()

	self.brucia_immondizia_dialogo_fine.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	self._free_every_node_related_to_the_minigame()
