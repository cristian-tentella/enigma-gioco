extends Control
class_name MemeoryUISlot

@onready var panel : Panel = $CenterContainer/Panel

@onready var card_visual: Sprite2D = $CenterContainer/Panel/Sprite

#Funzione chiamata ogni volta che memeory ha qualche cambiamento, quindi il singolo slot si gestisce da solo
func update(slot: Card):
	if !slot:
		card_visual.visible = false
	else:
		card_visual.visible = true
		#print_debug(slot.card_sprite)
		card_visual.texture = slot.sprite2D.texture #Nello slot ci metto la texture dell'item
		#print_debug(card_visual.texture)
