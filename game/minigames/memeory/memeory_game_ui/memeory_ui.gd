class_name MemeoryUI
extends Control

#var MemeoryManager: Memeory
@onready var slots_UI: Array = $GridContainer.get_children() #Array di Memeory_UI_Slot
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi
var index = 0
@onready var heart_UI: Array = $Hearts.get_children()
var addlife = false
var reset = false

signal exit
signal close_popup
signal close_description
signal end_game
signal description_closed

func _ready():
	$Deck.hide()
		#heart.stop_animation()
		
	MemeoryManager.memeory_ui = self
	MemeoryManager.gamelost.connect(game_lost_ui)
	MemeoryManager.gamewon.connect(game_won_ui)
	MemeoryManager.start.connect(start_new_game)
	MemeoryManager.updatehearts.connect(update_hearts)
	MemeoryManager.update.connect(update_slots)
	MemeoryManager.description.connect(show_description)
	MemeoryManager.change_life_ui.connect(change_life_system)
	MemeoryManager.virus_ui.connect(show_popup)
	update_slots()


func _draw_random_card():  
	MemeoryManager.slots.clear()
	index = 0
	var card_container = $Deck
	var cards = card_container.get_children()
	if cards.size() == 0:
		return
	cards.shuffle()
	for random_card in cards:
		random_card.index = index
		#print_debug(random_card.index)
		MemeoryManager.insert(random_card)
		index = index+1
	
func start_new_game():
	reset_ui()
	MemeoryManager.clicks = 0
	MemeoryManager.hearts_array.clear()
	MemeoryManager.hearts_lost.clear()
	heart_UI = $Hearts.get_children()
	#print_debug(heart_UI)
	for heart in heart_UI:
		MemeoryManager.create_heart(heart)
		heart.beating_animation()
	#MemeoryManager.update_hearts()
	#update_hearts()
	_draw_random_card()
	print_debug(MemeoryManager.slots)
	#print_debug(MemeoryManager.hearts_array)
	MemeoryManager.cover_all_cards()

func reset_ui():
	reset_beating(8)
	$CloseUiButton.show()
	$Watermelons.hide()
	$Virus.hide()
	$Virus/Popup1.show()
	$Virus/Popup2.show()
	$Virus/Popup3.show()
	$Virus/Popup4.show()
	$LifePointsBackground.hide()
	$Hearts.show()
	$Card_Description.hide()
	$Win_Lost.hide()
	$Card_Description.hide()
	$End_game.hide()
	$Close_Description.hide()
	
func update_slots():
	for k in range(min(MemeoryManager.slots.size(), slots_UI.size())):
		slots_UI[k].update(MemeoryManager.slots[k])
		
func update_hearts():
	for k in range(min(MemeoryManager.hearts_array.size(),heart_UI.size())):
		heart_UI[k].updateheart(MemeoryManager.hearts_array[k])
	var life_points = MemeoryManager.hearts_array.size() * 1000
	$"LifePointsBackground/Life Points".text = str(life_points) + "LP"
	#print_debug($"LifePointsBackground/Life Points".text)

func reset_beating(k):
		for i in range(0,k):
			heart_UI[i].stop_animation()
			heart_UI[i].beating_animation()
			print_debug("worka")

		
func game_lost_ui():
	$CloseUiButton.hide()
	await get_tree().create_timer(1).timeout
	$Win_Lost/Label.text = "memeory_lost_ui"
	print_debug($Win_Lost/Label.text)
	$Win_Lost.show()
	$End_game.show()
	await end_game
	self.exit.emit()
	
func game_won_ui():
	$CloseUiButton.hide()
	await get_tree().create_timer(1).timeout
	$Win_Lost/Label.text = "memeory_win_ui"
	#await get_tree().create_timer(0.0000001).timeout
	$Win_Lost.show()
	$End_game.show()
	await end_game
	await get_tree().create_timer(1).timeout
	self.exit.emit()
	
func show_description():
	$CloseUiButton.hide()
	$Close_Description.show()
	var card_type = MemeoryManager.picked[1].card_type
	MemeoryManager.clicks = -1
	update_slots()
	$Card_Description/Label.text = "memeory_"+String(card_type)+"_description"
	$Card_Description.show()
	await close_description
	print_debug("qui")
	$Close_Description.hide()
	$Card_Description.hide()
	$CloseUiButton.show()
	self.description_closed.emit()
	
func change_life_system():
	$Hearts.hide()
	$"LifePointsBackground".show()

func show_popup():
	$Virus.show()

func _on_exit_pause_menu_button_pressed():
	MemeoryManager.clear_slots()
	self.exit.emit()

func show_watermelons():
	$Watermelons.show()

func _on_exit_popup_1_pressed():
	$Virus/Popup1.hide()

func _on_exit_popup_2_pressed():
	$Virus/Popup2.hide()

func _on_exit_popup_3_pressed():
	$Virus/Popup3.hide()

func _on_exit_popup_4_pressed():
	$Virus/Popup4.hide()


func _on_button_pressed():
	$Card_Description.hide()
	self.close_description.emit() 

func _on_end_game_pressed():
	self.end_game.emit() # Replace with function body.
