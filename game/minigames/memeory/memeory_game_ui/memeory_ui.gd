class_name MemeoryUI
extends Control

#var MemeoryManager: Memeory
@onready var slots_UI: Array = $SlotsGridBackground/CenterContainer/GridContainer.get_children() #Array di Memeory_UI_Slot
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi
var index = 0
@onready var heart_UI: Array = $Hearts.get_children()
var addlife = false

signal exit
signal close_popup
signal close_description

func _ready():
	$Deck.hide()
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
	MemeoryManager.hearts_array.clear()
	MemeoryManager.hearts_lost.clear()
	MemeoryManager.clicks = 0
	heart_UI = $Hearts.get_children()
	#print_debug(heart_UI)
	for heart in heart_UI:
		MemeoryManager.insert_heart(heart)
		heart.beating_animation()
	#MemeoryManager.update_hearts()
	_draw_random_card()
	print_debug(MemeoryManager.slots)
	#print_debug(MemeoryManager.hearts_array)
	MemeoryManager.cover_all_cards()

func reset_ui():
	$Watermelons.hide()
	$Virus.hide()
	$Virus/Sprite2D.show()
	$Virus/Sprite2D2.show()
	$Virus/Sprite2D3.show()
	$Virus/Sprite2D4.show()
	$LifePointsBackground.hide()
	$Hearts.show()
	$Card_Description.hide()
	$CenterContainer.hide()
	
func update_slots():
	for k in range(min(MemeoryManager.slots.size(), slots_UI.size())):
		slots_UI[k].update(MemeoryManager.slots[k])
		
func update_hearts():
	for k in range(min(MemeoryManager.hearts_array.size(),heart_UI.size())):
		heart_UI[k].updateheart(MemeoryManager.hearts_array[k])
	var life_points = MemeoryManager.hearts_array.size() * 1000
	$"LifePointsBackground/Life Points".text = str(life_points) + "LP"
	print_debug($"LifePointsBackground/Life Points".text)

		
func game_lost_ui():
	$CloseButtonBackground.hide()
	await get_tree().create_timer(1).timeout
	$CenterContainer/Win_or_Lost/Label.text = "memeory_lost_ui"
	print_debug($CenterContainer/Win_or_Lost/Label.text)
	$CenterContainer.show()
	await get_tree().create_timer(1).timeout
	self.exit.emit()
	
func game_won_ui():
	$CloseButtonBackground.hide()
	await get_tree().create_timer(1).timeout
	$CenterContainer/Win_or_Lost/Label.text = "memeory_win_ui"
	$CenterContainer.show()
	await get_tree().create_timer(1).timeout
	self.exit.emit()
	
func show_description():
	$CloseButtonBackground.hide()
	#$Card_Description/Button.show()
	var card_type = MemeoryManager.picked[1].card_type
	MemeoryManager.clicks = -1
	update_slots()
	$Card_Description/Label.text = "memeory_"+String(card_type)+"_description"
	$Card_Description.show()
	await close_description
	$CloseButtonBackground.show()
	
func change_life_system():
	$Hearts.hide()
	$"LifePointsBackground".show()

func show_popup():
	$Virus.show()

func _on_exit_pause_menu_button_pressed():
	MemeoryManager.clear_slots()
	AudioManager.stop_current_sound_track()
	self.exit.emit()

func show_watermelons():
	$Watermelons.show()

func _on_exit_popup_1_pressed():
	$Virus/Sprite2D.hide()

func _on_exit_popup_2_pressed():
	$Virus/Sprite2D2.hide()

func _on_exit_popup_3_pressed():
	$Virus/Sprite2D3.hide()

func _on_exit_popup_4_pressed():
	$Virus/Sprite2D4.hide()


func _on_button_pressed():
	$Card_Description.hide()
	self.close_description.emit()
