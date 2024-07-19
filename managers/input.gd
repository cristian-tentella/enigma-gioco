"""
InputManager

Classe che gestisce i tipi di input dell'utente e i comportamenti associati.
Il metodo _input() può essere usato solo qui, pena la morte per cattiva gestione di responsabilità e accoppiamento altrimenti.
"""
extends Node

#Associazione delle variabili che uso nel codice alle relative stringhe dentro Mappa Input di Godot
const MOVE_UP = "move_up" #Dentro Mappa Input, al concetto di "vai verso l'alto" è associata la stringa "move_up"
const MOVE_DOWN = "move_down"
const MOVE_RIGHT = "move_right"
const MOVE_LEFT = "move_left"
const INTERACT = "interact"
const PAUSE = "pause"
const INVENTORY = "inv"
var joystick: VirtualJoystick

#Lista di tutti i possibili movimenti che il Player può effettuare. 
#NOTE: Ognuno di questi è stato prima mappato alla sua stringa, il cui nome è LO STESSO della Mappa Input di Godot
const MOVEMENT_ACTIONS = [
	MOVE_UP,
	MOVE_DOWN,
	MOVE_RIGHT,
	MOVE_LEFT,
]

#################################################################################
"""
Elenco dei segnali legati all'InputManager.
NOTE: Aggiungere al bisogno! (facendo attenzione a non sovrascrivere qualche segnale pre-esistente)
"""
signal movement_action_pressed(movement_action: String) #Segnale associato alla pressione di un tasto per muoversi
signal movement_action_released(movement_action: String) #Segnale associato al rilascio di un tasto per muoversi

signal advance_dialogue  #Segnale per avanzare nei dialoghi
#################################################################################

var last_x = 0
var last_y = 0

#Metodo di Godot. 
#For better understanding, _input(e : InputEvent) cattura TUTTI i segnali di input, e chiama OGNI metodo _input() di OGNI classe con quel parametro.
#Noi useremo esclusivamente questa classe per questa metodo, sarebbe meglio, per disaccoppiamento, evitare altre chiamate a _input() in giro per il codice.
func _input(input_event: InputEvent):
	if StateManager.should_player_be_able_to_move: 
		_process_player_input_event(input_event) #Banalmente, se posso muovermi, chiama il metodo per muovermi
	else:
		_process_ui_input_event(input_event)

func _process(delta):
	if PlatformHelper.get_current_platform() == PlatformHelper.Platform.MOBILE:
		var x = joystick.get_value().x
		var y = joystick.get_value().y
		const JOYSTICK_TRESHOLD = 0.6

		if y < -JOYSTICK_TRESHOLD and last_y >= -JOYSTICK_TRESHOLD:
			movement_action_pressed.emit(MOVE_UP)
		elif y >= -JOYSTICK_TRESHOLD and last_y < JOYSTICK_TRESHOLD:
			movement_action_released.emit(MOVE_UP)
		if x > JOYSTICK_TRESHOLD and last_x <= JOYSTICK_TRESHOLD:
			movement_action_pressed.emit(MOVE_RIGHT)
		elif x <= JOYSTICK_TRESHOLD and last_x > JOYSTICK_TRESHOLD:
			movement_action_released.emit(MOVE_RIGHT)
		
		if y > JOYSTICK_TRESHOLD and last_y <= JOYSTICK_TRESHOLD:
			movement_action_pressed.emit(MOVE_DOWN)
		elif y <= JOYSTICK_TRESHOLD and last_y > JOYSTICK_TRESHOLD:
			movement_action_released.emit(MOVE_DOWN)
		
		if x < -JOYSTICK_TRESHOLD and last_x >= -JOYSTICK_TRESHOLD:
			movement_action_pressed.emit(MOVE_LEFT)
		elif x >= -JOYSTICK_TRESHOLD and last_x < -JOYSTICK_TRESHOLD:
			movement_action_released.emit(MOVE_LEFT)

		last_x = x
		last_y = y



#Metodo chiamato se il Player può muoversi, per gestire il movimento
func _process_player_input_event(input_event: InputEvent):

	#input_event.is_action_pressed(string) va nell'input map, prende il tasto relativo a "string" nei bind,
	#vede poi se è stato premuto (o rilasciato) il tasto relativo a quella determinata stringa.
	#Per esempio, se premo W, movement_action sarà MOVE_UP (Guardando nella Input Map), quindi iterando sulla lista di possibili movimenti, quando sta su
	#MOVE_UP, esegue il primo IF
	for movement_action in MOVEMENT_ACTIONS:
		if input_event.is_action_pressed(movement_action):
			movement_action_pressed.emit(movement_action)
		if input_event.is_action_released(movement_action):
			movement_action_released.emit(movement_action)
	
	#Gestione del tasto di interazione con oggetti
	if input_event.is_action_pressed(INTERACT):
		StateManager.player.interaction_detector.activate_closest_interaction()
	
	#Gestione del tasto di pausa del gioco
	if input_event.is_action_pressed(PAUSE):
		UIManager.show_pause_menu()
	
	if input_event.is_action_pressed(INVENTORY):
		UIManager.show_inventory()
		
	


#Se non posso muovermi, ho premuto il tasto per fare qualcos'altro. 
#Qui gestisco quella casistica, ad esempio, se sono in un dialogo, qualsiasi tasto premuto mi va avanti nel dialogo.
func _process_ui_input_event(input_event: InputEvent):
	if StateManager.is_a_dialogue_in_progress:
		if input_event.is_action_pressed(INTERACT):
			self.advance_dialogue.emit()
