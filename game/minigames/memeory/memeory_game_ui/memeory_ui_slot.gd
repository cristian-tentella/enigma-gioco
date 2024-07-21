extends Control
class_name MemeoryUISlot

@onready var panel : Panel = $CenterContainer/Panel

@onready var card_visual: Sprite2D = $CenterContainer/Panel/Sprite
@onready var pickablearea: CollisionShape2D = $CenterContainer/Panel/Sprite/Area2D/CollisionShape2D
@onready var button : Button = $CenterContainer/Panel/Button
var card_in_slot : Card


#Funzione chiamata ogni volta che memeory ha qualche cambiamento, quindi il singolo slot si gestisce da solo
func update(slot: Card):
	if (!slot):
		card_visual.visible = false
		button.hide()
	else:
		card_visual.visible = true
		card_visual.texture = slot.sprite2D.texture #Nello slot ci metto la texture dell'item
		card_in_slot = slot
		card_in_slot.index = slot.index
		pickablearea.shape = slot.area.shape
		button.icon = slot.button.icon
		if(MemeoryManager.clicks == -1):
			button.hide()
		if(MemeoryManager.clicks == 0):
			button.show()


func _on_button_pressed():
	if(MemeoryManager.clicks < 2):
		print_debug("premuto")
		AudioManager.play_click_sound_effect()
		MemeoryManager.clicks += 1
		button.hide()
		card_in_slot.update_card_sprite2D_front_texture()
		card_visual.texture = card_in_slot.sprite2D.texture
		MemeoryManager.insert_pick(card_in_slot)
		if(MemeoryManager.picked.size()==2):
			MemeoryManager.check()
