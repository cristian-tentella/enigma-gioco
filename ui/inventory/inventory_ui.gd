class_name InventoryUI
extends Control

var NO_ITEM_SELECTED_DESC_STRING #è quello che esce quando non hai selezionato nessun item, viene assegnato nel _ready()


var inv: Inventory
@onready var slots_UI: Array = $SlotsGridBackground/GridContainer.get_children() #Array di Inventory_UI_Slot
var is_open: bool = false #Ridondanza della proprietà self.visible, ma è più comodo usarlo cosi

@onready var description_label = $ItemDescriptionBackground/MarginContainer/ItemDescription

signal exit


func _ready():
	_instantiate_inventory()
	self.inv.item_pickup_dialogue = $ItemPickupDialogue
	inv.update.connect(update_slots)
	update_slots()
	#_assign_NO_ITEM_SELECTED_DESC_STRING()
	
# Doing it dynamically is the only way to make it work.
# Original implementation with .tres was overkill considering I just create 8 empty slots with no properties
func _instantiate_inventory(): #Questo lo fa il SaveManager, ma qui lo si lascia per sport TODO: remove?
	inv = Inventory.new()
	StateManager.inventory = inv

func update_slots():
	#for i in range(min(inv.slots.size(), slots_UI.size())):
	#	slots_UI[i].update(inv.slots[i])
	var inv_len = inv.slots.size()
	for i in range(inv_len):
		slots_UI[i].update(inv.slots[i])
	if inv_len < slots_UI.size():
		for i in range(inv_len + 1, slots_UI.size()):
			slots_UI[i].update(null)

func _assign_NO_ITEM_SELECTED_DESC_STRING():
	self.NO_ITEM_SELECTED_DESC_STRING = DialogueManager._item_description_id_to_item_description("NO_ITEM_SELECTED_DESC_STRING")
	self.description_label.text = self.NO_ITEM_SELECTED_DESC_STRING

func _assign_NO_ITEM_SELECTED_DESC_STRING_MINIGAME4():
	self.NO_ITEM_SELECTED_DESC_STRING = DialogueManager._item_description_id_to_item_description("NO_ITEM_SELECTED_DESC_STRING_MINIGAME4")
	self.description_label.text = self.NO_ITEM_SELECTED_DESC_STRING

func change_description(new_desc: String):
	self.description_label.text = new_desc
	await get_tree().create_timer(0.0001).timeout

func _on_exit_pause_menu_button_pressed():
	#Rimetti il testo di quando non hai selezionato nessun item
	self.description_label.text = self.NO_ITEM_SELECTED_DESC_STRING
	
	self.exit.emit() # Replace with function body.


func _change_description_label_on_slot_button_pressed(slot_number: int):
	AudioManager.play_click_sound_effect()
	#Usiamo inv e non slots_UI perché hanno la stessa indicizzazione, e ci serve il PickableItem
	var item_count_into_inventory = len(self.inv.slots)

	if item_count_into_inventory < slot_number: #Ha cliccato su uno slot senza items, via di qui
		self.description_label.text = self.NO_ITEM_SELECTED_DESC_STRING
		return
	
	#Uso slot number -1 perché non voglio disallineare il nome dei nodi e il fatto che l'array inizia da 0
	slot_number -= 1
	var item_to_show = self.inv.slots[slot_number]
	
	item_to_show._associate_description_from_traslation_file()
	item_to_show._associate_name_from_traslation_file()
	#Nome -> item_to_show.localized_item_name
	#Descrizione -> item_to_show.description
	self.description_label.text = item_to_show.localized_item_name+"\n\n"+item_to_show.description
	
	self.inventory_slot_pressed.emit(item_to_show)


signal inventory_slot_pressed(item: PickableItem)

func _on_inventory_ui_slot_1_button_pressed():
	_change_description_label_on_slot_button_pressed(1)


func _on_inventory_ui_slot_2_button_pressed():
	_change_description_label_on_slot_button_pressed(2)


func _on_inventory_ui_slot_3_button_pressed():
	_change_description_label_on_slot_button_pressed(3)



func _on_inventory_ui_slot_4_button_pressed():
	_change_description_label_on_slot_button_pressed(4)



func _on_inventory_ui_slot_5_button_pressed():
	_change_description_label_on_slot_button_pressed(5)


func _on_inventory_ui_slot_6_button_pressed():
	_change_description_label_on_slot_button_pressed(6)


func _on_inventory_ui_slot_7_button_pressed():
	_change_description_label_on_slot_button_pressed(7)



func _on_inventory_ui_slot_8_button_pressed():
	_change_description_label_on_slot_button_pressed(8)



func _on_inventory_ui_slot_9_button_pressed():
	_change_description_label_on_slot_button_pressed(9)


func _on_inventory_ui_slot_10_button_pressed():
	_change_description_label_on_slot_button_pressed(10)


func _on_inventory_ui_slot_11_button_pressed():
	_change_description_label_on_slot_button_pressed(11)


func _on_inventory_ui_slot_12_button_pressed():
	_change_description_label_on_slot_button_pressed(12)


func _on_inventory_ui_slot_13_button_pressed():
	_change_description_label_on_slot_button_pressed(13)


func _on_inventory_ui_slot_14_button_pressed():
	_change_description_label_on_slot_button_pressed(14)


func _on_inventory_ui_slot_15_button_pressed():
	_change_description_label_on_slot_button_pressed(15)


func _on_inventory_ui_slot_16_button_pressed():
	_change_description_label_on_slot_button_pressed(16)

