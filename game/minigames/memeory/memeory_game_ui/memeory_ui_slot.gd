extends Control
class_name MemeoryUISlot

#@onready var panel : Panel = $CenterContainer/Panel

@onready var card_visual: TextureRect = $CenterContainer/TextureRect
@onready var button : Button = $Button
var card_in_slot : Card


#Funzione chiamata ogni volta che memeory ha qualche cambiamento, quindi il singolo slot si gestisce da solo
func update(slot: Card):
	#print_debug(MemeoryManager.clicks)
	if (!slot):
		card_visual.visible = false
		button.hide()
	else:
		card_visual.visible = true
		card_visual.texture = slot.textureRect.texture #Nello slot ci metto la texture dell'item
		card_in_slot = slot
		card_in_slot.index = slot.index
		#card_in_slot.button = slot.button
		#button.icon = slot.button.icon
		if(MemeoryManager.clicks == -1):
			button.hide()
		if(MemeoryManager.clicks == 0):
			button.show()


func _on_button_pressed():
	if(MemeoryManager.clicks < 2):
		#print_debug("premuto")
		AudioManager.play_click_sound_effect()
		MemeoryManager.clicks += 1
		button.hide()
		card_in_slot.update_card_sprite2D_front_texture()
		card_visual.texture = card_in_slot.textureRect.texture
		MemeoryManager.insert_pick(card_in_slot)
		if(MemeoryManager.picked.size()==2):
			MemeoryManager.check()
