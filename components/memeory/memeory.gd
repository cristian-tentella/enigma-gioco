extends Node

class_name Memeory

signal update
var slots: Array[Card] #Gli slot dell'inventario

func insert(card: Card):
	slots.append(card)
	update.emit()

func has_item(needed_card_name: String):
	for i in slots:
		if i.card_name == needed_card_name:
			return true
	return false
		
