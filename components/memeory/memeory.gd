extends Node

class_name Memeory

signal update
var slots: Array[Card] #Gli slot del memeory
var picked: Array[Card]
var clicks = 0

func insert(card: Card):
	slots.append(card)
	update.emit()

func has_item(needed_card_name: String):
	for i in slots:
		if i.card_name == needed_card_name:
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
		slots[card.index] = null
		print_debug(slots)
		update.emit()
		
func has_couple():
	var couple = (picked[0].card_type == picked[1].card_type and picked[0].card_name != picked[1].card_name)
	return couple
	
func check():
	var check = has_couple()
	if(!check):
		await get_tree().create_timer(1).timeout
		cover_cards()
	else:
		await get_tree().create_timer(0.7).timeout
		remove_picks()
	reset_pick()

func cover_cards():
	for card in MemeoryManager.picked:
		card.update_card_sprite2D_back_texture()
		update.emit()

