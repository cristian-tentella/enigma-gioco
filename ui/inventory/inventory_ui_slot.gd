extends Panel
class_name InventoryUISlot

@onready var item: GenericItem = $CenterContainer/Panel/GenericItem
@onready var item_visual : Sprite2D = $CenterContainer/Panel/GenericItem/Sprite2D
@onready var amount_text: Label = $CenterContainer/Panel/item_quantity

#Funzione chiamata ogni volta che l'inventario ha qualche cambiamento, quindi il singolo slot si gestisce da solo
func update(slot: MyInventorySlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.sprite2D #Nello slot ci metto la texture dell'item
		if slot.amount > 0:
			amount_text.visible = true
		amount_text.text = str(slot.amount)
