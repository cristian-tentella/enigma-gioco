class_name MemeoryUI
extends Control

var mem: Memeory
@onready var slots_UI: Array = $SlotsGridBackground/CenterContainer/GridContainer.get_children() #Array di Memeory_UI_Slot
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi
var i = 0

signal exit

func _ready():
	$Deck.hide()
	_instantiate_memeory()
	_draw_random_card()
	mem.update.connect(update_slots)
	update_slots()
	
	
func _draw_random_card():
	var card_container = $Deck
	var cards = card_container.get_children()
	if cards.size() == 0:
		return
	cards.shuffle()
	for random_card in cards:
		random_card.index = i
		mem.insert(random_card)
		i = i+1
	print_debug(MemeoryManager.slots)
	
	
func _instantiate_memeory():
	mem = MemeoryManager
		
func update_slots():
	for i in range(min(mem.slots.size(), slots_UI.size())):
		slots_UI[i].update(mem.slots[i])

func _on_exit_pause_menu_button_pressed():
	self.exit.emit() # Replace with function body.
