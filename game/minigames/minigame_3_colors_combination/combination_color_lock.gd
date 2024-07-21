class_name CombinationColorLock
extends Control

@onready var exit_button = $CloseButtonBackground #Serve per nascondere il pulsante per quittare al primo start, quello scriptato che fallisce subito

@onready var slot_digit1 = $digits_container/digit1
@onready var slot_digit2 = $digits_container/digit2
@onready var slot_digit3 = $digits_container/digit3
@onready var slot_digit4 = $digits_container/digit4

var current_slot = 1
# [ "green", "purple",  "cyan" ,  "red"  ]
var real_combination = "6241"
var current_combination = ""

var is_won = false

signal exit

func _insert_into_next_slot(key_number: String):
	#Se mettono troppe chiavi o spamcliccano una chiave, just do nothing...
	if current_slot == 5 or key_number in current_combination:
		return
	
	AudioManager.play_key_turning_sound_effect()
	
	match current_slot:
		1:
			slot_digit1.text = key_number
		2:
			slot_digit2.text = key_number
		3:
			slot_digit3.text = key_number
		4:
			slot_digit4.text = key_number
	
	current_combination += key_number
	
	#Fai controllo sulla combinazione
	check_combination()
	
	current_slot += 1

func check_combination():
	if len(current_combination) == 4:
		
		if current_combination == real_combination:
			await get_tree().create_timer(0.7).timeout
			AudioManager.play_success_sound_effect()
			print_debug("Heya! Nice, you got it!")
			StateManager.current_minigame += 3
			self.is_won = true
			self.exit.emit()
			return
	
		await get_tree().create_timer(0.7).timeout
		AudioManager.play_failure_sound_effect()
		
		_on_reset_minigame_button_pressed() #Non ci ho azzeccato :(
		return

# Called when the node enters the scene tree for the first time.
func _on_reset_minigame_button_pressed():
	slot_digit1.text = "0"
	slot_digit2.text = "0"
	slot_digit3.text = "0"
	slot_digit4.text = "0"
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

