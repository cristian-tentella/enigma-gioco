extends Control
class_name InventoryUISlot

@onready var panel : Panel = $CenterContainer/Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Sprite2D

#Funzione chiamata ogni volta che l'inventario ha qualche cambiamento, quindi il singolo slot si gestisce da solo
func update(slot: PickableItem):
	if !slot:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.sprite2D.texture #Nello slot ci metto la texture dell'item

