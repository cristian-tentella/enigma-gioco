extends Node

class_name Inventory

signal update
var slots: Array[PickableItem] #Gli slot dell'inventario

func insert(item: PickableItem):
	slots.append(item)
	update.emit()
