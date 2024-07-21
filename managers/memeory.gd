extends Node

class_name Memeory

signal start
signal update
signal updatehearts
signal gamelost
signal gamewon
signal description
signal addlife

var slots: Array[Card] #Gli slot del memeory
var picked: Array[Card]
var clicks = 0
var hearts_array: Array[Heart]
const max_hearts = 5
var i = 0
var game_won
var last_heart_lost

func start_game():
	start.emit()
	
func update_hearts():
	updatehearts.emit()

func remove_heart():
	print_debug(hearts_array.size())
	#if(hearts_array[0]!=null):
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
	#updatehearts.emit()
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
		#print_debug("coppie non uguali")
		await get_tree().create_timer(1).timeout
		AudioManager.play_failure_sound_effect()
		remove_heart_from_array()
		for i in range(0,2):
			#print_debug(i)
			if(picked[i].card_type == "shuffle"):
				print_debug("rimescola")
				card_show_description()
				#update.emit()
				picked[i].handle_interaction()
		cover_picked_cards()
	else:
		var shuffle_check = picked[0].card_type
		game_won = true
		await get_tree().create_timer(0.7).timeout
		AudioManager.play_success_sound_effect()
		remove_picks()
		#print_debug(MemeoryManager.clicks)
		card_show_description()
		#print_debug("ciao")
		#print_debug(MemeoryManager.clicks)
		await get_tree().create_timer(3).timeout
		print_debug(shuffle_check)
		print_debug(picked[1])
		if(shuffle_check != "shuffle"):
			print_debug("attiva effetto carta 2")
			picked[1].handle_interaction() 
		for card in slots:
			if (card != null):
				#print_debug("not yet")
				game_won = false
				break
		if (game_won):
			StateManager.current_minigame += 3 #Insieme al minigame 3 serve che la somma faccia 10
			gamewon.emit()
	print_debug(MemeoryManager.slots)
	#print_debug(MemeoryManager.hearts_array)
	#update.emit()
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
	description.emit()

func remove_heart_from_array():
	if(hearts_array.size() > 0):
		print_debug("rimuovo cuore")
		last_heart_lost = hearts_array[hearts_array.size()-1]
		hearts_array[hearts_array.size()-1] = null
		updatehearts.emit()
	
func clear_slots():
	slots.clear()
	picked.clear()
	update.emit()

