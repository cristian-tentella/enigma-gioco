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
	MemeoryManager.gamelost.connect(game_lost_ui)
	MemeoryManager.gamewon.connect(game_won_ui)
	MemeoryManager.start.connect(start_new_game)
	MemeoryManager.updatehearts.connect(update_hearts)
	MemeoryManager.update.connect(update_slots)
	update_slots()

	
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
	
func start_new_game(): 
	MemeoryManager.hearts_array.clear()
	MemeoryManager.clicks = 0
	heart_UI = $Hearts.get_children()
	#print_debug(heart_UI)
	$LineEdit.hide()
	for i in heart_UI:
		MemeoryManager.insert_heart(i)
		i.beating_animation()
	MemeoryManager.update_hearts()
	_draw_random_card()
	MemeoryManager.cover_all_cards()
	
func update_slots():
	for i in range(min(MemeoryManager.slots.size(), slots_UI.size())):
		slots_UI[i].update(MemeoryManager.slots[i])
		
func update_hearts():
	for k in range(min(MemeoryManager.hearts_array.size(),heart_UI.size())):
		heart_UI[k].updateheart(MemeoryManager.hearts_array[k])
		
func game_lost_ui():
	await get_tree().create_timer(0.5).timeout
	$LineEdit.text = "HAI PERSO"
	$LineEdit.show()
	
func game_won_ui():
	await get_tree().create_timer(0.2).timeout
	$LineEdit.text = "HAI VINTO"
	$LineEdit.show()
	await get_tree().create_timer(1).timeout
	self.exit.emit()

func _on_exit_pause_menu_button_pressed():
	MemeoryManager.clear_slots()
	self.exit.emit() # Replace with function body.
