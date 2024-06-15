"""
StateManager

Classe che gestisce lo stato del gioco. 
Qui sono incluse tutte le variabili booleane tipo "stai fermo", o comunque tutto quello che altera il processo di gioco.
"""

extends Node

"""######################################################################################
Qui ci sono le variabili degli OGGETTI che possono cambiare stato durante la partita.
######################################################################################"""
#Generalmente, vengono messe dentro una delle scene e caricate qui dentro dalla radice della scena
var player: Player #Caricato da game/game.gd, lanciato in game/game.tscn
var house: House #Caricato da game/game.gd, lanciato in game/game.tscn

#Inventory variables
var inventory_UI: InventoryUI
var inventory: Inventory

"""######################################################################################
Qui ci sono le VARIABILI che riguardano la GESTIONE DEI COMPORTAMENTI in base a specifiche circostanze della partita.
######################################################################################"""
var is_a_dialogue_in_progress = false #Variabile che gestisce se un dialogo è ongoing
var should_player_be_able_to_move = true #Variable che gestisce se il giocatore dovrebbe stare fermo (gli input di movimento non sortiscono effetto)

"""######################################################################################
Qui ci sono i SEGNALI che riguardano la GESTIONE DEI COMPORTAMENTI in base a specifiche circostanze della partita.
######################################################################################"""
signal player_can_move(player_can_move: bool)

#Invocato grazie all'AUTOLOAD dello script.
#Si, non c'è nessun nodo visibile, l'autoload crea un nodo nella root di game.tscn, deal with it.
func _ready():
	
	UIManager.lock.connect(
		func():
			player_can_move.emit(false)
			self.should_player_be_able_to_move = false
	)
	UIManager.unlock.connect(
		func():
			player_can_move.emit(true)
			self.should_player_be_able_to_move = true
	)

	DialogueManager.has_started_displaying.connect(
		func():
			self.is_a_dialogue_in_progress = true
	)
	DialogueManager.has_finished_displaying.connect(
		func():
			self.is_a_dialogue_in_progress = false
	)
