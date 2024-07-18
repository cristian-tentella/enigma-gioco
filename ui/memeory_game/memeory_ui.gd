class_name MemeoryUI
extends Control

#var MemeoryManager: Memeory
@onready var slots_UI: Array = $SlotsGridBackground/CenterContainer/GridContainer.get_children() #Array di Memeory_UI_Slot
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi
var i = 0
@onready var heart_UI: Array = $Hearts.get_children()

signal exit


func _ready():
	$Deck.hide()
	#_instantiate_MemeoryManagereory()
	MemeoryManager.gamelost.connect(game_lost)
	MemeoryManager.start.connect(start_new_game)
	MemeoryManager.updatehearts.connect(update_hearts)
	MemeoryManager.update.connect(update_slots)
	update_slots()
	#update_hearts()

	
func _draw_random_card():  
	MemeoryManager.slots.clear()
	i = 0
	var card_container = $Deck
	var cards = card_container.get_children()
	if cards.size() == 0:
		return
	cards.shuffle()
	for random_card in cards:
		random_card.index = i
		MemeoryManager.insert(random_card)
		i = i+1
	#print_debug(MemeoryManager.slots)
	
func start_new_game(): 
	MemeoryManager.hearts_array.clear()
	MemeoryManager.clicks = 0
	heart_UI = $Hearts.get_children()
	print_debug(heart_UI)
	$LineEdit.hide()
	for i in heart_UI:
		MemeoryManager.insert_heart(i)
		i.beating_animation()
	MemeoryManager.update_hearts()
	_draw_random_card()
	MemeoryManager.cover_all_cards()

#func _instantiate_MemeoryManagereory():
	#MemeoryManager = MemeoryManager
	
func update_slots():
	#print_debug(range(min(MemeoryManager.slots.size(), slots_UI.size())))
	for i in range(min(MemeoryManager.slots.size(), slots_UI.size())):
		#print_debug(slots_UI[i])
		slots_UI[i].update(MemeoryManager.slots[i])
		
func update_hearts():
	#print_debug(heart_UI.size())
	#print_debug(MemeoryManager.hearts_array)
	for k in range(min(MemeoryManager.hearts_array.size(),heart_UI.size())):
		#print_debug(heart_UI[k])
		heart_UI[k].updateheart(MemeoryManager.hearts_array[k])
		
func game_lost():
	$LineEdit.show()

func _on_exit_pause_menu_button_pressed():
	MemeoryManager.clear_slots()
	self.exit.emit() # Replace with function body.

