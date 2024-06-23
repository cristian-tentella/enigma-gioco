extends Control
class_name MemeoryUISlot

@onready var panel : Panel = $CenterContainer/Panel

@onready var card_visual: Sprite2D = $CenterContainer/Panel/Sprite
@onready var pickablearea: CollisionShape2D = $CenterContainer/Panel/Sprite/Area2D/CollisionShape2D
@onready var button : Button = $CenterContainer/Panel/Button
var card_in_slot : Array[Card]


#Funzione chiamata ogni volta che memeory ha qualche cambiamento, quindi il singolo slot si gestisce da solo
func update(slot: Card):
	if !slot:
		card_visual.visible = false
	else:
		card_visual.visible = true
		card_visual.texture = slot.sprite2D.texture #Nello slot ci metto la texture dell'item
		card_in_slot.append(slot)
		pickablearea.shape = slot.area.shape
		button.icon = slot.button.icon
		button.show()
		
 


func _on_button_pressed():
	var card = card_in_slot.front()
	print_debug(card)
	card.update_card_sprite2D_front_texture()
	card_visual.texture = card.sprite2D.texture
	

