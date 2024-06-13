"""
Interazioni che hanno a che fare con Container (qualcosa che si apre/chiude)

Per ora gestisce solo animazione di apertura e chiusura, in particolare delle Door
"""

class_name ContainerInteraction
extends Interaction


@export var animated_sprite: AnimatedSprite2D
@export var open_animation: String
@export var close_animation: String

func handle_interaction():
	_handle_open_close_animation()

func _handle_open_close_animation():
	"""Se è aperto fai animazione per chiuderlo, e viceversa"""
	if self.animated_sprite.animation == self.open_animation:
		self.animated_sprite.animation = self.close_animation
	else:
		self.animated_sprite.animation = self.open_animation


