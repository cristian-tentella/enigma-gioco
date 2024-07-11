extends Node

class_name Inventory

signal update
var slots: Array[PickableItem] #Gli slot dell'inventario

var item_pickup_dialogue: DialogueInteraction #Assegnata dall'inventory_UI all'inizializzazione

func insert(item: PickableItem):
	slots.append(item)
	update.emit()
	item_pickup_dialogue.handle_interaction()
	

func has_item(needed_item_name: String):
	for i in slots:
		if i.item_name == needed_item_name:
			return true
	return false

func return_item_names():
	var item_names = []
	for slot in slots:
		item_names.append(slot.item_name)
	return item_names
 
