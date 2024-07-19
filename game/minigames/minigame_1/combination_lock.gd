class_name CombinationLock
extends Control

@onready var exit_button = $CloseButtonBackground #Serve per nascondere il pulsante per quittare al primo start, quello scriptato che fallisce subito

@onready var slot_digit1 = $digits_container/digit1
@onready var slot_digit2 = $digits_container/digit2
@onready var slot_digit3 = $digits_container/digit3

var current_slot = 1
var real_combination = "314"
var current_combination = ""

signal exit

func _insert_into_next_slot(key_number: String):
	#Se mettono troppe chiavi o spamcliccano una chiave, just do nothing...
	if current_slot == 4 or key_number in current_combination:
		return
	
	match current_slot:
		1:
			slot_digit1.text = key_number
		2:
			slot_digit2.text = key_number
		3:
			slot_digit3.text = key_number
	
	current_combination += key_number
	
	if len(current_combination) == 3:
		
		#Qua pure se ha azzeccato, se è la prima volta, perde a prescindere
		#Bruh se cheattano o sculano non è colpa mia... Non mi va di gestirlo :D
		if StateManager.current_minigame == 1: #Sinonimo di "è la prima volta che provo"
			StateManager.current_minigame += 1
			self.exit.emit()
			_on_reset_minigame_button_pressed()
			return
		
		if current_combination == real_combination:
			print_debug("Heya! Nice, you got it!")
			StateManager.current_minigame += 1
			MinigameManager.porta_camera_da_letto.try_to_unlock()
			MinigameManager.porta_camera_da_letto = null
			self.exit.emit()
			return
		
		_on_reset_minigame_button_pressed() #Non ci ho azzeccato e non è la prima volta
		return
	
	current_slot += 1


# Called when the node enters the scene tree for the first time.
func _on_reset_minigame_button_pressed():
	slot_digit1.text = "0"
	slot_digit2.text = "0"
	slot_digit3.text = "0"
	current_combination = ""
	current_slot = 1


func _on_key_1_pressed():
	_insert_into_next_slot("1")


func _on_key_2_pressed():
	_insert_into_next_slot("2")


func _on_key_3_pressed():
	_insert_into_next_slot("3")


func _on_key_4_pressed():
	_insert_into_next_slot("4")


func _on_key_5_pressed():
	_insert_into_next_slot("5")


func _on_key_6_pressed():
	_insert_into_next_slot("6")
	
	
func _on_key_7_pressed():
	_insert_into_next_slot("7")


func _on_exit_pause_menu_button_pressed():
	_on_reset_minigame_button_pressed()
	self.exit.emit()
