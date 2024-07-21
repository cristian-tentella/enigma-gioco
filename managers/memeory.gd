extends Node

class_name Memeory

signal start
signal update
signal updatehearts
signal gamelost
signal gamewon
signal description
signal addlife
signal change_life_ui
signal virus_ui

var slots: Array[Card] #Gli slot del memeory
var picked: Array[Card]
var clicks = 0
var hearts_array: Array[Heart]
const max_hearts = 8
var game_won
var hearts_lost: Array[Heart]
var last_heart_lost
var memeory_ui

func start_game():
	start.emit()
	
func update_hearts():
	updatehearts.emit()

func remove_heart():
	hearts_array.remove_at(hearts_array.size()-1)

func insert(card: Card):
	slots.append(card)
	update.emit()
	
func insert_heart(heart: Heart):
	heart.recover = true
	hearts_array.append(heart)
	updatehearts.emit()

func has_item(needed_card_name: String):
	for slot in slots:
		if slot.card_name == needed_card_name:
			return true
	return false

func insert_pick(card: Card):
	picked.append(card)
	update.emit()

func reset_pick():
	picked.clear()
	clicks = 0
	update.emit()

func remove_picks():
	for card in picked:
		var index_remove = slots.find(card)
		print_debug(index_remove)
		slots[index_remove] = null
		update.emit()
		
func has_couple():
	var couple = (picked[0].card_type == picked[1].card_type and picked[0].card_name != picked[1].card_name)
	return couple
	
func check():
	var check_var = has_couple()
	if(!check_var):
		await get_tree().create_timer(1).timeout
		AudioManager.play_failure_sound_effect()
		print_debug(picked)
		if(picked[0].card_type == "shuffle"):
				picked.reverse()
		if(picked[1].card_type == "shuffle"):
				print_debug("rimescola")
				card_show_description()
				await get_tree().create_timer(3).timeout
				picked[1].handle_interaction()
			
		if(picked[0].card_type != "shuffle" and picked[1].card_type != "shuffle"):
			remove_heart_from_array()
		cover_picked_cards()
	else:
		game_won = true
		var shuffle_check = picked[0].card_type
		await get_tree().create_timer(0.7).timeout
		AudioManager.play_success_sound_effect()
		remove_picks()
		card_show_description()
		await memeory_ui.close_description
		print_debug(shuffle_check)
		print_debug(picked[1])
		if(picked[1].card_type == "extralife"):
			MemeoryManager.hearts_lost.reverse() 
		if(shuffle_check != "shuffle"):
			print_debug("attiva effetto carta")
			picked[1].handle_interaction()
		if(picked[1].card_type == "seer"):
			await get_tree().create_timer(2).timeout
		check_game_won()
		if (game_won):
			StateManager.current_minigame += 3 #Insieme al minigame 3 serve che la somma faccia 10
			gamewon.emit()
	print_debug(MemeoryManager.slots)
	reset_pick()

func cover_picked_cards():
	for card in MemeoryManager.picked:
		card.update_card_sprite2D_back_texture()
		update.emit()

func cover_all_cards():
	for card in MemeoryManager.slots:
		card.update_card_sprite2D_back_texture()
		update.emit()

func card_show_description():
	print_debug("mostro effetto")
	description.emit()

func remove_heart_from_array():
	if(hearts_array.size() > 0):
		hearts_lost.append(hearts_array[hearts_array.size()-1])
		hearts_array[hearts_array.size()-1] = null
		updatehearts.emit()
	
func clear_slots():
	slots.clear()
	picked.clear()
	update.emit()
	
func check_game_won():
	for card in slots:
			if (card != null):
				game_won = false
				break

func meme_card_effect():
	change_life_ui.emit()
	
func virus_card_effect():
	virus_ui.emit()
	
func watermelon_card_effect():
	self.memeory_ui.show_watermelons()
