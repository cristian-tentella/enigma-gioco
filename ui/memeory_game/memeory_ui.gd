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
		mem.insert(random_card)
		
func update_slots():
	for i in range(min(mem.slots.size(), slots_UI.size())):
		#print_debug(slots_UI[i].button)
		slots_UI[i].update(mem.slots[i])

func _on_exit_pause_menu_button_pressed():
	self.exit.emit() # Replace with function body.
