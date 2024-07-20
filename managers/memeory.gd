extends Node

class_name Memeory

signal start
signal update
signal updatehearts
signal gamelost
signal gamewon

var slots: Array[Card] #Gli slot del memeory
var picked: Array[Card]
var clicks = 0
var hearts_array: Array[Heart]
var hearts = hearts_array.size()
var i = 0
var game_won

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
	hearts_array.append(heart)

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
	updatehearts.emit()
	update.emit()

func remove_picks():
	for card in picked:
		slots[card.index] = null
		update.emit()
		
func has_couple():
	var couple = (picked[0].card_type == picked[1].card_type and picked[0].card_name != picked[1].card_name)
	return couple
	
func check():
	var check_var = has_couple()
	if(!check_var):
		await get_tree().create_timer(1).timeout
		AudioManager.play_failure_sound_effect()
		if(hearts_array.size() > 0):
			hearts_array[hearts_array.size()-1] = null
		cover_picked_cards()
	else:
		game_won = true
		await get_tree().create_timer(0.7).timeout
		AudioManager.play_success_sound_effect()
		remove_picks()
		print_debug(MemeoryManager.slots)
		for card in slots:
			if (card != null):
				print_debug("not yet")
				game_won = false
				break
		if (game_won):
			StateManager.current_minigame += 3 #Insieme al minigame 3 serve che la somma faccia 10
			gamewon.emit()
	reset_pick()

func cover_picked_cards():
	for card in MemeoryManager.picked:
		card.update_card_sprite2D_back_texture()
		update.emit()

func cover_all_cards():
	for card in MemeoryManager.slots:
		card.update_card_sprite2D_back_texture()
		update.emit()

func clear_slots():
	slots.clear()
	picked.clear()
	update.emit()
