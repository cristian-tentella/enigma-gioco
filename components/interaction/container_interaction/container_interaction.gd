"""
Interazioni che hanno a che fare con Container (qualcosa che si apre/chiude)

Per ora gestisce solo animazione di apertura e chiusura, in particolare delle Door
"""

class_name ContainerInteraction
extends Interaction


@export var animated_sprite: AnimatedSprite2D
@export var open_animation: String
@export var close_animation: String
var container_involved: MyContainer #L'oggetto di tipo container su cui è stata avviata l'interazione. Ad esempio, la porta su cui clicco

func handle_interaction():
	container_involved = get_parent() #Assegnazione del container. SE NON FUNZIONA E' SBAGLIATA LA STRUTTURA DELLA SCENA!
	#Ogni container deve avere ContainerInteraction come figlio diretto
	if container_involved.is_locked == false:
		_handle_open_close_animation()
	else:
		container_involved.try_to_unlock()
		

func _handle_open_close_animation():
	"""Se è aperto fai animazione per chiuderlo, e viceversa"""
	if self.animated_sprite.animation == self.open_animation:
		self.animated_sprite.animation = self.close_animation
	else:
		self.animated_sprite.animation = self.open_animation