class_name InventoryUI
extends Control

var inv: Inventory
@onready var slots_UI: Array = $SlotsGridBackground/CenterContainer/GridContainer.get_children() #Array di Inventory_UI_Slot
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi

signal exit

func _ready():
	_instantiate_inventory()
	self.inv.item_pickup_dialogue = $ItemPickupDialogue
	inv.update.connect(update_slots)
	update_slots()
	
# Doing it dynamically is the only way to make it work.
# Original implementation with .tres was overkill considering I just create 8 empty slots with no properties
func _instantiate_inventory(): #Questo lo fa il SaveManager, ma qui lo si lascia per sport TODO: remove?
	inv = Inventory.new()
	StateManager.inventory = inv

func update_slots():
	for i in range(min(inv.slots.size(), slots_UI.size())):
		slots_UI[i].update(inv.slots[i])

func _on_exit_pause_menu_button_pressed():
	self.exit.emit() # Replace with function body.
