extends Control
class_name MemeoryUISlot

@onready var panel : Panel = $CenterContainer/Panel

@onready var card_visual: Sprite2D = $CenterContainer/Panel/Sprite
@onready var button : Button = $CenterContainer/Panel/Button
@onready var pickablearea: CollisionShape2D = $CenterContainer/Panel/Sprite/Area2D/CollisionShape2D
#var button

#Funzione chiamata ogni volta che memeory ha qualche cambiamento, quindi il singolo slot si gestisce da solo
func update(slot: Card):
	if !slot:
		card_visual.visible = false
	else:
		card_visual.visible = true
		card_visual.texture = slot.sprite2D.texture #Nello slot ci metto la texture dell'item
		#print_debug(slot.area)
		pickablearea.shape = slot.area.shape
		#print_debug(pickablearea.shape)
		
		#print_debug(slot.button)
		button.icon = slot.button.icon
		button.text = slot.button.text
		$CenterContainer/Panel/Button.show()
		
		#print_debug(button)
		#print_debug(button.text)
		
 


func _on_button_pressed():
	print_debug("ciao2") # Replace with function body.



