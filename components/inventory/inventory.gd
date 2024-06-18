extends Node

class_name Inventory

signal update
var slots: Array[PickableItem] #Gli slot dell'inventario

func insert(item: PickableItem):
	slots.append(item)
	update.emit()

func has_item(needed_item_name: String):
	for i in slots:
		if i.item_name == needed_item_name:
			return true
	return false
		
 
