class_name InventoryUI
extends Control

var inv: Inventory
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi

signal exit

func _ready():
	_instanciate_inventory()
	inv.update.connect(update_slots)
	update_slots()
	
# Doing it dynamically is the only way to make it work. 
# Original implementation with .tres was overkill considering I just create 8 empty slots with no properties
func _instanciate_inventory():
	inv = Inventory.new()
	inv._create_own_empty_slots_on_startup()
	StateManager.inventory = inv

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
"""
func open():
	self.visible = true
	self.is_open = true 
	
func close():
	self.visible = false
	self.is_open = false

func is_inv_open():
	return is_open
	
func _on_inventory_pressed():
	if is_open: 
		close()
	else:
		open()
"""


