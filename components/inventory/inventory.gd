"""class_name Inventory
extends Resource

@export var slots: Array[GenericItem]
var update

# Insert the item in the correct inventory slot
func _insert(item: GenericItem):
	var item_slots = slots.filter(func(slot): return slot.item == item)

	if not item_slots.is_empty():
		item_slots[0].amount += 1
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		
		if not empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
	update.emit()"""

extends Resource

class_name Inventory
signal update

@export var slots: Array[MyInventorySlot]

func insert(item: GenericItem):
	#print_debug("Insert start ok")
	var itemslots = slots.filter(func(slot): return slot.item == item)
	#print_debug(itemslots)
	if not itemslots.is_empty():
		#print_debug("Raccolta item già in inventario ok")
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		#print_debug("slot vuoti:")
		#print_debug(emptyslots) 
		if !emptyslots.is_empty():
			#print_debug("Raccolta nuovo item ok")
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

func _create_own_empty_slots_on_startup():
	for i in range(8):
		var slot = MyInventorySlot.new()
		self.slots.append(slot)

