extends Node

class_name Memeory

signal update
var slots: Array[Card] #Gli slot del memeory
var picked: Array[Card]

func insert(card: Card):
	slots.append(card)
	update.emit()

func has_item(needed_card_name: String):
	for i in slots:
		if i.card_name == needed_card_name:
			return true
	return false

func insert_pick(card: Card, ):
	if (picked.size() < 1):
		picked.append(card)
		update.emit()
	else:
		#print_debug("entro nell'else")
		picked.append(card)
		var check_couple = has_couple()
		print_debug(check_couple)
		#cover_cards(picked, check_couple)
		return check_couple

func has_couple():
	#print_debug("entro in has_couple")
	var couple = (picked[0].card_type == picked[1].card_type and picked[0].card_name != picked[1].card_name)
	#if (!couple):
	#cover_cards()
	#cover_cards()
	picked.clear()
	return couple
	
func cover_cards(card_visual: Sprite2D):
	for card in MemeoryManager.picked:
		card.update_card_sprite2D_back_texture()
		card.clickable = true
		card_visual.texture = card.sprite2D.texture
		
	
