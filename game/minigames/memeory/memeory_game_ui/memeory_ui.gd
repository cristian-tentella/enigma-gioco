class_name MemeoryUI
extends Control

#var MemeoryManager: Memeory
@onready var slots_UI: Array = $SlotsGridBackground/CenterContainer/GridContainer.get_children() #Array di Memeory_UI_Slot
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi
var index = 0
@onready var heart_UI: Array = $Hearts.get_children()
var addlife = false

signal exit

func _ready():
	$Deck.hide()
	MemeoryManager.gamelost.connect(game_lost_ui)
	MemeoryManager.gamewon.connect(game_won_ui)
	MemeoryManager.start.connect(start_new_game)
	MemeoryManager.updatehearts.connect(update_hearts)
	MemeoryManager.update.connect(update_slots)
	MemeoryManager.description.connect(show_description)
	#MemeoryManager.addlife.connect(addlife_ui)
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
	#AudioManager.stop_current_sound_track()
	#AudioManager.play_memeory_sound_track()
	MemeoryManager.hearts_array.clear()
	MemeoryManager.hearts_lost.clear()
	MemeoryManager.clicks = 0
	heart_UI = $Hearts.get_children()
	#print_debug(heart_UI)
	$Card_Description.hide()
	$Win_or_Lost.hide()
	for heart in heart_UI:
		MemeoryManager.insert_heart(heart)
		heart.beating_animation()
	#MemeoryManager.update_hearts()
	_draw_random_card()
	print_debug(MemeoryManager.slots)
	#print_debug(MemeoryManager.hearts_array)
	MemeoryManager.cover_all_cards()
	
func update_slots():
	for k in range(min(MemeoryManager.slots.size(), slots_UI.size())):
		slots_UI[k].update(MemeoryManager.slots[k])
		
func update_hearts():
	for k in range(min(MemeoryManager.hearts_array.size(),heart_UI.size())):
		heart_UI[k].updateheart(MemeoryManager.hearts_array[k])

		
func game_lost_ui():
	$CloseButtonBackground.hide()
	await get_tree().create_timer(1).timeout
	$Win_or_Lost/Label.text = "memeory_lost_ui"
	$Win_or_Lost.show()
	await get_tree().create_timer(1).timeout
	self.exit.emit()
	
func game_won_ui():
	$CloseButtonBackground.hide()
	await get_tree().create_timer(1).timeout
	$Win_or_Lost/Label.text = "memeory_win_ui"
	$Win_or_Lost.show()
	await get_tree().create_timer(1).timeout
	self.exit.emit()
	
func show_description():
	$CloseButtonBackground.hide()
	var card_type = MemeoryManager.picked[1].card_type
	#print_debug(card_type)
	MemeoryManager.clicks = -1
	#print_debug(MemeoryManager.clicks)
	update_slots()
	$Card_Description/Label.text = "memeory_"+String(card_type)+"_description"
	$Card_Description.show()
	await get_tree().create_timer(3).timeout
	$Card_Description.hide()
	$CloseButtonBackground.show()
	

func _on_exit_pause_menu_button_pressed():
	MemeoryManager.clear_slots()
	AudioManager.stop_current_sound_track()
	self.exit.emit()


func _on_touch_screen_button_pressed():
	$Card_Description.hide()
	MemeoryManager.pressed = true
