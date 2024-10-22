extends Node

class_name Inventory

signal update
var slots: Array[PickableItem] #Gli slot dell'inventario

var item_pickup_dialogue: DialogueInteraction #Assegnata dall'inventory_UI all'inizializzazione

func insert(item: PickableItem):
	slots.append(item)
	update.emit()
	item_pickup_dialogue.handle_interaction()
	await DialogueManager.has_finished_displaying
	AudioManager.play_item_pickup_sound_effect()
  

func insert_no_dialogue(item: PickableItem):
	slots.append(item)
	update.emit()


func has_item(needed_item_name: String):
	for i in slots:
		if i.item_name == needed_item_name:
			return true
	return false

func find_item(needed_item_name: String) -> PickableItem:
	for i in slots:
		if i.item_name == needed_item_name:
			return i
	return null

#Se quando salvi lancia qui un errore, probabilmente hai fatto la queue free di un minigioco.tscn ma li dentro ci stava l'oggetto
#Metti l'oggetto nella mappa!
func return_item_names():
	var item_names = []
	for slot in slots:
		item_names.append(slot.item_name)
	return item_names

func remove(item_name: String):
	var to_remove: PickableItem = self.find_item(item_name)
	
	if to_remove != null:
		self.slots.erase(to_remove)
		update.emit()
