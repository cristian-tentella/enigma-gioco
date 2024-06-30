extends Control
class_name MemeoryUISlot

@onready var panel : Panel = $CenterContainer/Panel

@onready var card_visual: Sprite2D = $CenterContainer/Panel/Sprite
@onready var pickablearea: CollisionShape2D = $CenterContainer/Panel/Sprite/Area2D/CollisionShape2D
@onready var button : Button = $CenterContainer/Panel/Button
var card_in_slot : Card


#Funzione chiamata ogni volta che memeory ha qualche cambiamento, quindi il singolo slot si gestisce da solo
func update(slot: Card):
	if !slot:
		card_visual.visible = false
	else:
		card_visual.visible = true
		card_visual.texture = slot.sprite2D.texture #Nello slot ci metto la texture dell'item
		card_in_slot = slot
		card_in_slot.index = slot.index
		pickablearea.shape = slot.area.shape
		button.icon = slot.button.icon
		button.show()
		
 
func _on_button_pressed():
	print_debug(card_in_slot)
	if(card_in_slot.clickable):
		card_in_slot.update_card_sprite2D_front_texture()
		#card_visual.texture = card_in_slot.sprite2D.texture
		self.update(card_in_slot)
		card_in_slot.clickable = false
		MemeoryManager.insert_pick(card_in_slot)
		#if (check == true):
			#print("pippo")
		#else:
			#print("caio")
		#print_debug(MemeoryManager.picked.find(card_in_slot))
	else:
		if(MemeoryManager.picked.size()==0):
			print("PAPPARDELLE")
			#card_in_slot.update_card_sprite2D_back_texture()
			#card_visual.texture = card_in_slot.sprite2D.texture
			#self.update(card_in_slot)
			#card_in_slot.clickable = true
	#MemeoryManager.check_reset(card_visual)
			
func cover_cards():
	for card in MemeoryManager.picked:
		card.update_card_sprite2D_back_texture()
		card.clickable = true
		card_visual.texture = card.sprite2D.texture
