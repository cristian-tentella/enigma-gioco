class_name MemeoryUI
extends Control

var mem: Memeory
@onready var slots_UI: Array = $SlotsGridBackground/CenterContainer/GridContainer.get_children() #Array di Memeory_UI_Slot
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi

signal exit

func _ready():
	$Deck.hide()
	mem = Memeory.new()
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
		#var random_card = cards.pop_front()
		#print_debug(cards)
		#print_debug(random_card.card_name)
		mem.insert(random_card)
		#update_slots()
		#print_debug(mem.slots)
		#print_debug(mem.slots[i])
		
		
# Doing it dynamically is the only way to make it work.
# Original implementation with .tres was overkill considering I just create 8 empty slots with no properties
#func _instantiate_memeory():
	#mem = Memeory.new()
	#StateManager.inventory = inv

func update_slots():
	for i in range(min(mem.slots.size(), slots_UI.size())):
		slots_UI[i].update(mem.slots[i])

func _on_exit_pause_menu_button_pressed():
	self.exit.emit() # Replace with function body.
